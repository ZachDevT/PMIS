import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/gdp/models/GdpModel.dart';
import 'package:pmis/utils/constants/colors.dart';

class GdpActivityCard extends StatelessWidget {
  final GdpActivity activity;

  GdpActivityCard({super.key, required this.activity});

  final RxBool isExpanded = false.obs;

  // Determine a color based on the certification status.
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'licensed':
        return Colors.green;
      case 'unlicensed':
        return Colors.red;
      case 'not-applicable':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: dark ? Tcolors.dark : Tcolors.grey.withOpacity(0.7),
            width: 1,
          ),
          color: dark ? Tcolors.dark : Tcolors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: status indicator, facility name and expand/collapse icon.
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(activity.certificationStatus),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    activity.facilityName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                GestureDetector(
                  onTap: () => isExpanded.value = !isExpanded.value,
                  child: Icon(
                    isExpanded.value
                        ? Iconsax.arrow_up_2
                        : Iconsax.arrow_down_1,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Info chips displaying region, facility status, and drug category.
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                _InfoChip(Iconsax.location, "${activity.region}, ${activity.district}"),
                _InfoChip(Iconsax.status, activity.facilityStatus),
                _InfoChip(Iconsax.document, activity.categoryOfDrugs),
              ],
            ),
            // Expanded details when the card is tapped.
            if (isExpanded.value) ...[
              const Divider(height: 20, thickness: 1),
              _DetailItem(Iconsax.building_3, "Facility Type", activity.facilityType),
              _DetailItem(Iconsax.profile_2user, "Contact", activity.name),
              _DetailItem(Iconsax.note, "Recommendation", activity.recommendedForGpp),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 14, color: Theme.of(context).primaryColor),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: Colors.grey.shade200,
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailItem(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
