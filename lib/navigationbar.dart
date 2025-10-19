import 'package:pmis/features/pmis/css/CssScreen.dart';
import 'package:pmis/features/pmis/gdp/GdpScreen.dart';
import 'package:pmis/features/pmis/gpp/Gpp.dart';
import 'package:pmis/features/pmis/pmsa/PmsaScreen.dart';
import 'package:pmis/features/pmis/rts/screens/RtsScreen.dart';
import 'package:pmis/features/pmis/shiftmarket/screens/ShiftMarketScreen.dart';
import 'package:pmis/features/pmis/enforcement/screens/EnforcementScreen.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/commons/widgets/sync_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
            labelPadding: EdgeInsets.all(0),
            labelTextStyle: MaterialStateProperty.all(
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
                  icon: Icon(HugeIcons.strokeRoundedMedicineBottle02, size: 17),
                  selectedIcon: Icon(HugeIcons.strokeRoundedMedicineBottle02,
                      color: Colors.white, size: 17),
                  label: "CSS"),
              NavigationDestination(
                  icon: Icon(HugeIcons.strokeRoundedMedicine02, size: 17),
                  selectedIcon: Icon(HugeIcons.strokeRoundedMedicine02,
                      color: Colors.white, size: 17),
                  label: "GPP"),
              NavigationDestination(
                  icon:
                      Icon(HugeIcons.strokeRoundedDeliveryTracking01, size: 17),
                  selectedIcon: Icon(HugeIcons.strokeRoundedDeliveryTracking01,
                      color: Colors.white, size: 17),
                  label: "GDP"),
              NavigationDestination(
                  icon: Icon(Iconsax.activity, size: 17),
                  selectedIcon:
                      Icon(Iconsax.activity, color: Colors.white, size: 17),
                  label: "PMSA"),
              NavigationDestination(
                  icon: Icon(HugeIcons.strokeRoundedRadio, size: 17),
                  selectedIcon: Icon(HugeIcons.strokeRoundedRadio,
                      color: Colors.white, size: 17),
                  label: "RTS"),
              NavigationDestination(
                  icon: Icon(Iconsax.shop, size: 17),
                  selectedIcon:
                      Icon(Iconsax.shop, color: Colors.white, size: 17),
                  label: "SM"),
              NavigationDestination(
                  icon: Icon(HugeIcons.strokeRoundedSecurity, size: 17),
                  selectedIcon: Icon(HugeIcons.strokeRoundedSecurity,
                      color: Colors.white, size: 17),
                  label: "Enf."),
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
    ];

    return baseScreens;
  }
}
