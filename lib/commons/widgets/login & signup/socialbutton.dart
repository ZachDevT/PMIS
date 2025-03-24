import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/images_strings.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class loginSocialButtons extends StatelessWidget {
  const loginSocialButtons({
    super.key,
    required this.dark,
    this.ontapGooglesignin,
    this.ontapFacebookSignin,
  });

  final bool dark;
  final VoidCallback? ontapGooglesignin;
  final VoidCallback? ontapFacebookSignin;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: dark ? Tcolors.darkGrey : Tcolors.grey,
            ),
          ),
          child: IconButton(
              onPressed: ontapGooglesignin,
              icon: const Image(
                image: AssetImage(
                  TImagestring.google,
                ),
                width: Tsizes.iconMd * 1.4,
                height: Tsizes.iconMd * 1.4,
              )),
        ),
        const SizedBox(width: Tsizes.spaceBtwItems),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: dark ? Tcolors.darkGrey : Tcolors.grey,
            ),
          ),
          child: IconButton(
              onPressed: ontapFacebookSignin,
              icon: const Image(
                image: AssetImage(
                  TImagestring.facebook,
                ),
                width: Tsizes.iconMd,
                height: Tsizes.iconMd,
              )),
        )
      ],
    );
  }
}
