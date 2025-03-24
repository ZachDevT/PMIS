import 'package:pmis/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Toutlinebutton {
  Toutlinebutton._();

  static final lightOutlineBoutontheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        foregroundColor: Tcolors.dark,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        side: const BorderSide(color: Tcolors.grey),
        textStyle: const TextStyle(
            color: Tcolors.dark, fontSize: 16, fontWeight: FontWeight.w400)),
  );
  static final darkOutlineBoutontheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        foregroundColor: Tcolors.Light,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        side: const BorderSide(color: Tcolors.darkGrey),
        textStyle: const TextStyle(
            color: Tcolors.Light, fontSize: 16, fontWeight: FontWeight.w400)),
  );
}
