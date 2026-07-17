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
  final String licenseExpiryDate;
  final int unlicensed;
  final int pmsActivity;
  final String sampleProductName;
  final int sampleNo;
  final String sampleBatch;
  final String followupComment;
  final String complaintProduct;
  final String otherActivity;
  final String previouslyLicensed;

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
    required this.licenseExpiryDate,
    required this.unlicensed,
    required this.pmsActivity,
    required this.sampleProductName,
    required this.sampleNo,
    required this.sampleBatch,
    required this.followupComment,
    required this.complaintProduct,
    required this.otherActivity,
    this.previouslyLicensed = '',
  });

  factory PmsModel.fromJson(Map<String, dynamic> json) {
    // Debug: Print what we're receiving
    print('=== PMS Model fromJson Debug ===');
    print('JSON keys: ${json.keys.toList()}');
    print('Raw inspectorName: ${json['inspectorName']}');
    print('Raw InspectorName: ${json['InspectorName']}');
    print('Raw inspectorId: ${json['inspectorId']}');
    print('Raw InspectorId: ${json['InspectorId']}');
    
    final inspectorName = json['inspectorName'] ?? json['InspectorName'] ?? '';
    final inspectorId = json['inspectorId'] ?? json['InspectorId'] ?? '';
    
    print('Final inspectorName: $inspectorName');
    print('Final inspectorId: $inspectorId');
    print('=== End PMS Model Debug ===');
    
    return PmsModel(
      id: json['id'] ?? 0,
      inspectionDate: DateTime.parse(json['inspectionDate'] ?? json['InspectionDate'] ?? DateTime.now().toIso8601String()),
      inspectorName: inspectorName,
      inspectorId: inspectorId,
      latitude: (json['latitude'] ?? json['Latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? json['Longitude'] ?? 0).toDouble(),
      intRegion: json['intRegion'] ?? json['IntRegion'] ?? '',
      districtId: json['districtId'] ?? json['DistrictId'] ?? 0,
      facilityName: json['facilityName'] ?? json['FacilityName'] ?? '',
      facilityStatus: json['facilityStatus'] ?? 0,
      facilityPersonType: json['facilityPersonType'] ?? 0,
      personName: json['personName'] ?? '',
      contact: json['contact'] ?? '',
      qualifications: json['qualifications'] ?? '',
      categoryOfpremises: json['categoryOfpremises'] ?? 0,
      otherCategoryPremise: json['other_CategoryPremise'] ?? '',
      licenseStatus: json['licenseStatus'] ?? 0,
      licenseNo: json['licenseNo'] ?? '',
      licenseExpiryDate: json['licenseExpiryDate'] ?? json['LicenseExpiryDate'] ?? json['licenseExpDate'] ?? json['LicenseExpDate'] ?? '',
      unlicensed: json['unlicensed'] ?? 0,
      pmsActivity: json['pmsActivity'] ?? 0,
      sampleProductName: json['sample_ProductName'] ?? '',
      sampleNo: json['sample_No'] ?? 0,
      sampleBatch: json['sample_Batch'] ?? '',
      followupComment: json['followup_Comment'] ?? '',
      complaintProduct: json['complaint_Product'] ?? '',
      otherActivity: json['other_Activity'] ?? '',
      previouslyLicensed: json['previouslyLicensed'] ?? json['PreviouslyLicensed'] ?? '',
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
      'licenseExpiryDate': licenseExpiryDate,
      'unlicensed': unlicensed,
      'pmsActivity': pmsActivity,
      'sample_ProductName': sampleProductName,
      'sample_No': sampleNo,
      'sample_Batch': sampleBatch,
      'followup_Comment': followupComment,
      'complaint_Product': complaintProduct,
      'other_Activity': otherActivity,
      'previouslyLicensed': previouslyLicensed,
    };
  }

  // Helper methods to convert numeric values to text
  String _getFacilityStatusText(int status) {
    switch (status) {
      case 1: return 'Open';
      case 0: return 'Closed';
      default: return 'Unknown';
    }
  }

  String _getPersonTypeText(int type) {
    switch (type) {
      case 1: return 'In-charge';
      case 2: return 'Attendant/Operator';
      default: return 'Unknown';
    }
  }

  String _getCategoryOfPremisesText(int category) {
    switch (category) {
      case 1: return 'Retail Pharmacy';
      case 2: return 'Drug Shop';
      case 3: return 'Hospital';
      case 4: return 'HCIV';
      case 5: return 'HCIII';
      case 6: return 'Clinic';
      default: return 'Unknown';
    }
  }

  String _getLicenseStatusText(int status) {
    switch (status) {
      case 1: return 'Licensed';
      case 2: return 'Un-Licensed';
      case 3: return 'Not-Applicable';
      default: return 'Unknown';
    }
  }

  String _getPmsActivityText(int activity) {
    switch (activity) {
      case 1: return 'Sampling';
      case 2: return 'Follow-up on Recall';
      case 3: return 'Complaint investigation';
      case 4: return 'Others';
      case 0: return 'None';
      default: return 'None';
    }
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
    String? licenseExpiryDate,
    int? unlicensed,
    int? pmsActivity,
    String? sampleProductName,
    int? sampleNo,
    String? sampleBatch,
    String? followupComment,
    String? complaintProduct,
    String? otherActivity,
    String? previouslyLicensed,
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
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      unlicensed: unlicensed ?? this.unlicensed,
      pmsActivity: pmsActivity ?? this.pmsActivity,
      sampleProductName: sampleProductName ?? this.sampleProductName,
      sampleNo: sampleNo ?? this.sampleNo,
      sampleBatch: sampleBatch ?? this.sampleBatch,
      followupComment: followupComment ?? this.followupComment,
      complaintProduct: complaintProduct ?? this.complaintProduct,
      otherActivity: otherActivity ?? this.otherActivity,
      previouslyLicensed: previouslyLicensed ?? this.previouslyLicensed,
    );
  }
}