import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/pms/PmsService.dart';

class PmsRepository extends GetxController {
  final PmsService _service = Get.find<PmsService>();
  final box = GetStorage();

  Future<List<Map<String, dynamic>>> getPmsData() async {
    List<Map<String, dynamic>> onlineData = [];
      try {
        onlineData = await _service.getPmsData();
      } catch(e) {
        print('Service fetch error: $e');
      }
      
      // Merge with local unsynced activities
      List storedActivities = box.read<List>('pms_activities') ?? [];
      
      final Map<String, Map<String, dynamic>> mergedMap = {};
      for (var item in onlineData) {
        if (item['id'] != null) {
          mergedMap[item['id'].toString()] = item;
        }
      }
      for (var item in storedActivities) {
        if (item['id'] != null) {
          mergedMap[item['id'].toString()] = Map<String, dynamic>.from(item);
        }
      }
      
      return mergedMap.values.toList();
  }

  Future<Map<String, dynamic>> postPmsData(Map<String, dynamic> data) async {
    return await _service.postPmsData(data);
  }
}
