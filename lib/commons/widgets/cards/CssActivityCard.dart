// CssActivityCard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/css/models/CssModel.dart'; // Replace with your actual CSS model path
import 'package:pmis/utils/constants/colors.dart';

class CssActivityCard extends StatelessWidget {
  final CssActivity activity;

  CssActivityCard({super.key, required this.activity});

  final RxBool isExpanded = false.obs;

  Color _getStatusColor(int status) {
    switch (status) {
      case 1: // Open/Licensed
        return Colors.green;
      case 0: // Closed
        return Colors.red;
      case 2: // Unlicensed
        return Colors.orange;
      default:
        return Colors.grey;
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

  String _getPremisesConditionText(int condition) {
    switch (condition) {
      case 1: return 'Good';
      case 2: return 'Fair';
      case 3: return 'Poor';
      default: return 'Unknown';
    }
  }

  String _getRecordKeepingText(int? keeping) {
    if (keeping == null) return 'Not specified';
    switch (keeping) {
      case 1: return 'Good';
      case 2: return 'Fair';
      case 3: return 'Poor';
      default: return 'Unknown';
    }
  }

  String _getActionText(int? action) {
    if (action == null) return 'Not specified';
    switch (action) {
      case 1: return 'Warning';
      case 2: return 'Fine';
      case 3: return 'Closure';
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
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(activity.facilityStatus),
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
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                _InfoChip(Iconsax.location,
                    "${_getRegionName(activity.intRegion)}, District ${activity.districtId}"),
                _InfoChip(Iconsax.status, _getFacilityStatusText(activity.facilityStatus)),
                _InfoChip(Iconsax.document, _getLicenseStatusText(activity.licenseStatus)),
                _InfoChip(HugeIcons.strokeRoundedMedicine02, _getCategoryStatusText(activity.categoryStatus)),
              ],
            ),
            if (isExpanded.value) ...[
              const Divider(height: 20, thickness: 1),
              _DetailItem(Iconsax.building_3, "Facility Type",
                  _getCategoryOfPremisesText(activity.categoryOfpremises)),
              _DetailItem(Iconsax.profile_2user, "Contact", activity.contact ?? 'Not provided'),
              _DetailItem(Iconsax.note, "Condition of Premises",
                  _getPremisesConditionText(activity.premisesCondition)),
              _DetailItem(
                  Iconsax.note, "Record Keeping", _getRecordKeepingText(activity.recordKeeping)),
              _DetailItem(Iconsax.note, "Action Taken", _getActionText(activity.action)),
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
                    style:
                        const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
