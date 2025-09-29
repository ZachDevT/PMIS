import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/helpers/sync_manager.dart';
import 'package:pmis/utils/controllers/app_init_controller.dart';
import 'package:pmis/data/services/auth/AuthService.dart';
import 'package:pmis/data/repositories/LoginRepository/LoginRepository.dart';
import 'package:pmis/data/services/gpp/GppService.dart';
import 'package:pmis/data/repositories/GppRepository/GppRepository.dart';
import 'package:pmis/data/services/css/CssService.dart';
import 'package:pmis/data/repositories/CssRepository/CssRepository.dart';
import 'package:pmis/data/services/pms/PmsService.dart';
import 'package:pmis/data/repositories/PmsRepository/PmsRepository.dart';
import 'package:pmis/data/services/gdp/GdpService.dart';
import 'package:pmis/data/repositories/GdpRepository/GdpRepository.dart';
import 'package:pmis/data/repositories/PmsaRepo/PmsaRepo.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';
import 'package:pmis/features/authentification/controllers/login/LoginSliderController.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/gdp/controllers/GdpController.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:pmis/features/personalisation/controllers/theme_controller.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<NetworkManager>(() => NetworkManager());

    // Auth services
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    
    // GPP services
    Get.lazyPut<GppService>(() => GppService());
    Get.lazyPut<GppRepository>(() => GppRepository());

    // CSS services
    Get.lazyPut<CssService>(() => CssService());
    Get.lazyPut<CssRepository>(() => CssRepository());

    // PMS services
    Get.lazyPut<PmsService>(() => PmsService());
    Get.lazyPut<PmsRepository>(() => PmsRepository());

    // GDP services
    Get.lazyPut<GdpService>(() => GdpService());
    Get.lazyPut<GdpRepository>(() => GdpRepository());

    // PMS-A services
    Get.lazyPut<PmsaRepository>(() => PmsaRepository());

    // Sync Manager
    Get.lazyPut<SyncManager>(() => SyncManager());

    // App Initialization Controller (handles automatic sync)
    Get.put(AppInitController());

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<LoginSliderController>(() => LoginSliderController());
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<ThemeController>(() => ThemeController());

    // PMIS Controllers
    Get.lazyPut<CssController>(() => CssController());
    Get.lazyPut<GdpController>(() => GdpController());
    Get.lazyPut<GppController>(() => GppController());
    Get.lazyPut<PmsaController>(() => PmsaController());
  }
}
