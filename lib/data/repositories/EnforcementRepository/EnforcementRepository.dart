import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/enforcement/EnforcementService.dart';

class EnforcementRepository {
  final EnforcementService _service = Get.find<EnforcementService>();
  final box = GetStorage();

  /// Fetch Enforcement data from the API
  Future<List<Map<String, dynamic>>> getEnforcementData() {
    return _service.getEnforcementData();
  }

  /// Post Enforcement data to the API
  Future<Map<String, dynamic>> postEnforcementData(Map<String, dynamic> enforcementData) {
    return _service.postEnforcementData(enforcementData);
  }

  /// Save a Enforcement activity locally when offline
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('enforcement_activities') ?? [];
      storedActivities.add(activityData);
      await box.write('enforcement_activities', storedActivities);
      print('Enforcement activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving Enforcement activity locally: $e');
    }
  }

  /// Sync locally stored Enforcement activities to API when online
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('enforcement_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      
      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postEnforcementData(activityData);
            print('Enforcement activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync Enforcement activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }
        
        // Remove successfully synced activities, keep failed ones
        await box.write('enforcement_activities', failedSyncs);
      }
      
      return storedActivities.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error syncing local Enforcement activities: $e');
      return [];
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    try {
      List storedActivities = box.read<List>('enforcement_activities') ?? [];
      return storedActivities.length;
    } catch (e) {
      print('Error getting offline Enforcement activities count: $e');
      return 0;
    }
  }

  /// Add a new Enforcement activity directly when there is network
  Future<void> addActivity(Map<String, dynamic> activityData) async {
    try {
      await _service.postEnforcementData(activityData);
      print('Enforcement activity added successfully: ${activityData['id']}');
    } catch (e) {
      print('Error adding Enforcement activity: $e');
      // Save locally if network fails
      await saveActivityLocally(activityData);
    }
  }
}
