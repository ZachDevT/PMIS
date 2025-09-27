import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/pmsa/models/PmsModel.dart';
import 'package:pmis/utils/constants/colors.dart';

class PmsaActivityCard extends StatelessWidget {
  final PmsActivity activity;

  PmsaActivityCard({super.key, required this.activity});

  final RxBool isExpanded = false.obs;

  // Determine a color based on the licensed status.
  Color _getStatusColor(int status) {
    switch (status) {
      case 1: // Licensed
        return Colors.green;
      case 2: // Un-Licensed
        return Colors.red;
      case 3: // Not-Applicable
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _getRegionName(String guid) {
    switch (guid) {
      case "deaf2c98-3dbb-489f-bdea-9e5fd49eec78":
        return "Central Region";
      case "57a2afce-98b8-48b2-984e-cc04e3d84264":
        return "Eastern Region";
      case "12345678-1234-1234-1234-123456789012":
        return "Northern Region";
      case "87654321-4321-4321-4321-210987654321":
        return "Western Region";
      default:
        return "Central Region";
    }
  }

  String _getFacilityStatusText(int status) {
    switch (status) {
      case 1: return 'Open';
      case 0: return 'Closed';
      default: return 'Unknown';
    }
  }

  String _getLicenseStatusText(int status) {
    switch (status) {
      case 1: return 'Licensed';
      case 2: return 'Un-Licensed';
      case 3: return 'Not-Applicable';
      default: return 'Unknown';
    }
  }

  String _getCategoryStatusText(int status) {
    switch (status) {
      case 1: return 'Medical Device';
      case 2: return 'Veterinary drugs';
      case 3: return 'Human drugs';
      case 4: return 'Public Healthcare products';
      case 5: return 'Herbal drugs';
      default: return 'Unknown';
    }
  }

  String _getCategoryOfPremisesText(int category) {
    switch (category) {
      case 1: return 'Retail Pharmacy';
      case 2: return 'Drug Shop';
      case 3: return 'Hospital';
      case 4: return 'HCIV';
      case 5: return 'HCIII';
      case 6: return 'Clinic';
      default: return 'Unknown';
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
            // Header row: status indicator, facility name, and expand/collapse icon.
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(activity.licenseStatus),
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
            // Info chips displaying region/district, facility status, and PMSA activity.
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                _InfoChip(Iconsax.location, "${_getRegionName(activity.intRegion)}, District ${activity.districtId}"),
                _InfoChip(Iconsax.status, _getFacilityStatusText(activity.facilityStatus)),
                _InfoChip(Iconsax.building, _getLicenseStatusText(activity.licenseStatus)),
              ],
            ),
            // Expanded details when the card is tapped.
            if (isExpanded.value) ...[
              const Divider(height: 20, thickness: 1),
              _DetailItem(Iconsax.category, "Facility Category", _getCategoryOfPremisesText(activity.categoryOfpremises)),
              _DetailItem(Iconsax.profile_2user, "Person Name", activity.personName ?? 'Not provided'),
              _DetailItem(Iconsax.call, "Contact", activity.contact ?? 'Not provided'),
              _DetailItem(Iconsax.book, "Qualifications", activity.qualifications ?? 'Not provided'),
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
