class PmsActivity {
  final int id;
  final DateTime inspectionDate;
  final String? inspectorName;
  final String? inspectorId;
  final double latitude;
  final double longitude;
  final String intRegion; // GUID string
  final int districtId;
  final String facilityName;
  final int facilityStatus;
  final int facilityPersonType;
  final String? personName;
  final String? contact;
  final String? qualifications;
  final int categoryOfpremises;
  final int licenseStatus;
  final String? licenseNo;
  final int categoryStatus;

  PmsActivity({
    required this.id,
    required this.inspectionDate,
    this.inspectorName,
    this.inspectorId,
    required this.latitude,
    required this.longitude,
    required this.intRegion,
    required this.districtId,
    required this.facilityName,
    required this.facilityStatus,
    required this.facilityPersonType,
    this.personName,
    this.contact,
    this.qualifications,
    required this.categoryOfpremises,
    required this.licenseStatus,
    this.licenseNo,
    required this.categoryStatus,
  });

  factory PmsActivity.fromJson(Map<String, dynamic> json) => PmsActivity(
        id: json['id'],
        inspectionDate: DateTime.parse(json['inspectionDate']),
        inspectorName: json['inspectorName'],
        inspectorId: json['inspectorId'],
        latitude: (json['latitude'] ?? 0.0).toDouble(),
        longitude: (json['longitude'] ?? 0.0).toDouble(),
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
        licenseNo: json['licenseNo'],
        categoryStatus: json['categoryStatus'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'inspectionDate': inspectionDate.toIso8601String(),
        'inspectorName': inspectorName,
        'inspectorId': inspectorId,
        'latitude': latitude,
        'longitude': longitude,
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
        'licenseNo': licenseNo,
        'categoryStatus': categoryStatus,
      };
}
