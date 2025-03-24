import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmis/utils/constants/images_strings.dart';


final loginControllerProvider =
    StateNotifierProvider<LoginController, int>((ref) {
  return LoginController();
});

class LoginController extends StateNotifier<int> {
  LoginController() : super(0) {
    pageController = PageController()
      ..addListener(() {
        state = pageController.page?.round() ?? 0;
      });

    autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        int nextPage = state + 1;
        if (nextPage >= slides.length) {
          nextPage = 0;
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  late final PageController pageController;
  Timer? autoSlideTimer;

  final List<Slide> slides = [
    Slide(
      image: TImagestring.nda,
      title: "NDA",
      subtitle: "National Drug Authority",
    ),
    
  ];

  @override
  void dispose() {
    autoSlideTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}

class Slide {
  final String image;
  final String title;
  final String subtitle;

  Slide({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
