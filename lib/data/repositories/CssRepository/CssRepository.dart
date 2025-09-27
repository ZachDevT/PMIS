import 'package:get/get.dart';
import 'package:pmis/data/services/css/CssService.dart';

class CssRepository extends GetxController {
  final CssService _service = Get.find<CssService>();

  Future<List<Map<String, dynamic>>> getCssData() async {
    return await _service.getCssData();
  }

  Future<Map<String, dynamic>> postCssData(Map<String, dynamic> data) async {
    return await _service.postCssData(data);
  }
}
