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
import 'package:pmis/data/services/rts/RtsService.dart';
import 'package:pmis/data/repositories/RtsRepository/RtsRepository.dart';
import 'package:pmis/data/services/shiftmarket/ShiftMarketService.dart';
import 'package:pmis/data/repositories/ShiftMarketRepository/ShiftMarketRepository.dart';
import 'package:pmis/data/services/enforcement/EnforcementService.dart';
import 'package:pmis/data/repositories/EnforcementRepository/EnforcementRepository.dart';
import 'package:pmis/data/services/sensitizationmeeting/SensitizationMeetingService.dart';
import 'package:pmis/data/repositories/SensitizationMeetingRepository/SensitizationMeetingRepository.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';
import 'package:pmis/features/authentification/controllers/login/LoginSliderController.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/gdp/controllers/GdpController.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:pmis/features/pmis/rts/controllers/RtsController.dart';
import 'package:pmis/features/pmis/shiftmarket/controllers/ShiftMarketController.dart';
import 'package:pmis/features/pmis/enforcement/controllers/EnforcementController.dart';
import 'package:pmis/features/pmis/sensitizationmeeting/controllers/SensitizationMeetingController.dart';
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

    // RTS services
    Get.lazyPut<RtsService>(() => RtsService());
    Get.lazyPut<RtsRepository>(() => RtsRepository());

    // Shift Market services
    Get.lazyPut<ShiftMarketService>(() => ShiftMarketService());
    Get.lazyPut<ShiftMarketRepository>(() => ShiftMarketRepository());

    // Enforcement services
    Get.lazyPut<EnforcementService>(() => EnforcementService());
    Get.lazyPut<EnforcementRepository>(() => EnforcementRepository());

    // Sensitization Meeting services
    Get.lazyPut<SensitizationMeetingService>(() => SensitizationMeetingService());
    Get.lazyPut<SensitizationMeetingRepository>(() => SensitizationMeetingRepository());

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
    Get.lazyPut<RtsController>(() => RtsController());
    Get.lazyPut<ShiftMarketController>(() => ShiftMarketController());
    Get.lazyPut<EnforcementController>(() => EnforcementController());
    Get.lazyPut<SensitizationMeetingController>(() => SensitizationMeetingController());
  }
}
