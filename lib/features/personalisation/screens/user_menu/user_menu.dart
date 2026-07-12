import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';
import 'package:pmis/features/personalisation/screens/settings/app_settings_screen.dart';
import 'package:pmis/features/personalisation/screens/settings/theme_settings_screen.dart';
import 'package:pmis/features/personalisation/screens/settings/notification_settings_screen.dart';
import 'package:pmis/features/personalisation/screens/settings/privacy_security_screen.dart';
import 'package:pmis/features/personalisation/screens/settings/help_support_screen.dart';
import 'package:pmis/features/authentification/screens/login/LoginSlider.dart';

class UserMenuScreen extends StatelessWidget {
  const UserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final authController =
        Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;

    return Scaffold(
      backgroundColor: dark ? Tcolors.dark : Tcolors.softGrey,
      appBar: AppBar(
        backgroundColor: Tcolors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'User Menu',
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
            // User Profile Section
            _buildUserProfileSection(context, dark),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Menu Items
            _buildMenuSection(context, dark, authController),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // App Info Section
            _buildAppInfoSection(context, dark),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context, bool dark) {
    final authController =
        Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Tsizes.defaultSpace),
      decoration: BoxDecoration(
        color: dark ? Tcolors.darkerGrey : Colors.white,
        borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        final displayName = authController?.userDisplayName ?? 'Guest';
        final email = authController?.userEmail ?? '';
        final roleName = authController?.userRoleName ?? 'Unknown';
        
        return Column(
          children: [
            // Profile Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Tcolors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: Tcolors.primary,
                  width: 3,
                ),
              ),
              child: Icon(
                HugeIcons.strokeRoundedUser,
                size: 40,
                color: Tcolors.primary,
              ),
            ),
            const SizedBox(height: Tsizes.spaceBtwItems),

            // User Info
            Text(
              displayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
            const SizedBox(height: 4),
            if (email.isNotEmpty)
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: dark ? Colors.grey[400] : Colors.grey[600],
                    ),
              ),
            if (email.isNotEmpty) const SizedBox(height: 4),
            Text(
              roleName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: dark ? Colors.grey[500] : Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: Tsizes.spaceBtwItems),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, bool dark, AuthController? authController) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Tcolors.darkerGrey : Colors.white,
        borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedSettings01,
            title: 'App Settings',
            subtitle: 'Configure app preferences',
            onTap: () => Get.to(() => const AppSettingsScreen()),
          ),
          _buildDivider(dark),
          _buildMenuItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedTextColor,
            title: 'Theme Settings',
            subtitle: 'Change app appearance',
            onTap: () => Get.to(() => const ThemeSettingsScreen()),
          ),
          _buildDivider(dark),
          _buildMenuItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedNotification01,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () => Get.to(() => const NotificationSettingsScreen()),
          ),
          _buildDivider(dark),
          _buildMenuItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedShield01,
            title: 'Privacy & Security',
            subtitle: 'Manage your privacy settings',
            onTap: () => Get.to(() => const PrivacySecurityScreen()),
          ),
          _buildDivider(dark),
          _buildMenuItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedQuestion,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () => Get.to(() => const HelpSupportScreen()),
          ),
          _buildDivider(dark),
          _buildMenuItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedLogout01,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () => _showLogoutDialog(context, authController),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required bool dark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
      child: Padding(
        padding: const EdgeInsets.all(Tsizes.defaultSpace),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.1)
                    : Tcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : Tcolors.primary,
                size: 20,
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
                          color: isDestructive
                              ? Colors.red
                              : (dark ? Colors.white : Tcolors.dark),
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: dark ? Colors.grey[400] : Colors.grey[600],
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
      ),
    );
  }

  Widget _buildDivider(bool dark) {
    return Divider(
      height: 1,
      color: dark ? Colors.grey[700] : Colors.grey[300],
      indent: Tsizes.defaultSpace + 40 + Tsizes.spaceBtwItems,
    );
  }

  Widget _buildAppInfoSection(BuildContext context, bool dark) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        // Show loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            decoration: BoxDecoration(
              color: dark ? Tcolors.darkerGrey : Colors.white,
              borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: dark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Tcolors.dark,
                      ),
                ),
                const SizedBox(height: Tsizes.spaceBtwItems),
                const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        }

        // Handle error state with better error message
        if (snapshot.hasError) {
          print('Error loading package info: ${snapshot.error}');
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            decoration: BoxDecoration(
              color: dark ? Tcolors.darkerGrey : Colors.white,
              borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: dark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Tcolors.dark,
                      ),
                ),
                const SizedBox(height: Tsizes.spaceBtwItems),
                _buildInfoRow(context, dark, 'Version', '1.0.0'),
                _buildInfoRow(context, dark, 'Build Number', '1'),
                _buildInfoRow(context, dark, 'Current Date', _getCurrentDate()),
                const SizedBox(height: 8),
                Text(
                  'Note: Package info unavailable. Showing default values.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          );
        }

        // Check if data is null
        if (snapshot.data == null) {
          print('Package info data is null');
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Tsizes.defaultSpace),
            decoration: BoxDecoration(
              color: dark ? Tcolors.darkerGrey : Colors.white,
              borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: dark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Tcolors.dark,
                      ),
                ),
                const SizedBox(height: Tsizes.spaceBtwItems),
                _buildInfoRow(context, dark, 'Version', '1.0.0'),
                _buildInfoRow(context, dark, 'Build Number', '1'),
                _buildInfoRow(context, dark, 'Current Date', _getCurrentDate()),
              ],
            ),
          );
        }

        final packageInfo = snapshot.data!;
        
        // Debug print to see what we're getting
        print('Package Info loaded:');
        print('  App Name: ${packageInfo.appName}');
        print('  Version: ${packageInfo.version}');
        print('  Build Number: ${packageInfo.buildNumber}');
        print('  Package Name: ${packageInfo.packageName}');

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Tsizes.defaultSpace),
          decoration: BoxDecoration(
            color: dark ? Tcolors.darkerGrey : Colors.white,
            borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
            boxShadow: [
              BoxShadow(
                color: dark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Tcolors.dark,
                    ),
              ),
              const SizedBox(height: Tsizes.spaceBtwItems),
              _buildInfoRow(context, dark, 'App Name', packageInfo.appName.isNotEmpty ? packageInfo.appName : 'PMIS'),
              _buildInfoRow(context, dark, 'Version', packageInfo.version.isNotEmpty ? packageInfo.version : '1.0.0'),
              _buildInfoRow(context, dark, 'Build Number', packageInfo.buildNumber.isNotEmpty ? packageInfo.buildNumber : '1'),
              _buildInfoRow(context, dark, 'Package Name', packageInfo.packageName.isNotEmpty ? packageInfo.packageName : 'ug.co.future.pmis'),
              _buildInfoRow(context, dark, 'Current Date', _getCurrentDate()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
      BuildContext context, bool dark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? Colors.grey[400] : Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: dark ? Colors.white : Tcolors.dark,
                ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${now.day} ${months[now.month - 1]}, ${now.year}';
  }

  void _showLogoutDialog(BuildContext context, AuthController? authController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedLogout01,
                color: Colors.red,
                size: 28,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Are you sure you want to logout?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Get.back();
                      if (authController != null) {
                        authController.logout();
                      } else {
                        // Fallback logout
                        Get.offAll(() => const LoginSliderScreen());
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
