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
  });

  factory GppActivity.fromJson(Map<String, dynamic> json) => GppActivity(
        id: json['id'],
        inspectionDate: DateTime.parse(json['inspectionDate']),
        inspectorName: json['inspectorName'],
        gps: json['gps'],
        intRegion: json['intRegion'],
        districtId: json['districtId'],
        facilityName: json['facilityName'],
        facilityStatus: json['facilityStatus'],
        facilityPersonType: json['facilityPersonType'],
        personName: json['personName'],
        contact: json['contact'],
        qualifications: json['qualifications'],
        categoryOfpremises: json['categoryOfpremises'],
        licenseStatus: json['licenseStatus'],
        categoryStatus: json['categoryStatus'],
        facilityType: json['facilityType'],
        certStatus: json['certStatus'],
        recommendedforGPP: json['recommendedforGPP'],
        inspectorId: json['inspectorId'],
        latitude: (json['latitude'] ?? 0.0).toDouble(),
        longitude: (json['longitude'] ?? 0.0).toDouble(),
        licenseNo: json['licenseNo'],
      );

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
      };
}
