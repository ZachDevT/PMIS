import 'package:pmis/features/pmis/qualification/controllers/QualificationController.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

class GdpModel {
  final int id;
  final DateTime inspectionDate;
  final String inspectorName;
  final String gps;
  final String intRegion;
  final int districtId;
  final String facilityName;
  final int facilityStatus;
  final int facilityPersonType;
  final String personName;
  final String contact;
  final String qualifications;
  final int? qualificationId;
  final int categoryOfpremises;
  final int licenseStatus;
  final int categoryStatus;
  final int facilityType;
  final int certStatus;
  final int recommendedforGDP;
  final String inspectorId;
  final double latitude;
  final double longitude;
  final String licenseNo;
  final String licenseExpiryDate;
  final String previouslyLicensed;

  GdpModel({
    required this.id,
    required this.inspectionDate,
    required this.inspectorName,
    required this.gps,
    required this.intRegion,
    required this.districtId,
    required this.facilityName,
    required this.facilityStatus,
    required this.facilityPersonType,
    required this.personName,
    required this.contact,
    required this.qualifications,
    this.qualificationId,
    required this.categoryOfpremises,
    required this.licenseStatus,
    required this.categoryStatus,
    required this.facilityType,
    required this.certStatus,
    required this.recommendedforGDP,
    required this.inspectorId,
    required this.latitude,
    required this.longitude,
    required this.licenseNo,
    required this.licenseExpiryDate,
    required this.previouslyLicensed,
  });

