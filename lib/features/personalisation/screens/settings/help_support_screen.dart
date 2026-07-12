import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          'Help & Support',
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
            // Quick Help
            _buildQuickHelpSection(context, dark),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Contact Support
            _buildContactSection(context, dark),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // Resources
            _buildResourcesSection(context, dark),
            const SizedBox(height: Tsizes.spaceBtwSections),

            // FAQ
            _buildFAQSection(context, dark),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpSection(BuildContext context, bool dark) {
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
              'Quick Help',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildHelpItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedQuestion,
            title: 'How to create a new inspection?',
            onTap: () => _showHelpDialog(context, 'Creating Inspections',
                'To create a new inspection:\n\n1. Navigate to the desired module (GPP, GDP, CSS, or PMS)\n2. Tap the "+" button to add a new activity\n3. Fill in the required information\n4. Tap "Submit" to save the inspection'),
          ),
          _buildDivider(dark),
          _buildHelpItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedLocation01,
            title: 'How to use GPS location?',
            onTap: () => _showHelpDialog(context, 'GPS Location',
                'The app automatically captures your current location when creating inspections:\n\n1. Ensure location permissions are enabled\n2. The app will request location access when needed\n3. GPS coordinates are automatically filled in the form\n4. You can view locations on the map in activity details'),
          ),
          _buildDivider(dark),
          _buildHelpItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedCloud,
            title: 'How to sync data offline?',
            onTap: () => _showHelpDialog(context, 'Offline Sync',
                'To sync offline data:\n\n1. Ensure you have an internet connection\n2. Open the app and go to any module\n3. Pull down to refresh the data\n4. Offline data will automatically sync when online\n5. Check the sync status in the app settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool dark) {
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
              'Contact Support',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildContactItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedMail01,
            title: 'Email Support',
            subtitle: 'support@pmis.com',
            onTap: () => _showContactDialog(context, 'Email Support',
                'Send us an email at support@pmis.com\n\nWe typically respond within 24 hours during business days.'),
          ),
          _buildDivider(dark),
          _buildContactItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedDeviceAccess,
            title: 'Phone Support',
            subtitle: '+256 700 000 000',
            onTap: () => _showContactDialog(context, 'Phone Support',
                'Call us at +256 700 000 000\n\nAvailable Monday to Friday, 8 AM to 5 PM (EAT)'),
          ),
          _buildDivider(dark),
          _buildContactItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedMessage01,
            title: 'Live Chat',
            subtitle: 'Available 24/7',
            onTap: () => _showContactDialog(context, 'Live Chat',
                'Start a live chat session with our support team.\n\nAvailable 24/7 for urgent issues.'),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection(BuildContext context, bool dark) {
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
              'Resources',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildResourceItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedDocumentAttachment,
            title: 'User Manual',
            subtitle: 'Complete guide to using the app',
            onTap: () => _showResourceDialog(context, 'User Manual',
                'Download the complete user manual for detailed instructions on using all features of the PMIS app.'),
          ),
          _buildDivider(dark),
          _buildResourceItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedVideo01,
            title: 'Video Tutorials',
            subtitle: 'Step-by-step video guides',
            onTap: () => _showResourceDialog(context, 'Video Tutorials',
                'Watch our video tutorials to learn how to use the app effectively.'),
          ),
          _buildDivider(dark),
          _buildResourceItem(
            context: context,
            dark: dark,
            icon: HugeIcons.strokeRoundedDownload01,
            title: 'App Updates',
            subtitle: 'Download latest version',
            onTap: () => _showResourceDialog(context, 'App Updates',
                'Check for and download the latest version of the PMIS app with new features and improvements.'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, bool dark) {
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
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Tcolors.dark,
                  ),
            ),
          ),
          _buildFAQItem(
            context: context,
            dark: dark,
            question: 'How do I reset my password?',
            answer:
                'To reset your password, go to Settings > Privacy & Security > Change Password. Follow the instructions to create a new password.',
          ),
          _buildDivider(dark),
          _buildFAQItem(
            context: context,
            dark: dark,
            question: 'Can I use the app offline?',
            answer:
                'Yes, the app supports offline mode. You can create inspections offline, and they will sync automatically when you have an internet connection.',
          ),
          _buildDivider(dark),
          _buildFAQItem(
            context: context,
            dark: dark,
            question: 'How do I backup my data?',
            answer:
                'Your data is automatically backed up to the cloud. You can also export your data from Settings > Privacy & Security > Export Data.',
          ),
          _buildDivider(dark),
          _buildFAQItem(
            context: context,
            dark: dark,
            question: 'What should I do if the app crashes?',
            answer:
                'If the app crashes, try restarting it. If the problem persists, go to Settings > Privacy & Security and enable crash reporting to help us fix the issue.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required BuildContext context,
    required bool dark,
    required IconData icon,
    required String title,
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
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white : Tcolors.dark,
                    ),
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

  Widget _buildContactItem({
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

  Widget _buildResourceItem({
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

  Widget _buildFAQItem({
    required BuildContext context,
    required bool dark,
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: dark ? Colors.white : Tcolors.dark,
            ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Tsizes.defaultSpace,
            vertical: Tsizes.spaceBtwItems,
          ),
          child: Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? Colors.grey[300] : Colors.grey[700],
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool dark) {
    return Divider(
      height: 1,
      color: dark ? Colors.grey[700] : Colors.grey[300],
      indent: Tsizes.defaultSpace + 40 + Tsizes.spaceBtwItems,
    );
  }

  void _showHelpDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResourceDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
