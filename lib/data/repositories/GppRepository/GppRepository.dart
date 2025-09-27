import 'package:get/get.dart';
import 'package:pmis/data/services/gpp/GppService.dart';

class GppRepository {
  final GppService _service = Get.find<GppService>();

  /// Fetch GPP data from the API
  Future<List<Map<String, dynamic>>> getGppData() {
    return _service.getGppData();
  }

  /// Post GPP data to the API
  Future<Map<String, dynamic>> postGppData(Map<String, dynamic> gppData) {
    return _service.postGppData(gppData);
  }
}
