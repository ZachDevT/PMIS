import 'package:pmis/features/pmis/qualification/controllers/QualificationController.dart';

class GppActivity {
  final int id;
  final DateTime inspectionDate;
  final String inspectorName;
  final String? gps;
  final String intRegion; // This is actually a GUID string from the API
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
  final int recommendedforGPP;
  final String? inspectorId;
  final double latitude;
  final double longitude;
  final String? licenseNo;
  final String? licenseExpiryDate;
  final String? previouslyLicensed;

  GppActivity({
    required this.id,
    required this.inspectionDate,
    required this.inspectorName,
    this.gps,
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
    required this.recommendedforGPP,
    this.inspectorId,
    required this.latitude,
    required this.longitude,
    this.licenseNo,
    this.licenseExpiryDate,
    this.previouslyLicensed,
  });

  factory GppActivity.fromJson(Map<String, dynamic> json) => GppActivity(
        id: json['id'] ?? 0,
        inspectionDate: DateTime.parse(
            json['inspectionDate'] ?? DateTime.now().toIso8601String()),
        inspectorName: json['inspectorName'] ?? '',
        gps: (json['gps'] != null && json['gps'].toString().isNotEmpty)
            ? json['gps'].toString()
            : (json['Gps'] != null && json['Gps'].toString().isNotEmpty)
                ? json['Gps'].toString()
                : ((json['latitude'] != null || json['Latitude'] != null)
                    ? 'Lat: ${json['latitude'] ?? json['Latitude']}, Lon: ${json['longitude'] ?? json['Longitude']}'
                    : ''),
        intRegion: json['intRegion'] ?? '',
        districtId: json['districtId'] ?? 0,
        facilityName: json['facilityName'] ?? '',
        facilityStatus: json['facilityStatus'] ?? 1,
        facilityPersonType: json['facilityPersonType'] ?? 1,
        personName: json['personName'] ?? '',
        contact: json['contact'] ?? '',
        qualifications: QualificationController.instance.displayName(
            json['qualifications'] ?? json['Qualifications'],
            json['qualificationId'] ?? json['QualificationId']),
        qualificationId:
            _asInt(json['qualificationId'] ?? json['QualificationId']),
        categoryOfpremises: json['categoryOfpremises'] ?? 1,
        licenseStatus: json['licenseStatus'] ?? 1,
        categoryStatus: json['categoryStatus'] ?? 1,
        facilityType: json['facilityType'] ?? 1,
        certStatus: json['certStatus'] ?? 1,
        recommendedforGPP: json['recommendedforGPP'] ?? 1,
        inspectorId: json['inspectorId'],
        latitude: (json['latitude'] ?? 0.0).toDouble(),
        longitude: (json['longitude'] ?? 0.0).toDouble(),
        licenseNo: json['licenseNo'],
        licenseExpiryDate: json['licenseExpiryDate'] ??
            json['LicenseExpiryDate'] ??
            json['licenseExpDate'] ??
            json['LicenseExpDate'] ??
            null,
        previouslyLicensed:
            json['previouslyLicensed'] ?? json['PreviouslyLicensed'] ?? '',
      );

  static int? _asInt(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '');

  Map<String, dynamic> toJson() => {
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
        'recommendedforGPP': recommendedforGPP,
        'inspectorId': inspectorId,
        'latitude': latitude,
        'longitude': longitude,
        'licenseNo': licenseNo,
        'licenseExpiryDate': licenseExpiryDate,
        'previouslyLicensed': previouslyLicensed,
      };

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

  String _getRecommendedForGppText(int recommendation) {
    switch (recommendation) {
      case 1:
        return 'Not Recommended for GPP';
      case 2:
        return 'Recommended for GPP';
      default:
        return 'Unknown';
    }
  }
}
