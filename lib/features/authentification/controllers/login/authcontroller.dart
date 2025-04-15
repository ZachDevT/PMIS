import 'package:get/get.dart';
import 'package:pmis/data/repositories/LoginRepository/LoginRepository.dart';
import 'package:pmis/navigationbar.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = Get.put(AuthRepository());

  // reactive state
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final user = Rxn<Map<String, dynamic>>();

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await _repo.login(username, password);
      user.value = result;
      // you could also persist token here
      // e.g. await SecureStorage.write('token', result['token']);
      // navigate to dashboard
      Get.off(() => NavigationMenu());
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
