import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/commons/widgets/login%20&%20signup/formdivider.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/utils/constants/Size.dart';
import 'package:pmis/utils/constants/images_strings.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/validators/validators.dart';

class loginForm extends StatelessWidget {
  const loginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    // final controller = Get.put(LoginController());
    return Form(
      // key: controller.loginFormStatekey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Tsizes.sm),
        child: Column(
          children: [
            // email
            TextFormField(
              validator: (value) => TValidator.validateEmail(value),
              keyboardType: TextInputType.emailAddress,
              //  controller: controller.email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: "Username",
              ),
            ),
            const SizedBox(height: Tsizes.spaceBtwInputFields / 2),
            // Password
            // Obx(
            //   () =>
            TextFormField(
              //controller: controller.password,
              obscureText: true, // controller.hidepassword.value,
              validator: (value) =>
                  TValidator.validatePlainText("Password", value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: "Password",
                suffixIcon: IconButton(
                    onPressed: () {}, // controller.hidepassword.value =
                    // !controller.hidepassword.value,
                    icon: const Icon(//controller.hidepassword.value
                        //   ? Iconsax.eye_slash
                        Iconsax.eye)),
              ),
              //),
            ),
            const SizedBox(height: Tsizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => const NavigationMenu(),
                  );
                },
                child: const Text("Login"),
              ),
            ),
            const SizedBox(height: Tsizes.md),

            Tdivider(dark: dark, label: "Powered by"),
            const SizedBox(height: Tsizes.md),

            Image.asset(width: 110.w, TImagestring.ftlogo),
            // remember me and forget password
          ],
        ),
      ),
    );
  }
}
