import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/utils/constants/images_strings.dart';

class LoginSliderController extends GetxController {
  late final PageController pageController;
  Timer? autoSlideTimer;
  
  // Reactive state
  final RxInt currentIndex = 0.obs;

  final List<Slide> slides = [
    Slide(
      image: TImagestring.nda,
      title: "NDA",
      subtitle: "National Drug Authority",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _initializePageController();
    _startAutoSlide();
  }

  void _initializePageController() {
    pageController = PageController();
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
    });
  }

  void _startAutoSlide() {
    autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        int nextPage = currentIndex.value + 1;
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

  /// Manually change page
  void goToPage(int index) {
    if (pageController.hasClients && index < slides.length) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  /// Stop auto slide
  void stopAutoSlide() {
    autoSlideTimer?.cancel();
  }

  /// Resume auto slide
  void resumeAutoSlide() {
    if (autoSlideTimer?.isActive != true) {
      _startAutoSlide();
    }
  }

  @override
  void onClose() {
    autoSlideTimer?.cancel();
    pageController.dispose();
    super.onClose();
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
