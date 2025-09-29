class CssModel {
  final int id;
  final DateTime inspectionDate;
  final String inspectorName;
  final String inspectorId;
  final double latitude;
  final double longitude;
  final String intRegion;
  final int districtId;
  final String facilityName;
  final int facilityStatus;
  final int facilityPersonType;
  final String personName;
  final String contact;
  final String qualifications;
  final int categoryOfpremises;
  final String otherCategoryPremise;
  final int licenseStatus;
  final String licenseNo;
  final int unlicensed;
  final int categoryStatus;
  final int premisesCondition;
  final int recordKeeping;
  final int classofDrugs;
  final int unRegisteredDrug;
  final String unRegDrugQty;
  final int action;

  CssModel({
    required this.id,
    required this.inspectionDate,
    required this.inspectorName,
    required this.inspectorId,
    required this.latitude,
    required this.longitude,
    required this.intRegion,
    required this.districtId,
    required this.facilityName,
    required this.facilityStatus,
    required this.facilityPersonType,
    required this.personName,
    required this.contact,
    required this.qualifications,
    required this.categoryOfpremises,
    required this.otherCategoryPremise,
    required this.licenseStatus,
    required this.licenseNo,
    required this.unlicensed,
    required this.categoryStatus,
    required this.premisesCondition,
    required this.recordKeeping,
    required this.classofDrugs,
    required this.unRegisteredDrug,
    required this.unRegDrugQty,
    required this.action,
  });

  factory CssModel.fromJson(Map<String, dynamic> json) {
    return CssModel(
      id: json['id'] ?? 0,
      inspectionDate: DateTime.parse(json['inspectionDate'] ?? DateTime.now().toIso8601String()),
      inspectorName: json['inspectorName'] ?? '',
      inspectorId: json['inspectorId'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      intRegion: json['intRegion'] ?? '',
      districtId: json['districtId'] ?? 0,
      facilityName: json['facilityName'] ?? '',
      facilityStatus: json['facilityStatus'] ?? 0,
      facilityPersonType: json['facilityPersonType'] ?? 0,
      personName: json['personName'] ?? '',
      contact: json['contact'] ?? '',
      qualifications: json['qualifications'] ?? '',
      categoryOfpremises: json['categoryOfpremises'] ?? 0,
      otherCategoryPremise: json['other_CategoryPremise'] ?? '',
      licenseStatus: json['licenseStatus'] ?? 0,
      licenseNo: json['licenseNo'] ?? '',
      unlicensed: json['unlicensed'] ?? 0,
      categoryStatus: json['categoryStatus'] ?? 0,
      premisesCondition: json['premisesCondition'] ?? 0,
      recordKeeping: json['recordKeeping'] ?? 0,
      classofDrugs: json['classofDrugs'] ?? 0,
      unRegisteredDrug: json['unRegisteredDrug'] ?? 0,
      unRegDrugQty: json['unRegDrugQty'] ?? '',
      action: json['action'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'other_CategoryPremise': otherCategoryPremise,
      'licenseStatus': licenseStatus,
      'licenseNo': licenseNo,
      'unlicensed': unlicensed,
      'categoryStatus': categoryStatus,
      'premisesCondition': premisesCondition,
      'recordKeeping': recordKeeping,
      'classofDrugs': classofDrugs,
      'unRegisteredDrug': unRegisteredDrug,
      'unRegDrugQty': unRegDrugQty,
      'action': action,
    };
  }

  CssModel copyWith({
    int? id,
    DateTime? inspectionDate,
    String? inspectorName,
    String? inspectorId,
    double? latitude,
    double? longitude,
    String? intRegion,
    int? districtId,
    String? facilityName,
    int? facilityStatus,
    int? facilityPersonType,
    String? personName,
    String? contact,
    String? qualifications,
    int? categoryOfpremises,
    String? otherCategoryPremise,
    int? licenseStatus,
    String? licenseNo,
    int? unlicensed,
    int? categoryStatus,
    int? premisesCondition,
    int? recordKeeping,
    int? classofDrugs,
    int? unRegisteredDrug,
    String? unRegDrugQty,
    int? action,
  }) {
    return CssModel(
      id: id ?? this.id,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      inspectorName: inspectorName ?? this.inspectorName,
      inspectorId: inspectorId ?? this.inspectorId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      intRegion: intRegion ?? this.intRegion,
      districtId: districtId ?? this.districtId,
      facilityName: facilityName ?? this.facilityName,
      facilityStatus: facilityStatus ?? this.facilityStatus,
      facilityPersonType: facilityPersonType ?? this.facilityPersonType,
      personName: personName ?? this.personName,
      contact: contact ?? this.contact,
      qualifications: qualifications ?? this.qualifications,
      categoryOfpremises: categoryOfpremises ?? this.categoryOfpremises,
      otherCategoryPremise: otherCategoryPremise ?? this.otherCategoryPremise,
      licenseStatus: licenseStatus ?? this.licenseStatus,
      licenseNo: licenseNo ?? this.licenseNo,
      unlicensed: unlicensed ?? this.unlicensed,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      premisesCondition: premisesCondition ?? this.premisesCondition,
      recordKeeping: recordKeeping ?? this.recordKeeping,
      classofDrugs: classofDrugs ?? this.classofDrugs,
      unRegisteredDrug: unRegisteredDrug ?? this.unRegisteredDrug,
      unRegDrugQty: unRegDrugQty ?? this.unRegDrugQty,
      action: action ?? this.action,
    );
  }
}