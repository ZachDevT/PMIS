import 'package:get/get.dart';
import 'package:pmis/data/services/auth/AuthService.dart';

class AuthRepository {
  final AuthService _service = Get.put(AuthService());

  Future<Map<String, dynamic>> login(String user, String pass) {
    return _service.login(user, pass);
  }
}
