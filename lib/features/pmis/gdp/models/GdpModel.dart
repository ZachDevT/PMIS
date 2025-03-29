class GdpActivity {
  final String id;
  final DateTime inspectionDate;
  final DateTime inspectionTime;
  final String inspectorName;
  final String gpsLocation;
  final String region;
  final String district;
  final String facilityName;
  final String facilityStatus;
  final String name;
  final String contactQualifications;
  final String qualifications;
  final String categoryOfFacility;
  final String facilityType;
  final String categoryOfDrugs;
  final String certificationStatus;
  final String recommendedForGpp;

  GdpActivity({
    required this.id,
    required this.inspectionDate,
    required this.inspectionTime,
    required this.inspectorName,
    required this.gpsLocation,
    required this.region,
    required this.district,
    required this.facilityName,
    required this.facilityStatus,
    required this.name,
    required this.contactQualifications,
    required this.qualifications,
    required this.categoryOfFacility,
    required this.facilityType,
    required this.categoryOfDrugs,
    required this.certificationStatus,
    required this.recommendedForGpp,
  });

  factory GdpActivity.fromJson(Map<String, dynamic> json) {
    return GdpActivity(
      id: json['id'],
      inspectionDate: DateTime.parse(json['inspectionDate']),
      inspectionTime: DateTime.parse(json['inspectionTime']),
      inspectorName: json['inspectorName'],
      gpsLocation: json['gpsLocation'],
      region: json['region'],
      district: json['district'],
      facilityName: json['facilityName'],
      facilityStatus: json['facilityStatus'],
      name: json['name'],
      contactQualifications: json['contactQualifications'],
      qualifications: json['qualifications'],
      categoryOfFacility: json['categoryOfFacility'],
      facilityType: json['facilityType'],
      categoryOfDrugs: json['categoryOfDrugs'],
      certificationStatus: json['certificationStatus'],
      recommendedForGpp: json['recommendedForGpp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionDate': inspectionDate.toIso8601String(),
      'inspectionTime': inspectionTime.toIso8601String(),
      'inspectorName': inspectorName,
      'gpsLocation': gpsLocation,
      'region': region,
      'district': district,
      'facilityName': facilityName,
      'facilityStatus': facilityStatus,
      'name': name,
      'contactQualifications': contactQualifications,
      'qualifications': qualifications,
      'categoryOfFacility': categoryOfFacility,
      'facilityType': facilityType,
      'categoryOfDrugs': categoryOfDrugs,
      'certificationStatus': certificationStatus,
      'recommendedForGpp': recommendedForGpp,
    };
  }
}
