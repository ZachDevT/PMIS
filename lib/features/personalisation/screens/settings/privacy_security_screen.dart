import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _biometricAuth = false;
  bool _autoLock = true;
  bool _dataEncryption = true;
  bool _locationTracking = true;
  bool _analytics = false;
  bool _crashReporting = true;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

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
          'Privacy & Security',
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
            // Security Settings
            _buildSecuritySection(context, dark),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Privacy Settings
            _buildPrivacySection(context, dark),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Data Management
            _buildDataSection(context, dark),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Account Security
            _buildAccountSection(context, dark),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, bool dark) {
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
              'Security',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildSecurityItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedFingerPrint,
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or face ID to unlock',
            value: _biometricAuth,
            onChanged: (value) => setState(() => _biometricAuth = value),
          ),
          _buildDivider(dark),
          _buildSecurityItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedLock,
            title: 'Auto Lock',
            subtitle: 'Lock app after 5 minutes of inactivity',
            value: _autoLock,
            onChanged: (value) => setState(() => _autoLock = value),
          ),
          _buildDivider(dark),
          _buildSecurityItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedShield01,
            title: 'Data Encryption',
            subtitle: 'Encrypt sensitive data on device',
            value: _dataEncryption,
            onChanged: (value) => setState(() => _dataEncryption = value),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context, bool dark) {
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
              'Privacy',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildPrivacyItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedLocation01,
            title: 'Location Tracking',
            subtitle: 'Allow app to access your location',
            value: _locationTracking,
            onChanged: (value) => setState(() => _locationTracking = value),
          ),
          _buildDivider(dark),
          _buildPrivacyItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedChart01,
            title: 'Analytics',
            subtitle: 'Help improve app by sharing usage data',
            value: _analytics,
            onChanged: (value) => setState(() => _analytics = value),
          ),
          _buildDivider(dark),
          _buildPrivacyItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedBug01,
            title: 'Crash Reporting',
            subtitle: 'Automatically report crashes to developers',
            value: _crashReporting,
            onChanged: (value) => setState(() => _crashReporting = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context, bool dark) {
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
              'Data Management',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildDataItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedDownload01,
            title: 'Export Data',
            subtitle: 'Download your data in various formats',
            onTap: () => _showExportDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, bool dark) {
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
              'Account Security',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildAccountItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedKey01,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () => _showChangePasswordDialog(context),
          ),
          _buildDivider(dark),
          _buildAccountItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedDeviceAccess,
            title: 'Active Sessions',
            subtitle: 'Manage devices signed into your account',
            onTap: () => _showActiveSessionsDialog(context),
          ),
          _buildDivider(dark),
          _buildAccountItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedShield01,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security',
            onTap: () => _show2FADialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem({
    required BuildContext context,
    required bool dark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Tsizes.defaultSpace,
        vertical: Tsizes.spaceBtwItems,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Tcolors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Tcolors.primary,
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: dark ? Colors.white : Tcolors.dark,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Tcolors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem({
    required BuildContext context,
    required bool dark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Tsizes.defaultSpace,
        vertical: Tsizes.spaceBtwItems,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Tcolors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Tcolors.primary,
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: dark ? Colors.white : Tcolors.dark,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Tcolors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem({
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Tsizes.defaultSpace,
          vertical: Tsizes.spaceBtwItems,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : Tcolors.primary.withOpacity(0.1),
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
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

  Widget _buildAccountItem({
    required BuildContext context,
    required bool dark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Tsizes.defaultSpace,
          vertical: Tsizes.spaceBtwItems,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Tcolors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Tcolors.primary,
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: dark ? Colors.white : Tcolors.dark,
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

  void _showExportDialog(BuildContext context) {
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
            Text(
              'Export Data',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildExportOption(context, 'PDF Report', 'Export as PDF document'),
            _buildExportOption(
                context, 'Excel Spreadsheet', 'Export as Excel file'),
            _buildExportOption(context, 'JSON Data', 'Export raw data as JSON'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(
      BuildContext context, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.back();
          Get.snackbar('Export Started', 'Exporting data as $title');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Tcolors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Tcolors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.download,
                color: Tcolors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Tcolors.primary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                  'Account Deletion', 'Account deletion process started');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    Get.snackbar('Change Password', 'Password change feature coming soon');
  }

  void _showActiveSessionsDialog(BuildContext context) {
    Get.snackbar('Active Sessions', 'Session management feature coming soon');
  }

  void _show2FADialog(BuildContext context) {
    Get.snackbar('2FA Setup', 'Two-factor authentication setup coming soon');
  }
}
