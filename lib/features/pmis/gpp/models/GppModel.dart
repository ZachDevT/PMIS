class GppActivity {
  final String id;
  final DateTime inspectionDate;
  final DateTime inspectionTime;
  final String inspectorName;
  final String gpsLocation; // system-determined
  final String region;
  final String district;
  final String facilityName;
  final String personFound;  // In-charge/Attendant/Operator
  final String name ;
  final String contactQualifications;
  final String facilityStatus; // Open/Closed
  final String contact;
  final String categoryOfFacility; // e.g. Retail Pharmacy, Hospital, etc.
  final String licensedStatus; // Licensed/Unlicensed/Not-Applicable
  final String categoryOfDrugs; // Medical Device, Human drugs, etc.
  final String facilityType; // Public Facility / Private Facility
  final String certificationStatus; // Certified or not
  final String recommendedForGpp;

  GppActivity( {
    required this.id,
    required this.inspectionDate,
    required this.inspectionTime,
    required this.inspectorName,
    required this.gpsLocation,
    required this.region,
    required this.district,
    required this.facilityName,
    required this.personFound,
    required this.name,
    required this.contactQualifications,
    required this.facilityStatus,
    required this.contact,
    required this.categoryOfFacility,
    required this.licensedStatus,
    required this.categoryOfDrugs,
    required this.facilityType,
    required this.certificationStatus,
    required this.recommendedForGpp,
  });

  factory GppActivity.fromJson(Map<String, dynamic> json) => GppActivity(
        id: json['id'],
        inspectionDate: DateTime.parse(json['inspectionDate']),
        inspectionTime: DateTime.parse(json['inspectionTime']),
        inspectorName: json['inspectorName'],
        gpsLocation: json['gpsLocation'],
        region: json['region'],
        district: json['district'],
        facilityName: json['facilityName'],
        personFound: json['personFound'],
        contactQualifications: json['contactQualifications'],
        facilityStatus: json['facilityStatus'],
        contact: json['contact'],
        categoryOfFacility: json['categoryOfFacility'],
        licensedStatus: json['licensedStatus'],
        categoryOfDrugs: json['categoryOfDrugs'],
        facilityType: json['facilityType'],
        certificationStatus: json['certificationStatus'],
        name: json['name'],
        recommendedForGpp: json['recommendedForGpp'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'inspectionDate': inspectionDate.toIso8601String(),
        'inspectionTime': inspectionTime.toIso8601String(),
        'inspectorName': inspectorName,
        'gpsLocation': gpsLocation,
        'region': region,
        'district': district,
        'facilityName': facilityName,
        'personFound': personFound,
        'contactQualifications': contactQualifications,
        'facilityStatus': facilityStatus,
        'contact': contact,
        'categoryOfFacility': categoryOfFacility,
        'licensedStatus': licensedStatus,
        'categoryOfDrugs': categoryOfDrugs,
        'facilityType': facilityType,
        'name': name,
        'certificationStatus': certificationStatus,
        'recommendedForGpp': recommendedForGpp,
      };
}
