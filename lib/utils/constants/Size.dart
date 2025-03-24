import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

extension ScreenProps on num {
  // Get the proportionate height as per screen size
  double get h {
    double screenHeight = SizeConfig.screenHeight;
    // 812 is the layout height that designer use
    return (this / 844.0) * screenHeight;
  }

  double get w {
    double screenWidth = SizeConfig.screenWidth;
    return (this / 390.0) * screenWidth;
  }
}