  factory GdpModel.fromJson(Map<String, dynamic> json) {
    // Debug: Print what we're receiving
    print('=== GDP Model fromJson Debug ===');
    print('JSON keys: ${json.keys.toList()}');
    print('Raw inspectorName: ${json['inspectorName']}');
    print('Raw InspectorName: ${json['InspectorName']}');
    print('Raw inspectorId: ${json['inspectorId']}');
    print('Raw InspectorId: ${json['InspectorId']}');

    final inspectorName = json['inspectorName'] ?? json['InspectorName'] ?? '';
    final inspectorId = json['inspectorId'] ?? json['InspectorId'] ?? '';

    print('Final inspectorName: $inspectorName');
    print('Final inspectorId: $inspectorId');
    print('=== End GDP Model Debug ===');

    return GdpModel(
      id: json['id'] ?? 0,
      inspectionDate: DateTime.parse(json['inspectionDate'] ??
          json['InspectionDate'] ??
          DateTime.now().toIso8601String()),
      inspectorName: inspectorName,
      gps: (json['gps'] != null && json['gps'].toString().isNotEmpty)
          ? json['gps'].toString()
          : (json['Gps'] != null && json['Gps'].toString().isNotEmpty)
              ? json['Gps'].toString()
              : ((json['latitude'] != null || json['Latitude'] != null)
                  ? 'Lat: ${json['latitude'] ?? json['Latitude']}, Lon: ${json['longitude'] ?? json['Longitude']}'
                  : ''),
      intRegion: RegionDistrictConstants.getRegionGuidForDistrictId(
          json['districtId'] ?? json['DistrictId'],
          fallbackGuid: json['intRegion'] ?? json['IntRegion'] ?? ''),
      districtId: json['districtId'] ?? json['DistrictId'] ?? 0,
      facilityName: json['facilityName'] ?? json['FacilityName'] ?? '',
      facilityStatus: json['facilityStatus'] ?? 0,
      facilityPersonType: json['facilityPersonType'] ?? 0,
      personName: json['personName'] ?? '',
      contact: json['contact'] ?? '',
      qualifications: QualificationController.instance.displayName(
          json['qualifications'] ?? json['Qualifications'],
          json['qualificationId'] ?? json['QualificationId']),
      qualificationId: json['qualificationId'] is int
          ? json['qualificationId']
          : int.tryParse(
              (json['qualificationId'] ?? json['QualificationId'] ?? '')
                  .toString()),
      categoryOfpremises: json['categoryOfpremises'] ?? 0,
      licenseStatus: json['licenseStatus'] ?? 0,
      categoryStatus: json['categoryStatus'] ?? 0,
      facilityType: json['facilityType'] ?? 0,
      certStatus: json['certStatus'] ?? 0,
      recommendedforGDP: json['recommendedforGDP'] ?? 0,
      inspectorId: json['inspectorId'] ?? json['InspectorId'] ?? '',
      latitude: (json['latitude'] ?? json['Latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? json['Longitude'] ?? 0).toDouble(),
      licenseNo: json['licenseNo'] ?? json['LicenseNo'] ?? '',
      licenseExpiryDate: json['licenseExpiryDate'] ??
          json['LicenseExpiryDate'] ??
          json['licenseExpDate'] ??
          json['LicenseExpDate'] ??
          '',
      previouslyLicensed:
          json['previouslyLicensed'] ?? json['PreviouslyLicensed'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionDate': inspectionDate.toIso8601String(),
      'inspectorName': inspectorName,
      'gps': gps,
      'intRegion': intRegion,
      'districtId': districtId,
      'facilityName': facilityName,
      'facilityStatus': facilityStatus,
      'facilityPersonType': facilityPersonType,
      'personName': personName,
      'contact': contact,
      'qualifications': qualifications,
      'qualificationId': qualificationId,
      'categoryOfpremises': categoryOfpremises,
      'licenseStatus': licenseStatus,
      'categoryStatus': categoryStatus,
      'facilityType': facilityType,
      'certStatus': certStatus,
      'recommendedforGDP': recommendedforGDP,
      'inspectorId': inspectorId,
      'latitude': latitude,
      'longitude': longitude,
      'licenseNo': licenseNo,
      'licenseExpiryDate': licenseExpiryDate,
      'previouslyLicensed': previouslyLicensed,
    };
  }

  // Helper methods to convert numeric values to text
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

  String _getCategoryOfPremisesText(int category) {
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

  String _getRecommendedForGdpText(int recommendation) {
    switch (recommendation) {
      case 1:
        return 'Not Recommended for GDP';
      case 0:
        return 'Recommended for GDP';
      default:
        return 'Unknown';
    }
  }

  GdpModel copyWith({
    int? id,
    DateTime? inspectionDate,
    String? inspectorName,
    String? gps,
    String? intRegion,
    int? districtId,
    String? facilityName,
    int? facilityStatus,
    int? facilityPersonType,
    String? personName,
    String? contact,
    String? qualifications,
    int? categoryOfpremises,
    int? licenseStatus,
    int? categoryStatus,
    int? facilityType,
    int? certStatus,
    int? recommendedforGDP,
    String? inspectorId,
    double? latitude,
    double? longitude,
    String? licenseNo,
    String? licenseExpiryDate,
    String? previouslyLicensed,
  }) {
    return GdpModel(
      id: id ?? this.id,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      inspectorName: inspectorName ?? this.inspectorName,
      gps: gps ?? this.gps,
      intRegion: intRegion ?? this.intRegion,
      districtId: districtId ?? this.districtId,
      facilityName: facilityName ?? this.facilityName,
      facilityStatus: facilityStatus ?? this.facilityStatus,
      facilityPersonType: facilityPersonType ?? this.facilityPersonType,
      personName: personName ?? this.personName,
      contact: contact ?? this.contact,
      qualifications: qualifications ?? this.qualifications,
      qualificationId: qualificationId,
      categoryOfpremises: categoryOfpremises ?? this.categoryOfpremises,
      licenseStatus: licenseStatus ?? this.licenseStatus,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      facilityType: facilityType ?? this.facilityType,
      certStatus: certStatus ?? this.certStatus,
      recommendedforGDP: recommendedforGDP ?? this.recommendedforGDP,
      inspectorId: inspectorId ?? this.inspectorId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      licenseNo: licenseNo ?? this.licenseNo,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      previouslyLicensed: previouslyLicensed ?? this.previouslyLicensed,
    );
  }
}
