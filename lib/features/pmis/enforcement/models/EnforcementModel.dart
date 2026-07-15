/// Enforcement Model for PMIS
/// Represents enforcement activities and data structure
library;

class EnforcementModel {
  final String? id;
  final String inspectionDate;
  final String gps;
  final String region;
  final String district;
  final String facilityName;
  final String facilityStatus;
  final String personFoundAtFacility;
  final String personName;
  final String contact;
  final String qualifications;
  final String categoryOfPremises;
  final String licenseStatus;
  final String? licenseNo;
  final String? licenseExpiryDate;
  final String categoryStatus;
  final String categoryOfDrugs;
  final String previouslyLicensed;
  final String enforcementActionTaken;
  final String comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? inspectorName;
  final String? inspectorId;
  final bool isSynced;

  EnforcementModel({
    this.id,
    required this.inspectionDate,
    required this.gps,
    required this.region,
    required this.district,
    required this.facilityName,
    required this.facilityStatus,
    required this.personFoundAtFacility,
    required this.personName,
    required this.contact,
    required this.qualifications,
    required this.categoryOfPremises,
    required this.licenseStatus,
    this.licenseNo,
    this.licenseExpiryDate,
    required this.categoryStatus,
    required this.categoryOfDrugs,
    required this.previouslyLicensed,
    required this.enforcementActionTaken,
    required this.comments,
    this.createdAt,
    this.updatedAt,
    this.inspectorName,
    this.inspectorId,
    this.isSynced = false,
  });

  // Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionDate': inspectionDate,
      'gps': gps,
      'region': region,
      'district': district,
      'facilityName': facilityName,
      'facilityStatus': facilityStatus,
      'personFoundAtFacility': personFoundAtFacility,
      'personName': personName,
      'contact': contact,
      'qualifications': qualifications,
      'categoryOfPremises': categoryOfPremises,
      'licenseStatus': licenseStatus,
      'licenseNo': licenseNo,
      'licenseExpiryDate': licenseExpiryDate,
      'categoryStatus': categoryStatus,
      'categoryOfDrugs': categoryOfDrugs,
      'previouslyLicensed': previouslyLicensed,
      'enforcementActionTaken': enforcementActionTaken,
      'comments': comments,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'inspectorName': inspectorName,
      'inspectorId': inspectorId,
      'isSynced': isSynced,
    };
  }

  // Create from JSON
  factory EnforcementModel.fromJson(Map<String, dynamic> json) {
    return EnforcementModel(
      id: json['id']?.toString(),
      inspectionDate: json['inspectionDate'] ?? '',
      gps: (json['gps'] != null && json['gps'].toString().isNotEmpty)
          ? json['gps'].toString()
          : (json['Gps'] != null && json['Gps'].toString().isNotEmpty)
              ? json['Gps'].toString()
              : ((json['latitude'] != null || json['Latitude'] != null)
                  ? 'Lat: ${json['latitude'] ?? json['Latitude']}, Lon: ${json['longitude'] ?? json['Longitude']}'
                  : ''),
      region: _getRegionName(json['intRegion']),
      district: _getDistrictName(json['districtId']),
      facilityName: json['facilityName'] ?? '',
      facilityStatus: _getFacilityStatusName(json['facilityStatus']),
      personFoundAtFacility: _getPersonFoundStatus(json['facilityPersonType']),
      personName: json['personName'] ?? '',
      contact: json['contact'] ?? '',
      qualifications: json['qualifications'] ?? '',
      categoryOfPremises: _getCategoryName(json['categoryOfpremises']),
      licenseStatus: _getLicenseStatusName(json['licenseStatus']),
      licenseNo: json['licenseNo'] ?? json['LicenseNo'] ?? '',
      licenseExpiryDate:
          json['licenseExpiryDate'] ?? json['LicenseExpiryDate'] ?? '',
      categoryStatus: _getCategoryStatusName(json['categoryStatus'] ?? json['CategoryStatus']),
      categoryOfDrugs: json['categoryOfDrugs'] ?? json['CategoryOfDrugs'] ?? '',
      previouslyLicensed: json['previouslyLicensed'] ?? json['PreviouslyLicensed'] ?? '',
      enforcementActionTaken: _getEnforcementActionName(json['enfAction'] ?? json['EnfAction'] ?? json['enforcementActionTaken']),
      comments: json['comments'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      inspectorName: json['inspectorName'] ?? json['InspectorName'],
      inspectorId: json['inspectorId'] ?? json['InspectorId'],
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
  static String _getFacilityStatusName(int? status) {
    if (status == null) return '';
    switch (status) {
      case 1:
        return 'OPEN';
      case 0:
        return 'CLOSED';
      default:
        return 'OPEN';
    }
  }

  /// Convert person found status
  static String _getPersonFoundStatus(int? status) {
    if (status == null) return '';
    switch (status) {
      case 1:
        return 'YES';
      case 0:
        return 'NO';
      default:
        return 'YES';
    }
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
        return 'ENFORCEMENT';
    }
  }

  /// Convert license status code to name
  static String _getLicenseStatusName(int? status) {
    if (status == null) return '';
    switch (status) {
      case 1:
        return 'LICENSED';
      case 0:
        return 'UNLICENSED';
      default:
        return 'LICENSED';
    }
  }

  /// Convert category status code to name
  static String _getCategoryStatusName(int? status) {
    if (status == null) return '';
    switch (status) {
      case 1:
        return 'COMPLIANT';
      case 0:
        return 'NON-COMPLIANT';
      default:
        return 'COMPLIANT';
    }
  }

  /// Convert enforcement action code to name
  static String _getEnforcementActionName(dynamic action) {
    if (action == null) return '';
    final int? parsedAction = action is int ? action : int.tryParse(action.toString());
    if (parsedAction == null) return 'NONE';
    switch (parsedAction) {
      case 1:
        return 'WARNING';
      case 2:
        return 'FINE';
      case 3:
        return 'CLOSURE';
      case 0:
      default:
        return 'NONE';
    }
  }

  // Create a copy with updated fields
  EnforcementModel copyWith({
    String? id,
    String? inspectionDate,
    String? gps,
    String? region,
    String? district,
    String? facilityName,
    String? facilityStatus,
    String? personFoundAtFacility,
    String? personName,
    String? contact,
    String? qualifications,
    String? categoryOfPremises,
    String? licenseStatus,
    String? licenseNo,
    String? licenseExpiryDate,
    String? categoryStatus,
    String? categoryOfDrugs,
    String? previouslyLicensed,
    String? enforcementActionTaken,
    String? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? inspectorName,
    String? inspectorId,
    bool? isSynced,
  }) {
    return EnforcementModel(
      id: id ?? this.id,
      inspectorName: inspectorName ?? this.inspectorName,
      inspectorId: inspectorId ?? this.inspectorId,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      gps: gps ?? this.gps,
      region: region ?? this.region,
      district: district ?? this.district,
      facilityName: facilityName ?? this.facilityName,
      facilityStatus: facilityStatus ?? this.facilityStatus,
      personFoundAtFacility:
          personFoundAtFacility ?? this.personFoundAtFacility,
      personName: personName ?? this.personName,
      contact: contact ?? this.contact,
      qualifications: qualifications ?? this.qualifications,
      categoryOfPremises: categoryOfPremises ?? this.categoryOfPremises,
      licenseStatus: licenseStatus ?? this.licenseStatus,
      licenseNo: licenseNo ?? this.licenseNo,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      categoryOfDrugs: categoryOfDrugs ?? this.categoryOfDrugs,
      previouslyLicensed: previouslyLicensed ?? this.previouslyLicensed,
      enforcementActionTaken:
          enforcementActionTaken ?? this.enforcementActionTaken,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
