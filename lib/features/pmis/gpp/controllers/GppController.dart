// ------------------ GetX Controller ------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/GppRepository/GppRepository.dart';
import 'package:pmis/features/pmis/gpp/models/GppModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class GppController extends GetxController {
  var activities = <GppActivity>[].obs;
  final repository = Get.find<GppRepository>();

  // ------------------ Form Controllers ------------------
  final formKey = GlobalKey<FormState>();

  // Section: Basic Information
  final inspectionDateController = TextEditingController();
  final inspectionTimeController = TextEditingController();
  final inspectorNameController = TextEditingController();
  final contactController = TextEditingController();
  final gpsLocationController =
      TextEditingController(); // auto-load current location

  // Section: Region Details
  var selectedRegion = ''.obs;
  var selectedDistrict = ''.obs;

  // Section: Facility Details
  final facilityNameController = TextEditingController();

  final QualificationsController = TextEditingController();
  final nameController = TextEditingController();

  // Section: Facility Status & In-Charge
  var selectedFacilityStatus = ''.obs;

  // Section: Category of Facility
  var selectedCategoryOfFacility = ''.obs;
  var personFoundController = ''.obs;

  // Section: Licensed/Unlicensed
  var selectedLicensedStatus = ''.obs;

  // Section: Category of Drugs
  var selectedCategoryOfDrugs = ''.obs;

  // Section: GPP Details
  var selectedFacilityType = ''.obs;
  var selectedCertificationStatus = ''.obs;
  var recommendedForGpp = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
    // Mimic auto-filling GPS and current date/time (replace with real implementations)
    gpsLocationController.text = "Lat: 12.34, Lon: 56.78";
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    inspectionTimeController.text = TimeOfDay.now().format(Get.context!);
  }

  Future<void> loadActivities() async {
    try {
      var data = await repository.getGppData();
      // Convert API data to GppActivity models
      var gppActivities = data.map((item) => GppActivity.fromJson(item)).toList();
      activities.assignAll(gppActivities);
    } catch (e) {
      // Handle error and maybe load from local storage if offline.
      Loaders.errorSnackbar(title: "Error", message: "Failed to load GPP data: ${e.toString()}");
    }
  }

  /// Validate and create a new activity.
  Future<void> createNewActivity(context) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      List<String> emptyFields = [];

      if (selectedFacilityStatus.value.isEmpty) {
        emptyFields.add("Facility Status");
      }
      if (selectedCategoryOfFacility.value.isEmpty) {
        emptyFields.add("Category of Facility");
      }
      if (personFoundController.value.isEmpty) emptyFields.add("Person Found");
      if (selectedLicensedStatus.value.isEmpty) {
        emptyFields.add("Licensed Status");
      }
      if (selectedCategoryOfDrugs.value.isEmpty) {
        emptyFields.add("Category of Drugs");
      }
      if (selectedFacilityType.value.isEmpty) emptyFields.add("Facility Type");
      if (selectedCertificationStatus.value.isEmpty) {
        emptyFields.add("Certification Status");
      }
      if (recommendedForGpp.value.isEmpty) {
        emptyFields.add("Recommended for GPP");
      }

      if (selectedFacilityStatus.value != "Closed" && emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message:
              "Please input all the values and select all the dropdown values: ${emptyFields.join(', ')}.",
        );
        return;
      }
      // Create a new GppActivity from the form inputs.
      var newActivity = GppActivity(
        id: 0, // Will be set by API
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectorName: inspectorNameController.text,
        gps: gpsLocationController.text,
        intRegion: _getRegionGuid(selectedRegion.value),
        districtId: _getDistrictId(selectedDistrict.value),
        facilityName: facilityNameController.text,
        facilityStatus: _getFacilityStatus(selectedFacilityStatus.value),
        facilityPersonType: _getPersonType(personFoundController.value),
        personName: nameController.text,
        contact: contactController.text,
        qualifications: QualificationsController.text,
        categoryOfpremises: _getCategoryOfPremises(selectedCategoryOfFacility.value),
        licenseStatus: _getLicenseStatus(selectedLicensedStatus.value),
        categoryStatus: _getCategoryStatus(selectedCategoryOfDrugs.value),
        facilityType: _getFacilityType(selectedFacilityType.value),
        certStatus: _getCertStatus(selectedCertificationStatus.value),
        recommendedforGPP: _getRecommendedForGpp(recommendedForGpp.value),
        inspectorId: null,
        latitude: 0.0,
        longitude: 0.0,
        licenseNo: null,
      );

      // Here, check for connectivity (this is a dummy flag).
      bool online = await NetworkManager.instance.isconnected();
      if (online) {
        // Convert GppActivity to Map for API
        var activityData = newActivity.toJson();
        print('Sending GPP data: $activityData'); // Debug log
        await repository.postGppData(activityData);
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Success", message: "Activity added successfully...");
      } else {
        // For offline mode, you might want to implement local storage
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message: "Activity saved locally. Will sync when online.");
      }
      // Clear the form fields after submission.
      clearForm();
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = "Failed to create GPP activity";
      if (e.toString().contains("ValidationException")) {
        errorMessage = "Please check all required fields are filled correctly";
      } else if (e.toString().contains("NetworkException")) {
        errorMessage = "Network error. Please check your connection";
      } else if (e.toString().contains("AuthException")) {
        errorMessage = "Authentication required. Please login again";
      } else if (e.toString().contains("ServerException")) {
        errorMessage = "Server error. Please try again later";
      }
      Loaders.errorSnackbar(title: "Error", message: errorMessage);
    }
  }

  void clearForm() {
    inspectionDateController.clear();
    inspectionTimeController.clear();
    inspectorNameController.clear();
    // gpsLocationController remains as it is auto-filled.
    facilityNameController.clear();
    personFoundController.value = '';
    QualificationsController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    selectedCategoryOfFacility.value = '';
    selectedLicensedStatus.value = '';
    selectedCategoryOfDrugs.value = '';
    selectedFacilityType.value = '';
    selectedCertificationStatus.value = '';
    recommendedForGpp.value = '';
    contactController.clear();
    nameController.clear();
  }

  // Helper methods to map form values to API values
  String _getRegionGuid(String region) {
    // Map region names to actual GUIDs from the API
    switch (region) {
      case "Central Region":
      case "Kampala":
        return "deaf2c98-3dbb-489f-bdea-9e5fd49eec78";
      case "Eastern Region":
        return "57a2afce-98b8-48b2-984e-cc04e3d84264";
      case "Northern Region":
        return "12345678-1234-1234-1234-123456789012";
      case "Western Region":
        return "87654321-4321-4321-4321-210987654321";
      default:
        return "deaf2c98-3dbb-489f-bdea-9e5fd49eec78"; // Default to Central Region
    }
  }

  String _getRegionName(String guid) {
    // Map GUIDs back to region names for display
    switch (guid) {
      case "deaf2c98-3dbb-489f-bdea-9e5fd49eec78":
        return "Central Region";
      case "57a2afce-98b8-48b2-984e-cc04e3d84264":
        return "Eastern Region";
      case "12345678-1234-1234-1234-123456789012":
        return "Northern Region";
      case "87654321-4321-4321-4321-210987654321":
        return "Western Region";
      default:
        return "Central Region";
    }
  }

  int _getDistrictId(String district) {
    switch (district) {
      case "District A": return 1;
      case "District B": return 2;
      case "District C": return 3;
      case "District D": return 4;
      default: return 1;
    }
  }

  int _getFacilityStatus(String status) {
    switch (status) {
      case "Open": return 1;
      case "Closed": return 0;
      default: return 1;
    }
  }

  int _getPersonType(String personType) {
    switch (personType) {
      case "In-charge": return 1;
      case "(Attendant/Operator)": return 2;
      default: return 1;
    }
  }

  int _getCategoryOfPremises(String category) {
    switch (category) {
      case "Retail Pharmacy": return 1;
      case "Drug Shop": return 2;
      case "Hospital": return 3;
      case "HCIV": return 4;
      case "HCIII": return 5;
      case "Clinic": return 6;
      default: return 1;
    }
  }

  int _getLicenseStatus(String status) {
    switch (status) {
      case "Licensed": return 1;
      case "Un-Licensed": return 2;
      case "Not-Applicable": return 3;
      default: return 1;
    }
  }

  int _getCategoryStatus(String category) {
    switch (category) {
      case "Medical Device": return 1;
      case "Veterinary drugs": return 2;
      case "Human drugs": return 3;
      case "Public Healthcare products": return 4;
      case "Herbal drugs": return 5;
      default: return 1;
    }
  }

  int _getFacilityType(String type) {
    switch (type) {
      case "Public Facility": return 1;
      case "Private Facility": return 2;
      default: return 1;
    }
  }

  int _getCertStatus(String status) {
    switch (status) {
      case "Certified": return 1;
      case "Not certified": return 2;
      default: return 1;
    }
  }

  int _getRecommendedForGpp(String recommendation) {
    switch (recommendation) {
      case "GPP certification": return 1;
      case "Not recommended for GPP certification": return 0;
      default: return 1;
    }
  }
}
