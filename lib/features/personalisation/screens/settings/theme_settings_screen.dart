import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/features/personalisation/controllers/theme_controller.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final themeController = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : ThemeController();

    return Scaffold(
      backgroundColor: dark ? Tcolors.dark : Tcolors.softGrey,
      appBar: AppBar(
        backgroundColor: themeController.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Theme Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Tsizes.defaultSpace),
        child: Column(
          children: [
            // Theme Mode Selection
            _buildThemeSection(context, dark, themeController),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Color Customization
            _buildColorSection(context, dark, themeController),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Preview Section
            _buildPreviewSection(context, dark),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(
      BuildContext context, bool dark, ThemeController themeController) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Tcolors.darkerGrey : Colors.white,
        borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            child: Text(
              'Theme Mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildThemeOption(
            context: context,
            dark: dark,
            themeController: themeController,
            icon: HugeIcons.strokeRoundedSun01,
            title: 'Light Mode',
            subtitle: 'Clean and bright interface',
            isSelected: !themeController.isDarkMode,
            onTap: () => themeController.setThemeMode(ThemeMode.light),
          ),
          _buildDivider(dark),
          _buildThemeOption(
            context: context,
            dark: dark,
            themeController: themeController,
            icon: HugeIcons.strokeRoundedMoon01,
            title: 'Dark Mode',
            subtitle: 'Easy on the eyes in low light',
            isSelected: themeController.isDarkMode,
            onTap: () => themeController.setThemeMode(ThemeMode.dark),
          ),
          _buildDivider(dark),
          _buildThemeOption(
            context: context,
            dark: dark,
            themeController: themeController,
            icon: HugeIcons.strokeRoundedDeviceAccess,
            title: 'System Default',
            subtitle: 'Follow system theme',
            isSelected: false,
            onTap: () => themeController.setThemeMode(ThemeMode.system),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required bool dark,
    required ThemeController themeController,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Tsizes.defaultSpace),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? themeController.primaryColor.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? themeController.primaryColor
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? themeController.primaryColor
                    : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: Tsizes.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? themeController.primaryColor
                              : (dark ? Colors.white : Tcolors.dark),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: dark ? Colors.grey[400] : Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: themeController.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(
      BuildContext context, bool dark, ThemeController themeController) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Tcolors.darkerGrey : Colors.white,
        borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            child: Text(
              'Accent Color',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Tsizes.defaultSpace),
            child: Text(
              'Choose your preferred accent color',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: dark ? Colors.grey[400] : Colors.grey[600],
                  ),
            ),
          ),
          const SizedBox(height: Tsizes.spaceBtwItems),
          Padding(
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildColorOption(
                    context, themeController, const Color(0xFF2196F3), false),
                _buildColorOption(
                    context, themeController, const Color(0xFF4CAF50), false),
                _buildColorOption(
                    context, themeController, const Color(0xFFFF9800), false),
                _buildColorOption(
                    context, themeController, const Color(0xFF9C27B0), false),
                _buildColorOption(
                    context, themeController, const Color(0xFFF44336), false),
                _buildColorOption(
                    context, themeController, const Color(0xFF00BCD4), false),
                _buildColorOption(
                    context, themeController, const Color(0xFFE91E63), false),
                _buildColorOption(
                    context, themeController, const Color(0xFF795548), false),
                _buildColorOption(
                    context, themeController, Tcolors.warning, false),
                _buildColorOption(
                    context, themeController, Tcolors.buttonPrimary, false),
                _buildColorOption(
                    context, themeController, const Color(0xFF3F51B5), false),
                _buildColorOption(
                    context, themeController, const Color(0xFF28d67c), false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(BuildContext context,
      ThemeController themeController, Color color, bool isSelected) {
    final isCurrentlySelected =
        color.toARGB32() == themeController.primaryColor.toARGB32();

    return GestureDetector(
      onTap: () {
        themeController.setPrimaryColor(color);
        Get.snackbar(
          'Color Changed',
          'Accent color updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: color,
          colorText: Colors.white,
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCurrentlySelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isCurrentlySelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              )
            : null,
      ),
    );
  }

  Widget _buildPreviewSection(BuildContext context, bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Tcolors.darkerGrey : Colors.white,
        borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            child: Text(
              'Preview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Tsizes.defaultSpace),
            child: Text(
              'See how your theme looks',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: dark ? Colors.grey[400] : Colors.grey[600],
                  ),
            ),
          ),
          const SizedBox(height: Tsizes.spaceBtwItems),
          Container(
            margin: const EdgeInsets.all(Tsizes.defaultSpace),
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            decoration: BoxDecoration(
              color: dark ? Tcolors.dark : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: dark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Tcolors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sample Card',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: dark ? Colors.white : Colors.black87,
                                ),
                          ),
                          Text(
                            'This is how your theme looks',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: dark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: dark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Tcolors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Sample Button',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool dark) {
    return Divider(
      height: 1,
      color: dark ? Colors.grey[700] : Colors.grey[300],
      indent: Tsizes.defaultSpace + 50 + Tsizes.spaceBtwItems,
    );
  }
}
