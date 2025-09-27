import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/gpp/models/GppModel.dart';
import 'package:pmis/utils/constants/colors.dart';

class GppActivityCard extends StatelessWidget {
  final GppActivity activity;

  GppActivityCard({super.key, required this.activity});

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _showDetailView(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: dark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(activity.certStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Iconsax.building_3,
                    color: _getStatusColor(activity.certStatus),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.facilityName,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: dark ? Colors.white : Colors.black87,
                                ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_getRegionName(activity.intRegion)} • District ${activity.districtId}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Iconsax.arrow_right_3,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Status Row
            Row(
              children: [
                _buildModernChip(
                  Iconsax.shield_tick,
                  _getLicenseStatusText(activity.licenseStatus),
                  _getLicenseStatusColor(activity.licenseStatus),
                ),
                const SizedBox(width: 8),
                _buildModernChip(
                  Iconsax.info_circle,
                  _getStatusText(activity.facilityStatus),
                  _getFacilityStatusColor(activity.facilityStatus),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Tcolors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Tap to view details',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Tcolors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                      Iconsax.document_text,
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
                          'GPP Inspection Details',
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
                          'Complete inspection information',
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
                      'Inspection Information',
                      Iconsax.calendar_1,
                      [
                        _buildModernDetailRow(
                            'Inspection Date',
                            _formatDate(activity.inspectionDate),
                            Iconsax.calendar),
                        _buildModernDetailRow('Inspector Name',
                            activity.inspectorName, Iconsax.user),
                        _buildModernDetailRow('GPS Location',
                            activity.gps ?? 'Not provided', Iconsax.location),
                        _buildModernDetailRow('Region',
                            _getRegionName(activity.intRegion), Iconsax.map),
                        _buildModernDetailRow('District ID',
                            activity.districtId.toString(), Iconsax.building),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildModernDetailSection(
                      'Facility Information',
                      Iconsax.building_3,
                      [
                        _buildModernDetailRow('Facility Name',
                            activity.facilityName, Iconsax.home),
                        _buildModernDetailRow(
                            'Facility Status',
                            _getStatusText(activity.facilityStatus),
                            Iconsax.info_circle),
                        _buildModernDetailRow(
                            'Facility Type',
                            _getFacilityTypeText(activity.facilityType),
                            Iconsax.category),
                        _buildModernDetailRow(
                            'Category of Premises',
                            _getCategoryText(activity.categoryOfpremises),
                            Iconsax.building),
                        _buildModernDetailRow(
                            'License Status',
                            _getLicenseStatusText(activity.licenseStatus),
                            Iconsax.shield_tick),
                        _buildModernDetailRow(
                            'License Number',
                            activity.licenseNo ?? 'Not provided',
                            Iconsax.document),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildModernDetailSection(
                      'Personnel Information',
                      Iconsax.profile_2user,
                      [
                        _buildModernDetailRow(
                            'Person Name', activity.personName, Iconsax.user),
                        _buildModernDetailRow(
                            'Contact', activity.contact, Iconsax.call),
                        _buildModernDetailRow('Qualifications',
                            activity.qualifications, Iconsax.book),
                        _buildModernDetailRow(
                            'Person Type',
                            _getPersonTypeText(activity.facilityPersonType),
                            Iconsax.user_tag),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildModernDetailSection(
                      'Certification & Recommendations',
                      Iconsax.verify,
                      [
                        _buildModernDetailRow(
                            'Certification Status',
                            _getCertStatusText(activity.certStatus),
                            Iconsax.shield_tick),
                        _buildModernDetailRow(
                            'Category Status',
                            _getCategoryStatusText(activity.categoryStatus),
                            Iconsax.category_2),
                        _buildModernDetailRow(
                            'Recommended for GPP',
                            _getRecommendedText(activity.recommendedforGPP),
                            Iconsax.like),
                        _buildModernDetailRow(
                            'Inspector ID',
                            activity.inspectorId ?? 'Not assigned',
                            Iconsax.user_square),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildModernDetailSection(
                      'Location Coordinates',
                      Iconsax.location,
                      [
                        _buildModernDetailRow('Latitude',
                            activity.latitude.toString(), Iconsax.location_add),
                        _buildModernDetailRow(
                            'Longitude',
                            activity.longitude.toString(),
                            Iconsax.location_add),
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

  Widget _buildModernDetailSection(
      String title, IconData icon, List<Widget> children) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2C2C2E)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Tcolors.primary.withOpacity(0.1),
                    Tcolors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Tcolors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: Tcolors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                  ),
                ],
              ),
            ),
            // Section Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDetailRow(String label, String value, IconData icon) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1C1E).withOpacity(0.5)
              : const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
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
                          letterSpacing: 0.5,
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
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Open';
      case 0:
        return 'Closed';
      default:
        return 'Unknown';
    }
  }

  String _getFacilityTypeText(int type) {
    switch (type) {
      case 1:
        return 'Public Facility';
      case 2:
        return 'Private Facility';
      default:
        return 'Unknown';
    }
  }

  String _getCategoryText(int category) {
    switch (category) {
      case 1:
        return 'Retail Pharmacy';
      case 2:
        return 'Drug Shop';
      case 3:
        return 'Hospital';
      case 4:
        return 'HCIV';
      case 5:
        return 'HCIII';
      case 6:
        return 'Clinic';
      default:
        return 'Unknown';
    }
  }

  String _getLicenseStatusText(int status) {
    switch (status) {
      case 1:
        return 'Licensed';
      case 2:
        return 'Un-Licensed';
      case 3:
        return 'Not-Applicable';
      default:
        return 'Unknown';
    }
  }

  String _getPersonTypeText(int type) {
    switch (type) {
      case 1:
        return 'In-charge';
      case 2:
        return 'Attendant/Operator';
      default:
        return 'Unknown';
    }
  }

  String _getCertStatusText(int status) {
    switch (status) {
      case 1:
        return 'Certified';
      case 2:
        return 'Not certified';
      default:
        return 'Unknown';
    }
  }

  String _getCategoryStatusText(int status) {
    switch (status) {
      case 1:
        return 'Medical Device';
      case 2:
        return 'Veterinary drugs';
      case 3:
        return 'Human drugs';
      case 4:
        return 'Public Healthcare products';
      case 5:
        return 'Herbal drugs';
      default:
        return 'Unknown';
    }
  }

  String _getRecommendedText(int recommended) {
    switch (recommended) {
      case 1:
        return 'GPP certification';
      case 0:
        return 'Not recommended for GPP certification';
      default:
        return 'Unknown';
    }
  }

  Widget _buildModernChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLicenseStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green; // Licensed
      case 2:
        return Colors.orange; // Un-Licensed
      case 3:
        return Colors.grey; // Not-Applicable
      default:
        return Colors.grey;
    }
  }

  Color _getFacilityStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green; // Open
      case 0:
        return Colors.red; // Closed
      default:
        return Colors.grey;
    }
  }

  String _getRegionName(String guid) {
    // Map GUIDs back to region names for display
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
                Text(title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
