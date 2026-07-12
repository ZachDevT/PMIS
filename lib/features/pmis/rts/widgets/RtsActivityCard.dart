import 'package:flutter/material.dart';
import 'package:pmis/features/pmis/rts/models/RtsModel.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:iconsax/iconsax.dart';

class RtsActivityCard extends StatelessWidget {
  final RtsModel activity;
  final VoidCallback? onTap;

  const RtsActivityCard({
    super.key,
    required this.activity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Card(
      margin: const EdgeInsets.only(bottom: Tsizes.spaceBtwItems),
      color: dark ? Tcolors.darkGrey : Colors.white,
      child: InkWell(
        onTap: onTap ?? () => _showDetailView(context),
        borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(Tsizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Tcolors.primary.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(Tsizes.borderRadiusSm),
                    ),
                    child: Icon(
                      Iconsax.radio,
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
                          activity.topicOfDiscussion,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: dark ? Tcolors.white : Tcolors.dark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${activity.region} • ${activity.district}",
                          style: TextStyle(
                            fontSize: 14,
                            color: dark ? Tcolors.grey : Tcolors.darkGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!activity.isSynced)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Tcolors.warning.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(Tsizes.borderRadiusSm),
                      ),
                      child: const Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: 12,
                          color: Tcolors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Tsizes.spaceBtwItems),

              // Details Row
              Row(
                children: [
                  _buildDetailItem(
                    icon: Iconsax.user,
                    label: "Inspector",
                    value: activity.inspectorName,
                    dark: dark,
                  ),
                  const SizedBox(width: Tsizes.spaceBtwItems),
                  _buildDetailItem(
                    icon: Iconsax.location,
                    label: "Region",
                    value: activity.region,
                    dark: dark,
                  ),
                ],
              ),
              const SizedBox(height: Tsizes.spaceBtwItems / 2),

              Row(
                children: [
                  _buildDetailItem(
                    icon: Iconsax.map,
                    label: "District",
                    value: activity.district,
                    dark: dark,
                  ),
                  const SizedBox(width: Tsizes.spaceBtwItems),
                  _buildDetailItem(
                    icon: Iconsax.people,
                    label: "Participants",
                    value: activity.numberOfParticipants.toString(),
                    dark: dark,
                  ),
                ],
              ),
              const SizedBox(height: Tsizes.spaceBtwItems / 2),

              // Date and Time
              Row(
                children: [
                  Icon(
                    Iconsax.calendar,
                    size: 16,
                    color: dark ? Tcolors.grey : Tcolors.darkGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(activity.inspectionDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: dark ? Tcolors.grey : Tcolors.darkGrey,
                    ),
                  ),
                  const Spacer(),
                  if (activity.radioCompanyName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Tcolors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(Tsizes.borderRadiusSm),
                      ),
                      child: Text(
                        activity.radioCompanyName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Tcolors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool dark,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: dark ? Tcolors.grey : Tcolors.darkGrey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: dark ? Tcolors.grey : Tcolors.darkGrey,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: dark ? Tcolors.white : Tcolors.dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  void _showDetailView(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1C1E)
              : const Color(0xFFF2F2F7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            // Header with gradient
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Tcolors.primary.withOpacity(0.1),
                    Tcolors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Tcolors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Tcolors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Iconsax.radio,
                      color: Tcolors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Radio Talk Show Details',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete radio talk show information',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildModernDetailSection(
                      context,
                      'Inspection Information',
                      Iconsax.calendar_1,
                      [
                        _buildModernDetailRow(
                            context,
                            'Inspection Date',
                            _formatDate(activity.inspectionDate),
                            Iconsax.calendar),
                        _buildModernDetailRow(context, 'Inspector Name',
                            activity.inspectorName, Iconsax.user),
                        _buildModernDetailRow(
                            context,
                            'GPS Location',
                            '${activity.latitude}, ${activity.longitude}',
                            Iconsax.location),
                        _buildModernDetailRow(
                            context, 'Region', activity.region, Iconsax.map),
                        _buildModernDetailRow(context, 'District',
                            activity.district, Iconsax.building),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildModernDetailSection(
                      context,
                      'Radio Talk Show Information',
                      Iconsax.radio,
                      [
                        _buildModernDetailRow(context, 'Topic of Discussion',
                            activity.topicOfDiscussion, Iconsax.message),
                        _buildModernDetailRow(context, 'Venue Location',
                            activity.venueLocation, Iconsax.location),
                        if (activity.radioCompanyName != null)
                          _buildModernDetailRow(context, 'Radio Company',
                              activity.radioCompanyName!, Iconsax.building),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildModernDetailSection(
                      context,
                      'Additional Information',
                      Iconsax.info_circle,
                      [
                        _buildModernDetailRow(
                            context,
                            'Sync Status',
                            activity.isSynced ? 'Synced' : 'Pending',
                            Iconsax.cloud),
                        if (activity.createdAt != null)
                          _buildModernDetailRow(
                              context,
                              'Created At',
                              _formatDateTime(activity.createdAt!),
                              Iconsax.calendar),
                        if (activity.updatedAt != null)
                          _buildModernDetailRow(
                              context,
                              'Updated At',
                              _formatDateTime(activity.updatedAt!),
                              Iconsax.calendar),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDetailSection(BuildContext context, String title,
      IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Tcolors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Tcolors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernDetailRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Tcolors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Tcolors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
