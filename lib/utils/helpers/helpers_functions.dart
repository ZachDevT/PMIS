import 'package:pmis/commons/styles/shadow_style.dart';

import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
class THelperFunctions {
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String isoToFrenchDate(String isoString) {
    // Parse the ISO string to a DateTime object
    DateTime dateTime = DateTime.parse(isoString);

    // Define French month abbreviations
    const List<String> frenchMonths = [
      "Jan",
      "Fév",
      "Mar",
      "Avr",
      "Mai",
      "Juin",
      "Juil",
      "Aoû",
      "Sep",
      "Oct",
      "Nov",
      "Déc"
    ];

    // Extract day, month, and year
    int day = dateTime.day;
    String month = frenchMonths[dateTime.month - 1]; // Adjust for 0-based index
    int year = dateTime.year;

    // Format the date as day/month/year
    return "$day/$month/$year";
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];

    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);

      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  // Method to send confirmationOrder to Admin


   

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static OverlayState? overlayState = navigatorKey.currentState?.overlay;
  static void showOverlayNotification(String title, String body) {
    final dark = THelperFunctions.isDarkMode(navigatorKey.currentContext!);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {} //=> Get.to(() => const NotificationsScreen()),
            ,
            child: Container(
              padding: const EdgeInsets.all(Tsizes.defaultSpace),
              decoration: BoxDecoration(
                  color: dark ? Tcolors.dark : Tcolors.softGrey,
                  borderRadius: BorderRadius.circular(Tsizes.md),
                  boxShadow: [
                    Tshadowstyle.horizontalshadowstyle,
                    Tshadowstyle.verticalshadowstyle,
                  ]),
              child: Row(
                children: [
                  const Icon(Iconsax.notification, color: Tcolors.primary),
                  const SizedBox(width: 10.0),
                  SizedBox(
                    width: TDeviceUtils.getScreenWidth(context) / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          body,
                          style: Theme.of(context).textTheme.labelLarge,
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 10), () {
      overlayEntry.remove();
    });
  }

  static String calculateTimeDifference(DateTime notificationTime) {
    final now = DateTime.now();
    final difference = now.difference(notificationTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}Jours';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}Heures';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}Minutes';
    } else {
      return '${difference.inSeconds}Seconds';
    }
  }

  
}
