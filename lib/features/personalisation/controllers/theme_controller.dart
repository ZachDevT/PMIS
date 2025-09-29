import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  // Variables
  final _storage = GetStorage();
  final _darkModeKey = 'isDarkMode';
  final _primaryColorKey = 'primaryColor';

  // Getters
  bool get isDarkMode => _storage.read(_darkModeKey) ?? false;
  Color get primaryColor => Color(_storage.read(_primaryColorKey) ?? 0xFF2196F3);

  @override
  void onInit() {
    super.onInit();
    // Don't change theme during initialization to avoid build conflicts
  }

  // Toggle theme
  void toggleTheme() {
    final isDark = !isDarkMode;
    _storage.write(_darkModeKey, isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // Set theme mode
  void setThemeMode(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    _storage.write(_darkModeKey, isDark);
    Get.changeThemeMode(mode);
  }

  // Set primary color
  void setPrimaryColor(Color color) {
    _storage.write(_primaryColorKey, color.value);
    // Update the app theme with new primary color
    _updateAppTheme();
  }

  // Update app theme with current settings
  void _updateAppTheme() {
    // Force a complete app rebuild to apply new colors
    Get.forceAppUpdate();
  }

  // Get current theme mode
  ThemeMode get currentThemeMode {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
