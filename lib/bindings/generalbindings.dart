import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/data/services/auth/AuthService.dart';
import 'package:pmis/data/repositories/LoginRepository/LoginRepository.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';
import 'package:pmis/features/authentification/controllers/login/LoginSliderController.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/gdp/controllers/GdpController.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<NetworkManager>(() => NetworkManager());

    // Auth services
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthRepository>(() => AuthRepository());

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<LoginSliderController>(() => LoginSliderController());
    Get.lazyPut<NavigationController>(() => NavigationController());

    // PMIS Controllers
    Get.lazyPut<CssController>(() => CssController());
    Get.lazyPut<GdpController>(() => GdpController());
    Get.lazyPut<GppController>(() => GppController());
    Get.lazyPut<PmsaController>(() => PmsaController());
  }
}
