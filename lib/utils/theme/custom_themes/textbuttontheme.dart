import 'package:pmis/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TTextButtontheme {
  TTextButtontheme._();

  static final lightTextBoutontheme = TextButtonThemeData(
    style: TextButton.styleFrom(
        textStyle: TextStyle(
      color: Tcolors.dark.withOpacity(0.8),
    )),
  );
  static final darkTextBoutontheme = TextButtonThemeData(
    style: TextButton.styleFrom(
        textStyle: TextStyle(
      color: Tcolors.Light.withOpacity(0.8),
    )),
  );
}
