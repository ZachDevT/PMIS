import 'package:flutter/services.dart';
import 'package:pmis/bindings/generalbindings.dart';
import 'package:pmis/features/authentification/screens/login/LoginSlider.dart';
import 'package:pmis/utils/constants/Size.dart';

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TApptheme.lighttheme,
      darkTheme: TApptheme.darktheme,
      themeMode: ThemeMode.system,
      initialBinding: GeneralBindings(),
      // getPages: AppRoutes.pages,
      home: const LoginSliderScreen(),
    );
  }
}
