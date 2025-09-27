import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/commons/widgets/login%20&%20signup/formdivider.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';
import 'package:pmis/utils/constants/Size.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/images_strings.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/validators/validators.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Form key & text controllers
  final _formKey = GlobalKey<FormState>();
  final _userTEC = TextEditingController();
  final _passTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Tsizes.sm),
          child: Column(
            children: [
              // Show error if any
              if (authC.errorMessage.value.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: Tsizes.sm),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Get.theme.colorScheme.error.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.warning_2,
                        color: Get.theme.colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authC.errorMessage.value,
                          style: TextStyle(
                            color: Get.theme.colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => authC.clearError(),
                        icon: Icon(
                          Iconsax.close_circle,
                          color: Get.theme.colorScheme.error,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

              // Username
              TextFormField(
                controller: _userTEC,
                onChanged: (value) => authC.updateUsername(value),
                validator: (value) =>
                    TValidator.validatePlainText("Username", value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.direct_right),
                  labelText: "Username",
                  errorText: authC.isUsernameValid.value
                      ? null
                      : "Username is required",
                ),
              ),
              const SizedBox(height: Tsizes.spaceBtwInputFields / 2),

              // Password
              Obx(() => TextFormField(
                    controller: _passTEC,
                    onChanged: (value) => authC.updatePassword(value),
                    obscureText: true,
                    validator: (value) =>
                        TValidator.validatePlainText("Password", value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.password_check),
                      labelText: "Password",
                      errorText: authC.isPasswordValid.value
                          ? null
                          : "Password is required",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Iconsax.eye),
                      ),
                    ),
                  )),
              const SizedBox(height: Tsizes.spaceBtwSections),

              // Login button / spinner
              SizedBox(
                width: double.infinity,
                child: authC.isLoading.value
                    ? Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Tcolors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Tcolors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Logging in...',
                                style: TextStyle(
                                  color: Tcolors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Obx(() => ElevatedButton(
                          onPressed: authC.isFormValid
                              ? () => _handleLogin(authC)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: authC.isFormValid
                                ? Tcolors.primary
                                : Tcolors.primary.withOpacity(0.5),
                            foregroundColor: Get.theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
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

  void _handleLogin(AuthController authC) {
    if (_formKey.currentState!.validate()) {
      authC.login();
    }
  }

  @override
  void dispose() {
    _userTEC.dispose();
    _passTEC.dispose();
    super.dispose();
  }
}
