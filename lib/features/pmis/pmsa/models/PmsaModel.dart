class PmsaActivity {
  final String id;
  final DateTime inspectionDate;
  final DateTime inspectionTime;
  final String inspectorName;
  final String gpsLocation;
  final String region;
  final String district;
  final String facilityName;
  final String facilityStatus;
  final String personFoundAtFacility;
  final String name;
  final String contact;
  final String qualifications;
  final String categoryOfFacility;
  final String licensedStatus;
  final String pmsaActivityCarriesOut;
  final String categoryOfDrugs;
  final String categoryOfProductSamples;
  final String productSampledName;
  final int numberOfSamplesCollected;
  final String batchNumberOfSample;
  final String productBeingFollowedUp;
  final String commentOnOverallFollowUp;
  final String productComplaintInvestigated;
  final String specifyActivity;

  PmsaActivity({
    required this.id,
    required this.inspectionDate,
    required this.inspectionTime,
    required this.inspectorName,
    required this.gpsLocation,
    required this.region,
    required this.district,
    required this.facilityName,
    required this.facilityStatus,
    required this.personFoundAtFacility,
    required this.name,
    required this.contact,
    required this.qualifications,
    required this.categoryOfFacility,
    required this.licensedStatus,
    required this.pmsaActivityCarriesOut,
    required this.categoryOfDrugs,
    required this.categoryOfProductSamples,
    required this.productSampledName,
    required this.numberOfSamplesCollected,
    required this.batchNumberOfSample,
    required this.productBeingFollowedUp,
    required this.commentOnOverallFollowUp,
    required this.productComplaintInvestigated,
    required this.specifyActivity,
  });

  factory PmsaActivity.fromJson(Map<String, dynamic> json) {
    return PmsaActivity(
      id: json['id'],
      inspectionDate: DateTime.parse(json['inspectionDate']),
      inspectionTime: DateTime.parse(json['inspectionTime']),
      inspectorName: json['inspectorName'],
      gpsLocation: json['gpsLocation'],
      region: json['region'],
      district: json['district'],
      facilityName: json['facilityName'],
      facilityStatus: json['facilityStatus'],
      personFoundAtFacility: json['personFoundAtFacility'],
      name: json['name'],
      contact: json['contact'],
      qualifications: json['qualifications'],
      categoryOfFacility: json['categoryOfFacility'],
      licensedStatus: json['licensedStatus'],
      pmsaActivityCarriesOut: json['pmsaActivityCarriesOut'],
      categoryOfDrugs: json['categoryOfDrugs'],
      categoryOfProductSamples: json['categoryOfProductSamples'],
      productSampledName: json['productSampledName'],
      numberOfSamplesCollected: json['numberOfSamplesCollected'],
      batchNumberOfSample: json['batchNumberOfSample'],
      productBeingFollowedUp: json['productBeingFollowedUp'],
      commentOnOverallFollowUp: json['commentOnOverallFollowUp'],
      productComplaintInvestigated: json['productComplaintInvestigated'],
      specifyActivity: json['specifyActivity'],
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
      'personFoundAtFacility': personFoundAtFacility,
      'name': name,
      'contact': contact,
      'qualifications': qualifications,
      'categoryOfFacility': categoryOfFacility,
      'licensedStatus': licensedStatus,
      'pmsaActivityCarriesOut': pmsaActivityCarriesOut,
      'categoryOfDrugs': categoryOfDrugs,
      'categoryOfProductSamples': categoryOfProductSamples,
      'productSampledName': productSampledName,
      'numberOfSamplesCollected': numberOfSamplesCollected,
      'batchNumberOfSample': batchNumberOfSample,
      'productBeingFollowedUp': productBeingFollowedUp,
      'commentOnOverallFollowUp': commentOnOverallFollowUp,
      'productComplaintInvestigated': productComplaintInvestigated,
      'specifyActivity': specifyActivity,
    };
  }
}
