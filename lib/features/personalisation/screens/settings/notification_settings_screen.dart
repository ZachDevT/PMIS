import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _inspectionReminders = true;
  bool _deadlineAlerts = true;
  bool _systemUpdates = true;
  bool _weeklyReports = false;
  bool _monthlyReports = true;

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
          'Notification Settings',
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
            // General Notifications
            _buildNotificationSection(
              context,
              dark,
              'General Notifications',
              [
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedNotification01,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications',
                  value: _pushNotifications,
                  onChanged: (value) =>
                      setState(() => _pushNotifications = value),
                ),
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedMail01,
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: _emailNotifications,
                  onChanged: (value) =>
                      setState(() => _emailNotifications = value),
                ),
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedMessage01,
                  title: 'SMS Notifications',
                  subtitle: 'Receive notifications via SMS',
                  value: _smsNotifications,
                  onChanged: (value) =>
                      setState(() => _smsNotifications = value),
                ),
              ],
            ),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Work Notifications
            _buildNotificationSection(
              context,
              dark,
              'Work Notifications',
              [
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedCalendar01,
                  title: 'Inspection Reminders',
                  subtitle: 'Reminders for upcoming inspections',
                  value: _inspectionReminders,
                  onChanged: (value) =>
                      setState(() => _inspectionReminders = value),
                ),
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedAlert01,
                  title: 'Deadline Alerts',
                  subtitle: 'Alerts for approaching deadlines',
                  value: _deadlineAlerts,
                  onChanged: (value) => setState(() => _deadlineAlerts = value),
                ),
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedWorkUpdate,
                  title: 'System Updates',
                  subtitle: 'Notifications about system updates',
                  value: _systemUpdates,
                  onChanged: (value) => setState(() => _systemUpdates = value),
                ),
              ],
            ),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Report Notifications
            _buildNotificationSection(
              context,
              dark,
              'Report Notifications',
              [
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedChart01,
                  title: 'Weekly Reports',
                  subtitle: 'Receive weekly activity reports',
                  value: _weeklyReports,
                  onChanged: (value) => setState(() => _weeklyReports = value),
                ),
                _buildNotificationItem(
                  context: context,
                  dark: dark,
                  icon: HugeIcons.strokeRoundedDocumentAttachment,
                  title: 'Monthly Reports',
                  subtitle: 'Receive monthly summary reports',
                  value: _monthlyReports,
                  onChanged: (value) => setState(() => _monthlyReports = value),
                ),
              ],
            ),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Notification Schedule
            _buildScheduleSection(context, dark),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
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

  Widget _buildNotificationItem({
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

  Widget _buildScheduleSection(BuildContext context, bool dark) {
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
              'Notification Schedule',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildScheduleItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedTime01,
            title: 'Quiet Hours',
            subtitle: 'No notifications between 10 PM - 7 AM',
            onTap: () => _showQuietHoursDialog(context),
          ),
          _buildDivider(dark),
          _buildScheduleItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedCalendar01,
            title: 'Weekend Notifications',
            subtitle: 'Receive notifications on weekends',
            onTap: () => _showWeekendDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
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
        padding: const EdgeInsets.all(Tsizes.defaultSpace),
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

  void _showQuietHoursDialog(BuildContext context) {
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
              'Quiet Hours',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildTimeOption(context, '10:00 PM - 7:00 AM', true),
            _buildTimeOption(context, '11:00 PM - 6:00 AM', false),
            _buildTimeOption(context, 'Disabled', false),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showWeekendDialog(BuildContext context) {
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
              'Weekend Notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildWeekendOption(context, 'Enabled', true),
            _buildWeekendOption(context, 'Disabled', false),
            _buildWeekendOption(context, 'Only Important', false),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOption(BuildContext context, String time, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.back();
          Get.snackbar('Quiet Hours', 'Set to $time');
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
                time,
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

  Widget _buildWeekendOption(
      BuildContext context, String option, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.back();
          Get.snackbar('Weekend Notifications', 'Set to $option');
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
                option,
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
}
