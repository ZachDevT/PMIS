import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/PmsRepository/PmsRepository.dart';
import 'package:pmis/features/pmis/pmsa/models/PmsModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class PmsaController extends GetxController {
  // List of PMS activities.
  var activities = <PmsActivity>[].obs;
  final repository = Get.find<PmsRepository>();

  // ------------------ Form Controllers ------------------
  final formKey = GlobalKey<FormState>();

  // Section: Basic Information
  final inspectionDateController = TextEditingController();
  final inspectionTimeController = TextEditingController();
  final inspectorNameController = TextEditingController();
  final gpsLocationController =
      TextEditingController(); // auto-load current location

  // Section: Region Details
  var selectedRegion = ''.obs;
  var selectedDistrict = ''.obs;

  // Section: Facility Details
  final facilityNameController = TextEditingController();
  var selectedFacilityStatus = ''.obs;

  // Section: Additional Facility Information (if facility is not closed)
  var personFoundAtFacility = ''.obs;
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final qualificationsController = TextEditingController();

  // Section: Facility Category & Licensing
  var selectedCategoryOfFacility = ''.obs;
  var licensedStatus = ''.obs;

  // Section: PMSA Activity
  var pmsaActivityCarriesOut = ''.obs;

  // Section: Drugs & Product Sampling
  var selectedCategoryOfDrugs = ''.obs;
  var selectedCategoryOfProductSamples = ''.obs;
  final productSampledNameController = TextEditingController();
  final numberOfSamplesCollectedController = TextEditingController();
  final batchNumberOfSampleController = TextEditingController();

  // Section: Follow-up & Complaint Details
  final productBeingFollowedUpController = TextEditingController();
  final commentOnOverallFollowUpController = TextEditingController();
  final productComplaintInvestigatedController = TextEditingController();
  final specifyActivityController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadActivities();
    // Mimic auto-filling GPS, current date and time (replace with real implementations)
    gpsLocationController.text = "Lat: 12.34, Lon: 56.78";
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    inspectionTimeController.text = TimeOfDay.now().format(Get.context!);
  }

  Future<void> loadActivities() async {
    try {
      var data = await repository.getPmsData();
      var pmsActivities =
          data.map((item) => PmsActivity.fromJson(item)).toList();
      activities.assignAll(pmsActivities);
    } catch (e) {
      Loaders.errorSnackbar(
          title: "Error", message: "Failed to load PMS data: ${e.toString()}");
    }
  }

  /// Validate and create a new PMSA activity.
  Future<void> createNewActivity(BuildContext context) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      List<String> emptyFields = [];

      // Basic validations
      if (selectedFacilityStatus.value.isEmpty) {
        emptyFields.add("Facility Status");
      }
      if (selectedCategoryOfFacility.value.isEmpty) {
        emptyFields.add("Category of Facility");
      }
      if (licensedStatus.value.isEmpty) {
        emptyFields.add("Licensed Status");
      }
      if (pmsaActivityCarriesOut.value.isEmpty) {
        emptyFields.add("PMSA Activity");
      }
      if (selectedCategoryOfDrugs.value.isEmpty) {
        emptyFields.add("Category of Drugs");
      }
      if (selectedCategoryOfProductSamples.value.isEmpty) {
        emptyFields.add("Category of Product Samples");
      }
      // If facility is not closed, require additional details.
      if (selectedFacilityStatus.value != "Closed") {
        if (personFoundAtFacility.value.isEmpty) {
          emptyFields.add("Person Found at Facility");
        }
        if (nameController.text.isEmpty) {
          emptyFields.add("Contact Name");
        }
        if (contactController.text.isEmpty) {
          emptyFields.add("Contact");
        }
        if (qualificationsController.text.isEmpty) {
          emptyFields.add("Qualifications");
        }
      }
      // Follow-up & complaint details are required.
      if (productBeingFollowedUpController.text.isEmpty) {
        emptyFields.add("Product Being Followed Up");
      }
      if (commentOnOverallFollowUpController.text.isEmpty) {
        emptyFields.add("Comment on Overall Follow Up");
      }
      if (productComplaintInvestigatedController.text.isEmpty) {
        emptyFields.add("Product Complaint Investigated");
      }
      if (specifyActivityController.text.isEmpty) {
        emptyFields.add("Specify Activity");
      }

      if (emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message:
              "Please fill all required fields: ${emptyFields.join(', ')}.",
        );
        return;
      }

      // Create a new PMS activity from the form inputs.
      var newActivity = PmsActivity(
        id: 0, // Will be set by API
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectorName: inspectorNameController.text,
        inspectorId: null,
        latitude: 0.0,
        longitude: 0.0,
        intRegion: _getRegionGuid(selectedRegion.value),
        districtId: _getDistrictId(selectedDistrict.value),
        facilityName: facilityNameController.text,
        facilityStatus: _getFacilityStatus(selectedFacilityStatus.value),
        facilityPersonType: _getPersonType(personFoundAtFacility.value),
        personName: nameController.text,
        contact: contactController.text,
        qualifications: qualificationsController.text,
        categoryOfpremises:
            _getCategoryOfPremises(selectedCategoryOfFacility.value),
        licenseStatus: _getLicenseStatus(licensedStatus.value),
        licenseNo: null,
        categoryStatus: _getCategoryStatus(selectedCategoryOfDrugs.value),
      );

      // Check connectivity status.
      bool online = await NetworkManager.instance.isconnected();
      if (online) {
        // Convert PmsActivity to Map for API
        var activityData = newActivity.toJson();
        print('Sending PMS data: $activityData'); // Debug log
        await repository.postPmsData(activityData);
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Success", message: "PMS activity added successfully...");
      } else {
        // For offline mode
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message: "PMS activity saved locally. Will sync when online.");
      }
      // Clear form fields after submission.
      clearForm();
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: e.toString());
    }
  }

  void clearForm() {
    inspectionDateController.clear();
    inspectionTimeController.clear();
    inspectorNameController.clear();
    // gpsLocationController remains auto-filled.
    facilityNameController.clear();
    personFoundAtFacility.value = '';
    nameController.clear();
    contactController.clear();
    qualificationsController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    selectedCategoryOfFacility.value = '';
    licensedStatus.value = '';
    pmsaActivityCarriesOut.value = '';
    selectedCategoryOfDrugs.value = '';
    selectedCategoryOfProductSamples.value = '';
    productSampledNameController.clear();
    numberOfSamplesCollectedController.clear();
    batchNumberOfSampleController.clear();
    productBeingFollowedUpController.clear();
    commentOnOverallFollowUpController.clear();
    productComplaintInvestigatedController.clear();
    specifyActivityController.clear();
  }

  // Helper methods to map form values to API values
  String _getRegionGuid(String region) {
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
        return "deaf2c98-3dbb-489f-bdea-9e5fd49eec78";
    }
  }

  int _getDistrictId(String district) {
    switch (district) {
      case "District A":
        return 1;
      case "District B":
        return 2;
      case "District C":
        return 3;
      case "District D":
        return 4;
      default:
        return 1;
    }
  }

  int _getFacilityStatus(String status) {
    switch (status) {
      case "Open":
        return 1;
      case "Closed":
        return 0;
      default:
        return 1;
    }
  }

  int _getPersonType(String personType) {
    switch (personType) {
      case "In-charge":
        return 1;
      case "(Attendant/Operator)":
        return 2;
      default:
        return 1;
    }
  }

  int _getCategoryOfPremises(String category) {
    switch (category) {
      case "Retail Pharmacy":
        return 1;
      case "Drug Shop":
        return 2;
      case "Hospital":
        return 3;
      case "HCIV":
        return 4;
      case "HCIII":
        return 5;
      case "Clinic":
        return 6;
      default:
        return 1;
    }
  }

  int _getLicenseStatus(String status) {
    switch (status) {
      case "Licensed":
        return 1;
      case "Un-Licensed":
        return 2;
      case "Not-Applicable":
        return 3;
      default:
        return 1;
    }
  }

  int _getCategoryStatus(String category) {
    switch (category) {
      case "Medical Device":
        return 1;
      case "Veterinary drugs":
        return 2;
      case "Human drugs":
        return 3;
      case "Public Healthcare products":
        return 4;
      case "Herbal drugs":
        return 5;
      default:
        return 1;
    }
  }
}
