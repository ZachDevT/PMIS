// models/CssModel.dart
class CssActivity {
  final String id;
  final DateTime inspectionDate;
  final DateTime inspectionTime;
  final String inspectorName;
  final String gpsLocation; // System-determined
  final String region;
  final String district;
  final String facilityName;
  final String personFound; // In-charge / Attendant / Operator
  final String name;
  final String contactQualifications;
  final String facilityStatus; // Open / Closed
  final String contact;
  final String categoryOfFacility; // e.g., Retail Pharmacy, Hospital, etc.
  final String licensedStatus; // Licensed / Unlicensed / Not-Applicable
  final String categoryOfDrugs; // Medical Device, Human drugs, etc.
  final String classOfDrugs; // A/B/C
  final String unregisteredDrugs; // Present / Not Present
  final String conditionOfPremises; // Poor / Fair / Good / Excellent
  final String recordKeeping; // Poor / Fair / Good / Excellent
  final String
      actionTaken; // Closed / Outlet abandoned / Impounded / Suspect arrested / No action taken

  CssActivity({
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
    required this.classOfDrugs,
    required this.unregisteredDrugs,
    required this.conditionOfPremises,
    required this.recordKeeping,
    required this.actionTaken,
  });

  factory CssActivity.fromJson(Map<String, dynamic> json) => CssActivity(
        id: json['id'],
        inspectionDate: DateTime.parse(json['inspectionDate']),
        inspectionTime: DateTime.parse(json['inspectionTime']),
        inspectorName: json['inspectorName'],
        gpsLocation: json['gpsLocation'],
        region: json['region'],
        district: json['district'],
        facilityName: json['facilityName'],
        personFound: json['personFound'],
        name: json['name'],
        contactQualifications: json['contactQualifications'],
        facilityStatus: json['facilityStatus'],
        contact: json['contact'],
        categoryOfFacility: json['categoryOfFacility'],
        licensedStatus: json['licensedStatus'],
        categoryOfDrugs: json['categoryOfDrugs'],
        classOfDrugs: json['classOfDrugs'],
        unregisteredDrugs: json['unregisteredDrugs'],
        conditionOfPremises: json['conditionOfPremises'],
        recordKeeping: json['recordKeeping'],
        actionTaken: json['actionTaken'],
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
        'name': name,
        'contactQualifications': contactQualifications,
        'facilityStatus': facilityStatus,
        'contact': contact,
        'categoryOfFacility': categoryOfFacility,
        'licensedStatus': licensedStatus,
        'categoryOfDrugs': categoryOfDrugs,
        'classOfDrugs': classOfDrugs,
        'unregisteredDrugs': unregisteredDrugs,
        'conditionOfPremises': conditionOfPremises,
        'recordKeeping': recordKeeping,
        'actionTaken': actionTaken,
      };
}
