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
  final String licenseExpiryDate;
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
    required this.licenseExpiryDate,
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
    // Debug: Print what we're receiving
    print('=== CSS Model fromJson Debug ===');
    print('JSON keys: ${json.keys.toList()}');
    print('Raw inspectorName: ${json['inspectorName']}');
    print('Raw InspectorName: ${json['InspectorName']}');
    print('Raw inspectorId: ${json['inspectorId']}');
    print('Raw InspectorId: ${json['InspectorId']}');
    
    final inspectorName = json['inspectorName'] ?? json['InspectorName'] ?? '';
    final inspectorId = json['inspectorId'] ?? json['InspectorId'] ?? '';
    
    print('Final inspectorName: $inspectorName');
    print('Final inspectorId: $inspectorId');
    print('=== End CSS Model Debug ===');
    
    return CssModel(
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
      licenseExpiryDate: json['licenseExpiryDate'] ?? json['LicenseExpiryDate'] ?? '',
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
      'licenseExpiryDate': licenseExpiryDate,
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

  String _getCategoryStatusText(int status) {
    switch (status) {
      case 1: return 'Medical Device';
      case 2: return 'Veterinary drugs';
      case 3: return 'Human drugs';
      case 4: return 'Public Healthcare products';
      case 5: return 'Herbal drugs';
      default: return 'Unknown';
    }
  }

  String _getPremisesConditionText(int condition) {
    switch (condition) {
      case 1: return 'Good';
      case 2: return 'Fair';
      case 3: return 'Poor';
      default: return 'Unknown';
    }
  }

  String _getRecordKeepingText(int? keeping) {
    if (keeping == null) return 'Not specified';
    switch (keeping) {
      case 1: return 'Good';
      case 2: return 'Fair';
      case 3: return 'Poor';
      default: return 'Unknown';
    }
  }

  String _getClassOfDrugsText(int? drugs) {
    if (drugs == null) return 'Not specified';
    switch (drugs) {
      case 1: return 'Class A';
      case 2: return 'Class B';
      case 3: return 'Class C';
      default: return 'Unknown';
    }
  }

  String _getUnregisteredDrugsText(int? drugs) {
    if (drugs == null) return 'Not specified';
    switch (drugs) {
      case 1: return 'Present';
      case 0: return 'Not Present';
      default: return 'Unknown';
    }
  }

  String _getActionText(int? action) {
    if (action == null) return 'Not specified';
    switch (action) {
      case 1: return 'Closed';
      case 2: return 'Outlet abandoned by owner';
      case 3: return 'Impounded';
      case 4: return 'Suspect arrested';
      case 5: return 'No action taken';
      default: return 'Unknown';
    }
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
    String? licenseExpiryDate,
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
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
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