import 'package:flutter/material.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/pmsa/models/PmsModel.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/commons/widgets/map/MapViewWidget.dart';
import 'package:permission_handler/permission_handler.dart';

class PmsaActivityCard extends StatelessWidget {
  final PmsModel activity;

  const PmsaActivityCard({super.key, required this.activity});

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
      case 1:
        return 'Open';
      case 0:
        return 'Closed';
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

  String _getCategoryOfPremisesText(int category) {
    switch (category) {
      case 1:
        return 'Wholesale Pharmacy - Human';
      case 2:
        return 'Wholesale Pharmacy - Vet';
      case 3:
        return 'Retail Pharmacy - Human';
      case 4:
        return 'Retail Pharmacy - Vet';
      case 5:
        return 'Drug Shop';
      case 6:
        return 'External Stores';
      case 7:
        return 'Hospital';
      case 8:
        return 'HCIV';
      case 9:
        return 'HCIII';
      case 10:
        return 'Clinic';
      case 11:
        return 'Herbal Selling Outlet';
      case 12:
        return 'Shift Market';
      case 13:
        return 'Pharmaceutical/Medical Device Manufacturing Premise';
      case 14:
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  String _getPmsActivityText(int activity) {
    switch (activity) {
      case 1:
        return 'Sampling';
      case 2:
        return 'Follow-up on Recall';
      case 3:
        return 'Complaint investigation';
      case 4:
        return 'Others';
      case 5:
        return 'None';
      default:
        return 'None';
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
                    color: _getStatusColor(activity.licenseStatus)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Iconsax.activity,
                    color: _getStatusColor(activity.licenseStatus),
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
                        '${RegionDistrictConstants.getRegionName(activity.intRegion)} • ${RegionDistrictConstants.getDistrictName(activity.districtId)}',
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
                  _getFacilityStatusText(activity.facilityStatus),
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
                      Iconsax.activity,
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
                          'PMSA Inspection Details',
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
                    // Debug: Print activity data
                    Builder(
                      builder: (context) {
                        print('=== PMSA Activity Card Debug ===');
                        print(
                            'Activity inspectorName: ${activity.inspectorName}');
                        print('Activity inspectorId: ${activity.inspectorId}');
                        print('Activity keys: ${activity.toString()}');
                        print('=== End PMSA Activity Card Debug ===');
                        return const SizedBox.shrink();
                      },
                    ),
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
                        _buildModernDetailRow(
                            'Region',
                            RegionDistrictConstants.getRegionName(
                                activity.intRegion),
                            Iconsax.map),
                        _buildModernDetailRow(
                            'District',
                            RegionDistrictConstants.getDistrictName(
                                activity.districtId),
                            Iconsax.building),
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
                            _getFacilityStatusText(activity.facilityStatus),
                            Iconsax.info_circle),
                        // Only show these details if facility is not Closed
                        if (activity.facilityStatus != 0) ...[
                          _buildModernDetailRow(
                              'Category of Premises',
                              _getCategoryOfPremisesText(
                                  activity.categoryOfpremises),
                              Iconsax.building),
                          _buildModernDetailRow(
                              'License Status',
                              _getLicenseStatusText(activity.licenseStatus),
                              Iconsax.shield_tick),
                          if (activity.licenseStatus == 1) ...[
                            _buildModernDetailRow(
                                'License Number',
                                activity.licenseNo.isNotEmpty
                                    ? activity.licenseNo
                                    : 'Not provided',
                                Iconsax.document),
                            if (activity.licenseExpiryDate.isNotEmpty)
                              _buildModernDetailRow('License Expiry Date',
                                  activity.licenseExpiryDate, Iconsax.calendar),
                          ],
                          if (activity.previouslyLicensed.isNotEmpty)
                            _buildModernDetailRow(
                                'Previously Licensed / Illegal Outlet',
                                activity.previouslyLicensed,
                                Iconsax.document),
                        ],
                      ],
                    ),
                    // Only show Personnel Information if facility is not Closed
                    if (activity.facilityStatus != 0) ...[
                      const SizedBox(height: 24),
                      _buildModernDetailSection(
                        'Personnel Information',
                        Iconsax.profile_2user,
                        [
                          _buildModernDetailRow(
                              'Person Name', activity.personName, Iconsax.user),
                          _buildModernDetailRow('Contact',
                              activity.contact ?? 'Not provided', Iconsax.call),
                          _buildModernDetailRow(
                              'Qualifications',
                              activity.qualifications ?? 'Not provided',
                              Iconsax.book),
                          _buildModernDetailRow(
                              'Person Type',
                              _getPersonTypeText(activity.facilityPersonType),
                              Iconsax.user_tag),
                        ],
                      ),
                    ],
                    // Only show PMSA Specific Details if facility is not Closed
                    if (activity.facilityStatus != 0) ...[
                      const SizedBox(height: 24),
                      _buildModernDetailSection(
                        'PMSA Specific Details',
                        Iconsax.activity,
                        [
                          _buildModernDetailRow(
                              'PMS Activity',
                              _getPmsActivityText(activity.pmsActivity),
                              Iconsax.activity),
                          if (activity.pmsActivity == 1 ||
                              activity.pmsActivity == 2 ||
                              activity.pmsActivity == 3) ...[
                            _buildModernDetailRow(
                                'Sample Product Name',
                                activity.sampleProductName.isNotEmpty
                                    ? activity.sampleProductName
                                    : 'Not provided',
                                Iconsax.box),
                            _buildModernDetailRow(
                                'Sample Number',
                                activity.sampleNo.toString(),
                                Iconsax.document_text),
                            _buildModernDetailRow(
                                'Sample Batch',
                                activity.sampleBatch.isNotEmpty
                                    ? activity.sampleBatch
                                    : 'Not provided',
                                Iconsax.tag),
                          ],
                          if (activity.pmsActivity == 2)
                            _buildModernDetailRow(
                                'Follow-up Comment',
                                activity.followupComment.isNotEmpty
                                    ? activity.followupComment
                                    : 'Not provided',
                                Iconsax.message_text),
                          if (activity.pmsActivity == 3)
                            _buildModernDetailRow(
                                'Complaint Product',
                                activity.complaintProduct.isNotEmpty
                                    ? activity.complaintProduct
                                    : 'Not provided',
                                Iconsax.warning_2),
                          if (activity.pmsActivity == 4)
                            _buildModernDetailRow(
                                'Other Activity',
                                activity.otherActivity.isNotEmpty
                                    ? activity.otherActivity
                                    : 'Not provided',
                                Iconsax.more),
                        ],
                      ),
                    ],
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
                        _buildMapViewRow(),
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
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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

  Widget _buildMapViewRow() {
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
        child: GestureDetector(
          onTap: () => _openMapView(context),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Tcolors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.map,
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
                      'View on Map',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to view facility location',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Tcolors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: Tcolors.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openMapView(BuildContext context) async {
    // Check location permission before opening map
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      // Permission already granted, open map
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapViewWidget(
            latitude: activity.latitude,
            longitude: activity.longitude,
            facilityName: activity.facilityName,
            address:
                '${RegionDistrictConstants.getRegionName(activity.intRegion)}, District ${activity.districtId}',
          ),
        ),
      );
    } else {
      // Request permission first
      PermissionStatus newStatus = await Permission.location.request();

      if (newStatus.isGranted) {
        // Permission granted, open map
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapViewWidget(
              latitude: activity.latitude,
              longitude: activity.longitude,
              facilityName: activity.facilityName,
              address:
                  '${RegionDistrictConstants.getRegionName(activity.intRegion)}, District ${activity.districtId}',
            ),
          ),
        );
      } else if (newStatus.isPermanentlyDenied) {
        // Show settings dialog
        _showPermissionDialog(context);
      } else {
        // Permission denied, show message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Location permission is required to view the map'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'This app needs location permission to show your current location on the map. Please enable location permission in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}
