import 'package:pmis/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Ttextfieldtheme {
  Ttextfieldtheme._();

  static InputDecorationTheme lightInputTextDecorationTheme =
      InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Tcolors.darkGrey,
    suffixIconColor: Tcolors.darkGrey,
    filled: true,
    fillColor: Tcolors.grey.withOpacity(0.4),
    labelStyle:
        const TextStyle().copyWith(color: Tcolors.darkGrey, fontSize: 14),
    hintStyle: const TextStyle().copyWith(
      color: Tcolors.darkGrey,
      fontSize: 14,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Colors.black.withOpacity(0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Tcolors.grey.withOpacity(0.4)),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Tcolors.grey.withOpacity(0.4)),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.black12),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );

  static InputDecorationTheme darkInputTextDecorationTheme =
      InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Tcolors.darkGrey,
    suffixIconColor: Tcolors.darkGrey,
    filled: true,
    fillColor: Tcolors.dark.withOpacity(0.5),
    labelStyle: const TextStyle().copyWith(color: Tcolors.Light, fontSize: 14),
    hintStyle: const TextStyle().copyWith(color: Tcolors.Light, fontSize: 14),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Tcolors.Light.withOpacity(0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Tcolors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Tcolors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Tcolors.Light),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Tcolors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 2, color: Tcolors.warning),
    ),
  );
}
