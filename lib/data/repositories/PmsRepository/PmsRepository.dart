import 'package:get/get.dart';
import 'package:pmis/data/services/pms/PmsService.dart';

class PmsRepository extends GetxController {
  final PmsService _service = Get.find<PmsService>();

  Future<List<Map<String, dynamic>>> getPmsData() async {
    return await _service.getPmsData();
  }

  Future<Map<String, dynamic>> postPmsData(Map<String, dynamic> data) async {
    return await _service.postPmsData(data);
  }
}
