import 'package:pmis/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TelevatedButton {
  TelevatedButton._();

  static final lightElevatedBoutontheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        foregroundColor: Tcolors.Light,
        backgroundColor: Tcolors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        disabledBackgroundColor: Tcolors.grey,
        disabledForegroundColor: Tcolors.grey,
        elevation: 0,
        textStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Tcolors.Light,
            fontSize: 16,
            fontWeight: FontWeight.w400)),
  );
  static final darkElevatedBoutontheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        foregroundColor: Tcolors.white,
        backgroundColor: Tcolors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        disabledBackgroundColor: Tcolors.grey,
        disabledForegroundColor: Tcolors.grey,
        elevation: 0,
        textStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Tcolors.Light,
            fontSize: 16,
            fontWeight: FontWeight.w400)),
  );
}
