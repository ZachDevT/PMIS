import 'package:pmis/features/pmis/css/CssScreen.dart';
import 'package:pmis/features/pmis/gdp/GdpScreen.dart';
import 'package:pmis/features/pmis/gpp/Gpp.dart';
import 'package:pmis/features/pmis/pmsa/PmsaScreen.dart';
import 'package:pmis/features/pmis/rts/screens/RtsScreen.dart';
import 'package:pmis/features/pmis/shiftmarket/screens/ShiftMarketScreen.dart';
import 'package:pmis/features/pmis/enforcement/screens/EnforcementScreen.dart';
import 'package:pmis/features/pmis/sensitizationmeeting/SensitizationMeetingScreen.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/commons/widgets/sync_indicator.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/gdp/controllers/GdpController.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:pmis/features/pmis/rts/controllers/RtsController.dart';
import 'package:pmis/features/pmis/shiftmarket/controllers/ShiftMarketController.dart';
import 'package:pmis/features/pmis/enforcement/controllers/EnforcementController.dart';
import 'package:pmis/features/pmis/sensitizationmeeting/controllers/SensitizationMeetingController.dart';
import 'package:pmis/bindings/generalbindings.dart';
import 'package:pmis/utils/helpers/sync_manager.dart';
import 'package:pmis/utils/controllers/app_init_controller.dart';
import 'package:pmis/data/repositories/CssRepository/CssRepository.dart';
import 'package:pmis/data/repositories/GdpRepository/GdpRepository.dart';
import 'package:pmis/data/repositories/GppRepository/GppRepository.dart';
import 'package:pmis/data/repositories/PmsaRepo/PmsaRepo.dart';
import 'package:pmis/data/repositories/RtsRepository/RtsRepository.dart';
import 'package:pmis/data/repositories/ShiftMarketRepository/ShiftMarketRepository.dart';
import 'package:pmis/data/repositories/EnforcementRepository/EnforcementRepository.dart';
import 'package:pmis/data/repositories/SensitizationMeetingRepository/SensitizationMeetingRepository.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  /// Ensure all controllers and services are registered before screens are created
  void _ensureControllersRegistered() {
    // Ensure core dependencies are registered first
    _ensureCoreDependencies();
    
    // Ensure module controllers are registered
    if (!Get.isRegistered<CssController>()) {
      Get.put(CssController(), permanent: false);
    }
    if (!Get.isRegistered<GppController>()) {
      Get.put(GppController(), permanent: false);
    }
    if (!Get.isRegistered<GdpController>()) {
      Get.put(GdpController(), permanent: false);
    }
    if (!Get.isRegistered<PmsaController>()) {
      Get.put(PmsaController(), permanent: false);
    }
    if (!Get.isRegistered<RtsController>()) {
      Get.put(RtsController(), permanent: false);
    }
    if (!Get.isRegistered<ShiftMarketController>()) {
      Get.put(ShiftMarketController(), permanent: false);
    }
    if (!Get.isRegistered<EnforcementController>()) {
      Get.put(EnforcementController(), permanent: false);
    }
    if (!Get.isRegistered<SensitizationMeetingController>()) {
      Get.put(SensitizationMeetingController(), permanent: false);
    }
  }

  /// Ensure core dependencies (repositories, services, SyncManager) are registered
  void _ensureCoreDependencies() {
    // Re-initialize bindings to ensure all dependencies are registered
    if (!Get.isRegistered<SyncManager>()) {
      final bindings = GeneralBindings();
      bindings.dependencies();
    }
    
    // Ensure all repositories are registered (SyncManager depends on them)
    _ensureRepositoriesRegistered();
    
    // Ensure SyncManager is created (not just lazy-registered)
    if (!Get.isRegistered<SyncManager>()) {
      try {
        // Try to get SyncManager which will trigger lazy creation
        Get.find<SyncManager>();
      } catch (e) {
        // If find fails, put it directly - repositories should be available by now
        Get.put(SyncManager(), permanent: false);
        // Initialize SyncManager after creation
        Future.microtask(() {
          try {
            Get.find<SyncManager>().initialize();
          } catch (_) {}
        });
      }
    } else {
      // If already registered, ensure it's initialized (only if not already initialized)
      try {
        final syncManager = Get.find<SyncManager>();
        if (!syncManager.isInitialized) {
          // Initialize only if not already initialized
          Future.microtask(() => syncManager.initialize());
        }
      } catch (_) {}
    }
    
    // Ensure AppInitController is registered
    if (!Get.isRegistered<AppInitController>()) {
      Get.put(AppInitController(), permanent: false);
    }
  }

  /// Ensure all repositories are registered before SyncManager is created
  void _ensureRepositoriesRegistered() {
    // Import all repository types and ensure they're registered
    // This ensures SyncManager won't fail when accessing repositories
    final bindings = GeneralBindings();
    bindings.dependencies();
    
    // Force instantiation of repositories by trying to find them
    // This ensures they exist before SyncManager tries to access them
    try {
      Get.find<CssRepository>();
      Get.find<GdpRepository>();
      Get.find<GppRepository>();
      Get.find<PmsaRepository>();
      Get.find<RtsRepository>();
      Get.find<ShiftMarketRepository>();
      Get.find<EnforcementRepository>();
      Get.find<SensitizationMeetingRepository>();
    } catch (e) {
      // If any repository is missing, re-initialize bindings
      print('Warning: Some repositories not found, re-initializing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure NavigationController is registered
    if (!Get.isRegistered<NavigationController>()) {
      Get.put(NavigationController());
    }
    
    // Ensure all module controllers are registered before creating screens
    _ensureControllersRegistered();
    
    NavigationController controller = Get.find<NavigationController>();
    final darkmode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: darkmode ? Tcolors.dark : null,
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: darkmode ? Tcolors.dark : Tcolors.softGrey,
            boxShadow: [
              BoxShadow(
                color: darkmode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: NavigationBar(
            labelPadding: const EdgeInsets.all(0),
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: darkmode ? Tcolors.white : Tcolors.dark,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            indicatorColor: darkmode
                ? Tcolors.primary.withOpacity(0.4)
                : Tcolors.primary.withOpacity(0.3),
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            height: 60,
            destinations: const [
              NavigationDestination(
                  icon: Icon(HugeIcons.strokeRoundedMedicineBottle02, size: 16),
                  selectedIcon: Icon(HugeIcons.strokeRoundedMedicineBottle02,
                      color: Colors.white, size: 14),
                  label: "CSS"),
              NavigationDestination(
                  icon: Icon(HugeIcons.strokeRoundedMedicine02, size: 16),
                  selectedIcon: Icon(HugeIcons.strokeRoundedMedicine02,
                      color: Colors.white, size: 14),
                  label: "GPP"),
              NavigationDestination(
                  icon:
                      Icon(HugeIcons.strokeRoundedDeliveryTracking01, size: 14),
                  selectedIcon: Icon(HugeIcons.strokeRoundedDeliveryTracking01,
                      color: Colors.white, size: 14),
                  label: "GDP"),
              NavigationDestination(
                  icon: Icon(Iconsax.activity, size: 14),
                  selectedIcon:
                      Icon(Iconsax.activity, color: Colors.white, size: 14),
                  label: "PMSA"),
              NavigationDestination(
                  icon: Icon(HugeIcons.strokeRoundedRadio, size: 14),
                  selectedIcon: Icon(HugeIcons.strokeRoundedRadio,
                      color: Colors.white, size: 14),
                  label: "RTS"),
              NavigationDestination(
                  icon: Icon(Iconsax.shop, size: 14),
                  selectedIcon:
                      Icon(Iconsax.shop, color: Colors.white, size: 14),
                  label: "SM"),
              NavigationDestination(
                  icon: Icon(HugeIcons.strokeRoundedSecurity, size: 16),
                  selectedIcon: Icon(HugeIcons.strokeRoundedSecurity,
                      color: Colors.white, size: 14),
                  label: "Enf."),
              NavigationDestination(
                  icon: Icon(Iconsax.people, size: 14),
                  selectedIcon:
                      Icon(Iconsax.people, color: Colors.white, size: 14),
                  label: "Sens."),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Sync indicator shows at the top when there are pending items
          const SyncIndicator(),
          // Main content
          Expanded(
            child:
                Obx(() => controller.screens[controller.selectedIndex.value]),
          ),
        ],
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<int> unreadMessagesCount = 0.obs;

  List<Widget> get screens {
    List<Widget> baseScreens = [
      CssScreen(),
      GppScreen(),
      GdpScreen(),
      PmsaScreen(),
      RtsScreen(),
      ShiftMarketScreen(),
      EnforcementScreen(),
      SensitizationMeetingScreen(),
    ];

    return baseScreens;
  }
}
