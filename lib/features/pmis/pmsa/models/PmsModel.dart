class PmsModel {
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
  final int pmsActivity;
  final String sampleProductName;
  final int sampleNo;
  final String sampleBatch;
  final String followupComment;
  final String complaintProduct;
  final String otherActivity;

  PmsModel({
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
    required this.pmsActivity,
    required this.sampleProductName,
    required this.sampleNo,
    required this.sampleBatch,
    required this.followupComment,
    required this.complaintProduct,
    required this.otherActivity,
  });

  factory PmsModel.fromJson(Map<String, dynamic> json) {
    return PmsModel(
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
      pmsActivity: json['pmsActivity'] ?? 0,
      sampleProductName: json['sample_ProductName'] ?? '',
      sampleNo: json['sample_No'] ?? 0,
      sampleBatch: json['sample_Batch'] ?? '',
      followupComment: json['followup_Comment'] ?? '',
      complaintProduct: json['complaint_Product'] ?? '',
      otherActivity: json['other_Activity'] ?? '',
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
      'pmsActivity': pmsActivity,
      'sample_ProductName': sampleProductName,
      'sample_No': sampleNo,
      'sample_Batch': sampleBatch,
      'followup_Comment': followupComment,
      'complaint_Product': complaintProduct,
      'other_Activity': otherActivity,
    };
  }

  PmsModel copyWith({
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
    int? pmsActivity,
    String? sampleProductName,
    int? sampleNo,
    String? sampleBatch,
    String? followupComment,
    String? complaintProduct,
    String? otherActivity,
  }) {
    return PmsModel(
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
      pmsActivity: pmsActivity ?? this.pmsActivity,
      sampleProductName: sampleProductName ?? this.sampleProductName,
      sampleNo: sampleNo ?? this.sampleNo,
      sampleBatch: sampleBatch ?? this.sampleBatch,
      followupComment: followupComment ?? this.followupComment,
      complaintProduct: complaintProduct ?? this.complaintProduct,
      otherActivity: otherActivity ?? this.otherActivity,
    );
  }
}