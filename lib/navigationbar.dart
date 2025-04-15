import 'package:pmis/features/pmis/css/CssScreen.dart';
import 'package:pmis/features/pmis/gdp/GdpScreen.dart';
import 'package:pmis/features/pmis/gpp/Gpp.dart';
import 'package:pmis/features/pmis/pmsa/PmsaScreen.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController controller = Get.put(NavigationController());
    final darkmode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: darkmode ? Tcolors.dark : null,
      bottomNavigationBar: Obx(
        () => NavigationBar(
          elevation: 0,
          backgroundColor: darkmode ? Tcolors.dark : Tcolors.softGrey,
          indicatorColor: darkmode
              ? Tcolors.primary.withOpacity(0.4)
              : Tcolors.primary.withOpacity(0.3),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(
                icon: Icon(HugeIcons.strokeRoundedMedicineBottle02),
                label: "CSS"),
            NavigationDestination(
                icon: Icon(HugeIcons.strokeRoundedMedicine02), label: "GPP"),
            NavigationDestination(
                icon: Icon(HugeIcons.strokeRoundedDeliveryTracking01),
                label: "GDP"),
            NavigationDestination(
                icon: Icon(Iconsax.activity), label: "PMSA"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
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
    ];

    return baseScreens;
  }
}
