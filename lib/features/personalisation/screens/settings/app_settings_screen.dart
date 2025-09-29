import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/utils/helpers/sync_manager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

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
          'App Settings',
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
            // General Settings
            _buildSettingsSection(
              context,
              dark,
              'General',
              [
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedLanguageCircle,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () => _showLanguageDialog(context),
                ),
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedCalendar01,
                  title: 'Date Format',
                  subtitle: 'DD/MM/YYYY',
                  onTap: () => _showDateFormatDialog(context),
                ),
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedTime01,
                  title: 'Time Format',
                  subtitle: '24 Hour',
                  onTap: () => _showTimeFormatDialog(context),
                ),
              ],
            ),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Data & Storage
            _buildSettingsSection(
              context,
              dark,
              'Data & Storage',
              [
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedCloud,
                  title: 'Auto Sync',
                  subtitle: 'Enabled',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: Tcolors.primary,
                  ),
                ),
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedRefresh,
                  title: 'Sync Now',
                  subtitle: _getSyncStatus(),
                  onTap: () => _syncNow(context),
                ),
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedDatabase01,
                  title: 'Cache Management',
                  subtitle: 'Clear app cache',
                  onTap: () => _showCacheDialog(context),
                ),
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedDownload01,
                  title: 'Offline Mode',
                  subtitle: 'Download data for offline use',
                  onTap: () => _showOfflineDialog(context),
                ),
              ],
            ),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Performance
            _buildSettingsSection(
              context,
              dark,
              'Performance',
              [
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedDashboardSpeed01,
                  title: 'Performance Mode',
                  subtitle: 'Balanced',
                  onTap: () => _showPerformanceDialog(context),
                ),
                _buildSettingsItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedImage01,
                  title: 'Image Quality',
                  subtitle: 'High',
                  onTap: () => _showImageQualityDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    bool dark,
    String title,
    List<Widget> children,
  ) {
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
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required bool dark,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
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
            if (trailing != null)
              trailing
            else if (onTap != null)
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

  void _showLanguageDialog(BuildContext context) {
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
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildLanguageOption(context, 'English', 'EN', true),
            _buildLanguageOption(context, 'Français', 'FR', false),
            _buildLanguageOption(context, 'Español', 'ES', false),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String name, String code, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.back();
          Get.snackbar('Language Changed', 'Language set to $name');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Tcolors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Tcolors.primary : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Text(
                code,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Tcolors.primary : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Tcolors.primary : Colors.black87,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Tcolors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateFormatDialog(BuildContext context) {
    _showBottomSheet(
      context,
      'Date Format',
      [
        _buildOption(context, 'DD/MM/YYYY', true),
        _buildOption(context, 'MM/DD/YYYY', false),
        _buildOption(context, 'YYYY-MM-DD', false),
      ],
    );
  }

  void _showTimeFormatDialog(BuildContext context) {
    _showBottomSheet(
      context,
      'Time Format',
      [
        _buildOption(context, '24 Hour', true),
        _buildOption(context, '12 Hour', false),
      ],
    );
  }

  void _showPerformanceDialog(BuildContext context) {
    _showBottomSheet(
      context,
      'Performance Mode',
      [
        _buildOption(context, 'Balanced', true),
        _buildOption(context, 'High Performance', false),
        _buildOption(context, 'Power Saver', false),
      ],
    );
  }

  void _showImageQualityDialog(BuildContext context) {
    _showBottomSheet(
      context,
      'Image Quality',
      [
        _buildOption(context, 'High', true),
        _buildOption(context, 'Medium', false),
        _buildOption(context, 'Low', false),
      ],
    );
  }

  void _showBottomSheet(
      BuildContext context, String title, List<Widget> options) {
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
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            ...options,
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String value, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.back();
          Get.snackbar('Setting Changed', '$value selected');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Tcolors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Tcolors.primary : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Tcolors.primary : Colors.black87,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Tcolors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Cache Cleared', 'App cache has been cleared');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showOfflineDialog(BuildContext context) {
    Get.snackbar('Offline Mode', 'Offline mode feature coming soon');
  }

  String _getSyncStatus() {
    try {
      final syncManager = Get.find<SyncManager>();
      return syncManager.totalPendingItems > 0 
          ? '${syncManager.totalPendingItems} items pending'
          : 'All data synced';
    } catch (e) {
      return 'Sync status unavailable';
    }
  }

  void _syncNow(BuildContext context) async {
    try {
      final syncManager = Get.find<SyncManager>();
      syncManager.initialize();
    
    if (syncManager.isSyncing) {
      Loaders.warningSnackbar(
        title: "Already Syncing",
        message: "Synchronization is already in progress...",
      );
      return;
    }

    if (syncManager.totalPendingItems == 0) {
      Loaders.successSnackbar(
        title: "Nothing to Sync",
        message: "All data is already synchronized",
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Offline Data'),
        content: Text('Sync ${syncManager.totalPendingItems} pending items?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await syncManager.performSync();
              // Update the page to reflect new counts
              Get.back(); // Close settings
              Get.to(() => const AppSettingsScreen()); // Refresh settings
            },
            child: const Text('Sync'),
          ),
        ],
      ),
    );
    } catch (e) {
      Loaders.errorSnackbar(
        title: "Sync Error",
        message: "Failed to access sync manager",
      );
    }
  }
}
