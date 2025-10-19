import 'package:flutter/material.dart';
import 'package:pmis/features/pmis/enforcement/models/EnforcementModel.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:iconsax/iconsax.dart';

class EnforcementActivityCard extends StatelessWidget {
  final EnforcementModel activity;
  final VoidCallback? onTap;

  const EnforcementActivityCard({
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
        onTap: onTap,
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
                      Iconsax.shield_security,
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
                          activity.facilityName,
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
                      child: Text(
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
                    label: "Person",
                    value: activity.personName,
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
                    icon: Iconsax.info_circle,
                    label: "Status",
                    value: activity.facilityStatus,
                    dark: dark,
                  ),
                ],
              ),
              const SizedBox(height: Tsizes.spaceBtwItems / 2),

              // Date and Action
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
                  if (activity.enforcementActionTaken.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Tcolors.error.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(Tsizes.borderRadiusSm),
                      ),
                      child: Text(
                        activity.enforcementActionTaken,
                        style: TextStyle(
                          fontSize: 12,
                          color: Tcolors.error,
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
}
