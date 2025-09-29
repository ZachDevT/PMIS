import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/css/CssService.dart';

class CssRepository extends GetxController {
  final CssService _service = Get.find<CssService>();
  final box = GetStorage();

  Future<List<Map<String, dynamic>>> getCssData() async {
    return await _service.getCssData();
  }

  Future<Map<String, dynamic>> postCssData(Map<String, dynamic> data) async {
    return await _service.postCssData(data);
  }

  /// Save a CSS activity locally when offline
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('css_activities') ?? [];
      storedActivities.add(activityData);
      await box.write('css_activities', storedActivities);
      print('CSS activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving CSS activity locally: $e');
    }
  }

  /// Sync locally stored CSS activities to API when online
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('css_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      
      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postCssData(activityData);
            print('CSS activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync CSS activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }
        
        // Remove successfully synced activities, keep failed ones
        await box.write('css_activities', failedSyncs);
      }
      
      return storedActivities.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error syncing local CSS activities: $e');
      return [];
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities = box.read<List>('css_activities') ?? [];
    return storedActivities.length;
  }
}
