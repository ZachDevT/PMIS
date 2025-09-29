import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Tcolors {
  Tcolors._();

  //App basic colors
  static const Color _defaultPrimaryColor = Color(0xFF28d67c);

  // Get primary color from storage or use default
  static Color get primary {
    try {
      final storage = GetStorage();
      final primaryColorValue = storage.read('primaryColor');
      return primaryColorValue != null
          ? Color(primaryColorValue)
          : _defaultPrimaryColor;
    } catch (e) {
      return _defaultPrimaryColor;
    }
  }

  static const Color primaryColor = _defaultPrimaryColor;
  static const Color secondary = Color(0xFF5dfd95);
  static const Color secondarySecond = Color.fromARGB(255, 72, 203, 118);
  static const Color accent = Color(0xFFb0c7ff);
  static const Color primarygreen = Color.fromARGB(255, 197, 231, 3);
  static const Color primaryDark = Color.fromARGB(255, 10, 29, 22);

// Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

// Gradient Colors
  static Gradient linerGradient = LinearGradient(
    begin: const Alignment(0.0, 0.0),
    end: const Alignment(0.707, -0.707),
    colors: [
      Tcolors.accent.withOpacity(0.4),
      Tcolors.primary.withOpacity(0.15),
      Tcolors.accent.withOpacity(0.4),
    ],
  );
// LinearGradient

// Background Colors
  static const Color Light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF111111);
  static const Color primaryBackground = Color(0xFFF3F5FF);

// Background Container Colors

  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = Colors.white.withOpacity(0.1);

// Button Colors

  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C404);

// Border Colors

  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

// Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF197602);

// Neutral Shades
  static const Color black = Color.fromARGB(255, 5, 26, 40);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightfrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
