import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/commons/widgets/login%20&%20signup/formdivider.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/utils/constants/Size.dart';
import 'package:pmis/utils/constants/images_strings.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/validators/validators.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);

  // Form key & text controllers
  final _formKey = GlobalKey<FormState>();
  final _userTEC = TextEditingController();
  final _passTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Tsizes.sm),
          child: Column(
            children: [
              // show error if any
              if (authC.errorMessage.value != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: Tsizes.sm),
                  child: Text(
                    authC.errorMessage.value!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Username
              TextFormField(
                controller: _userTEC,
                validator: (value) =>
                    TValidator.validatePlainText("Username", value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: "Username",
                ),
              ),
              const SizedBox(height: Tsizes.spaceBtwInputFields / 2),

              // Password
              TextFormField(
                controller: _passTEC,
                obscureText: true,
                validator: (value) =>
                    TValidator.validatePlainText("Password", value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.eye),
                  ),
                ),
              ),
              const SizedBox(height: Tsizes.spaceBtwSections),

              // Login button / spinner
              SizedBox(
                width: double.infinity,
                child: authC.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          // validate & trigger login
                          if (_formKey.currentState!.validate()) {
                            authC.login(
                              _userTEC.text.trim(),
                              _passTEC.text.trim(),
                            );
                          }
                        },
                        child: const Text("Login"),
                      ),
              ),
              const SizedBox(height: Tsizes.md),

              // Divider + branding
              Tdivider(dark: dark, label: "Powered by"),
              const SizedBox(height: Tsizes.md),
              Image.asset(width: 110.w, TImagestring.ftlogo),
            ],
          ),
        ),
      );
    });
  }
}
