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
  });

  factory GdpModel.fromJson(Map<String, dynamic> json) {
    return GdpModel(
      id: json['id'] ?? 0,
      inspectionDate: DateTime.parse(json['inspectionDate'] ?? DateTime.now().toIso8601String()),
      inspectorName: json['inspectorName'] ?? '',
      gps: json['gps'] ?? '',
      intRegion: json['intRegion'] ?? '',
      districtId: json['districtId'] ?? 0,
      facilityName: json['facilityName'] ?? '',
      facilityStatus: json['facilityStatus'] ?? 0,
      facilityPersonType: json['facilityPersonType'] ?? 0,
      personName: json['personName'] ?? '',
      contact: json['contact'] ?? '',
      qualifications: json['qualifications'] ?? '',
      categoryOfpremises: json['categoryOfpremises'] ?? 0,
      licenseStatus: json['licenseStatus'] ?? 0,
      categoryStatus: json['categoryStatus'] ?? 0,
      facilityType: json['facilityType'] ?? 0,
      certStatus: json['certStatus'] ?? 0,
      recommendedforGDP: json['recommendedforGDP'] ?? 0,
      inspectorId: json['inspectorId'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      licenseNo: json['licenseNo'] ?? '',
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
    };
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
    );
  }
}