import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/commons/widgets/customs_shapes/curved/Curved_edges_widget.dart';
import 'package:pmis/commons/widgets/texts/Section_heading.dart';
import 'package:pmis/features/authentification/controllers/login/LoginSliderController.dart';
import 'package:pmis/features/authentification/screens/login/widgets/login_form.dart';
import 'package:pmis/utils/constants/Size.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';

class LoginSliderScreen extends StatelessWidget {
  const LoginSliderScreen({super.key});
  static const String routeName = "LoginSliderScreenLogin";

  @override
  Widget build(BuildContext context) {
    final LoginSliderController loginController =
        Get.find<LoginSliderController>();
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Tcolors.primaryDark
          : const Color.fromARGB(255, 247, 245, 245),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 350.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView.builder(
                    controller: loginController.pageController,
                    itemCount: loginController.slides.length,
                    itemBuilder: (_, index) => TcurvedWidget(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage(loginController.slides[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Tcolors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              padding:
                                  const EdgeInsets.all(Tsizes.defaultSpace),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    loginController.slides[index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Tcolors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: Tsizes.sm),
                                  Text(
                                    loginController.slides[index].subtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Tcolors.white,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 30.h),
                  _buildIndicatorDots(loginController),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w)
                        .copyWith(bottom: 10),
                    child: const TsectionHeading(headingtitle: "Login"),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: LoginForm()),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorDots(LoginSliderController loginController) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            loginController.slides.length,
            (index) => GestureDetector(
              onTap: () => loginController.goToPage(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: loginController.currentIndex.value == index
                      ? Tcolors.primary
                      : Tcolors.grey,
                ),
              ),
            ),
          ),
        ));
  }
}
