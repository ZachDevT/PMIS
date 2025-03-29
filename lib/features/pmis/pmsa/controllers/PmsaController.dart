import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/PmsaRepo/PmsaRepo.dart';
import 'package:pmis/features/pmis/pmsa/models/PmsaModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class PmsaController extends GetxController {
  // List of PMSA activities.
  var activities = <PmsaActivity>[].obs;
  final repository = PmsaRepository();

  // ------------------ Form Controllers ------------------
  final formKey = GlobalKey<FormState>();

  // Section: Basic Information
  final inspectionDateController = TextEditingController();
  final inspectionTimeController = TextEditingController();
  final inspectorNameController = TextEditingController();
  final gpsLocationController = TextEditingController(); // auto-load current location

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
      var data = await repository.fetchActivities();
      activities.assignAll(data);
    } catch (e) {
      // Handle errors or load from local storage if needed.
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

      // Create a new PMSA activity from the form inputs.
      var newActivity = PmsaActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectionTime: DateTime.now(), // Alternatively, parse from inspectionTimeController if needed.
        inspectorName: inspectorNameController.text,
        gpsLocation: gpsLocationController.text,
        region: selectedRegion.value,
        district: selectedDistrict.value,
        facilityName: facilityNameController.text,
        facilityStatus: selectedFacilityStatus.value,
        personFoundAtFacility: personFoundAtFacility.value,
        name: nameController.text,
        contact: contactController.text,
        qualifications: qualificationsController.text,
        categoryOfFacility: selectedCategoryOfFacility.value,
        licensedStatus: licensedStatus.value,
        pmsaActivityCarriesOut: pmsaActivityCarriesOut.value,
        categoryOfDrugs: selectedCategoryOfDrugs.value,
        categoryOfProductSamples: selectedCategoryOfProductSamples.value,
        productSampledName: productSampledNameController.text,
        numberOfSamplesCollected:
            int.tryParse(numberOfSamplesCollectedController.text) ?? 0,
        batchNumberOfSample: batchNumberOfSampleController.text,
        productBeingFollowedUp: productBeingFollowedUpController.text,
        commentOnOverallFollowUp: commentOnOverallFollowUpController.text,
        productComplaintInvestigated:
            productComplaintInvestigatedController.text,
        specifyActivity: specifyActivityController.text,
      );

      // Check connectivity status.
      bool online = await NetworkManager.instance.isconnected();
      if (online) {
        activities.add(newActivity);
        await repository.addActivity(newActivity);
        Loaders.successSnackbar(
          title: "Success",
          message: "Activity added successfully...",
        );
      } else {
        await repository.saveActivityLocally(newActivity);
        activities.add(newActivity);
        Loaders.successSnackbar(
          title: "Offline",
          message: "Activity saved locally. Will sync when online.",
        );
      }
      // Clear form fields after submission.
      clearForm();
      Navigator.pop(context);
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
}
