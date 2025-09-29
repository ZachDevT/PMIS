import 'package:flutter/services.dart';
import 'package:pmis/bindings/generalbindings.dart';
import 'package:pmis/features/authentification/screens/login/LoginSlider.dart';
import 'package:pmis/features/personalisation/screens/user_menu/user_menu.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/utils/constants/Size.dart';
import 'package:pmis/utils/local_storage/storage_utility.dart';
import 'package:pmis/utils/helpers/sync_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'package:pmis/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    
    // SyncManager will be initialized when first accessed
    
    // Get stored theme mode and primary color
    final storage = GetStorage();
    final isDarkMode = storage.read('isDarkMode') ?? false;
    final primaryColorValue = storage.read('primaryColor') ?? 0xFF2196F3;
    final primaryColor = Color(primaryColorValue);
    final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TApptheme.lighttheme.copyWith(
        primaryColor: primaryColor,
        colorScheme: TApptheme.lighttheme.colorScheme.copyWith(primary: primaryColor),
      ),
      darkTheme: TApptheme.darktheme.copyWith(
        primaryColor: primaryColor,
        colorScheme: TApptheme.darktheme.colorScheme.copyWith(primary: primaryColor),
      ),
      themeMode: themeMode,
      initialBinding: GeneralBindings(),
      getPages: [
        GetPage(name: '/', page: () => const LoginSliderScreen()),
        GetPage(name: '/navigation', page: () => const NavigationMenu()),
        GetPage(name: '/user-menu', page: () => const UserMenuScreen()),
      ],
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = TLocalStorage();
    final userData = storage.readData<Map<String, dynamic>>('user_data');
    
    // If user data exists, go to dashboard
    if (userData != null) {
      return const NavigationMenu();
    }
    
    // Otherwise, show login screen
    return const LoginSliderScreen();
  }
}
