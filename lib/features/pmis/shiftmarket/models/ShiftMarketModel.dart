/// Shift Market Model for PMIS
/// Represents shift market inspection activities and data structure
library;

class ShiftMarketModel {
  final String? id;
  final String inspectionDate;
  final String inspectorName;
  final String facilityStatus;
  final double latitude;
  final double longitude;
  final String region;
  final String district;
  final String facilityName;
  final String personFoundAtFacility; // Replaces facilityStatus, personName, contact, qualifications
  final String categoryOfPremises;
  final String licenseStatus;
  final String? licenseNo;
  final String? licenseExpiryDate;
  final String regulatoryActionTaken;
  final String consignmentsImpounded;
  final String previouslyLicensed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;

  ShiftMarketModel({
    this.id,
    required this.inspectionDate,
    required this.inspectorName,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.district,
    required this.facilityName,
    required this.personFoundAtFacility,
    this.facilityStatus = 'OPEN',
    required this.categoryOfPremises,
    this.licenseStatus = 'Licensed',
    this.licenseNo,
    this.licenseExpiryDate,
    required this.regulatoryActionTaken,
    required this.consignmentsImpounded,
    required this.previouslyLicensed,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });

  // Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionDate': inspectionDate,
      'inspectorName': inspectorName,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
      'district': district,
      'facilityName': facilityName,
      'personFoundAtFacility': personFoundAtFacility,
      'facilityStatus': facilityStatus,
      'categoryOfPremises': categoryOfPremises,
      'licenseStatus': licenseStatus,
      'licenseNo': licenseNo,
      'licenseExpiryDate': licenseExpiryDate,
      'previouslyLicensed': previouslyLicensed,
      'regulatoryActionTaken': regulatoryActionTaken,
      'consignmentsImpounded': consignmentsImpounded,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  // Create from JSON
  factory ShiftMarketModel.fromJson(Map<String, dynamic> json) {
    return ShiftMarketModel(
      id: json['id']?.toString(),
      inspectionDate: json['inspectionDate'] ?? '',
      inspectorName: json['inspectorName'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      region: _getRegionName(json['intRegion']),
      district: _getDistrictName(json['districtId']),
      facilityName: json['facilityName'] ?? '',
      personFoundAtFacility: json['personFoundAtFacility'] ?? '',
      facilityStatus: json['facilityStatus'] != null
          ? _getFacilityStatusName(json['facilityStatus'])
          : 'OPEN',
      categoryOfPremises: _getCategoryName(json['categoryOfpremises']),
      licenseStatus: json['licenseStatus']?.toString() ??
          json['LicenseStatus']?.toString() ??
          '1',
      licenseNo: json['licenseNo'] ?? json['LicenseNo'] ?? '',
      licenseExpiryDate:
          json['licenseExpiryDate'] ?? json['LicenseExpiryDate'] ?? json['licenseExpDate'] ?? json['LicenseExpDate'] ?? '',
      previouslyLicensed: json['previouslyLicensed'] ?? json['PreviouslyLicensed'] ?? '',
      regulatoryActionTaken: json['regulatoryAction'] ?? '',
      consignmentsImpounded: json['consignmentsImpounded'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isSynced: json['isSynced'] ?? false,
    );
  }

  /// Convert region GUID to region name
  static String _getRegionName(String? regionGuid) {
    if (regionGuid == null) return '';
    switch (regionGuid) {
      case 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78':
        return 'HEAD OFFICE';
      case '87ddeda4-cef9-4e7b-ad44-34bb56081916':
        return 'CENTRAL';
      case 'e9b78052-b51b-417f-b3b6-72b8ff3c4b9a':
        return 'EASTERN';
      case '0b44f4f9-1423-4688-afd4-2369147e0f8f':
        return 'SOUTHERN';
      case 'de9b2845-56c4-4a19-8a0f-607bfd5c8689':
        return 'WESTERN';
      default:
        return 'HEAD OFFICE';
    }
  }

  /// Convert district ID to district name
  static String _getDistrictName(int? districtId) {
    if (districtId == null) return '';
    switch (districtId) {
      case 1:
        return 'KAMPALA';
      case 2:
        return 'MASAKA';
      case 3:
        return 'KABALE';
      case 4:
        return 'FORTPORTAL';
      default:
        return 'KAMPALA';
    }
  }

  /// Convert facility status code to name
  static String _getFacilityStatusName(dynamic status) {
    if (status == null) return 'OPEN';
    if (status is int) {
      switch (status) {
        case 1:
          return 'OPEN';
        case 0:
          return 'CLOSED';
        default:
          return 'OPEN';
      }
    }
    if (status is String) {
      final s = status.toUpperCase();
      if (s == 'CLOSED' || s == '0') return 'CLOSED';
      return 'OPEN';
    }
    return 'OPEN';
  }

  /// Convert category code to name
  static String _getCategoryName(int? category) {
    if (category == null) return '';
    switch (category) {
      case 1:
        return 'WHOLESALE PHARMACY';
      case 2:
        return 'RETAIL PHARMACY';
      case 3:
        return 'DRUG SHOP';
      case 4:
        return 'EXTERNAL STORES';
      case 5:
        return 'HOSPITAL';
      case 6:
        return 'HCIV';
      case 7:
        return 'HCIII';
      case 8:
        return 'CLINIC';
      case 9:
        return 'HERBAL SELLING OUTLET';
      case 10:
        return 'SHIFT MARKET';
      case 11:
        return 'PHARMACEUTICAL/MEDICAL DEVICE MANUFACTURING PREMISE';
      case 12:
        return 'RTS(RADIO TALK SHOW)';
      case 13:
        return 'ENFORCEMENT';
      case 14:
        return 'OTHER';
      default:
        return 'SHIFT MARKET';
    }
  }

  // Create a copy with updated fields
  ShiftMarketModel copyWith({
    String? id,
    String? inspectionDate,
    String? inspectorName,
    double? latitude,
    double? longitude,
    String? region,
    String? district,
    String? facilityName,
    String? personFoundAtFacility,
    String? facilityStatus,
    String? categoryOfPremises,
    String? licenseStatus,
    String? licenseNo,
    String? licenseExpiryDate,
    String? previouslyLicensed,
    String? regulatoryActionTaken,
    String? consignmentsImpounded,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return ShiftMarketModel(
      id: id ?? this.id,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      inspectorName: inspectorName ?? this.inspectorName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
      district: district ?? this.district,
      facilityName: facilityName ?? this.facilityName,
        personFoundAtFacility:
          personFoundAtFacility ?? this.personFoundAtFacility,
        facilityStatus: facilityStatus ?? this.facilityStatus,
      categoryOfPremises: categoryOfPremises ?? this.categoryOfPremises,
      licenseStatus: licenseStatus ?? this.licenseStatus,
      licenseNo: licenseNo ?? this.licenseNo,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      previouslyLicensed: previouslyLicensed ?? this.previouslyLicensed,
      regulatoryActionTaken:
          regulatoryActionTaken ?? this.regulatoryActionTaken,
      consignmentsImpounded:
          consignmentsImpounded ?? this.consignmentsImpounded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
