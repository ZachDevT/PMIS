import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/GdpRepo/GdpRepo.dart';
import 'package:pmis/features/pmis/gdp/models/GdpModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class GdpController extends GetxController {
  // List of GDP inspection activities.
  var activities = <GdpActivity>[].obs;
  final repository = GdpRepository();

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

  // Section: Personnel/Contact Details
  final contactQualificationsController = TextEditingController();
  final qualificationsController = TextEditingController();
  final nameController = TextEditingController();

  // Section: Facility Status & In-Charge
  var selectedFacilityStatus = ''.obs;

  // Section: Category of Facility
  var selectedCategoryOfFacility = ''.obs;

  // Section: Licensed/Unlicensed & Certification (in GDP, certification status applies)
  var selectedCertificationStatus = ''.obs;

  // Section: Category of Drugs
  var selectedCategoryOfDrugs = ''.obs;

  // Section: Additional GDP Details
  var selectedFacilityType = ''.obs;
  var recommendedForGpp = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
    // Mimic auto-filling GPS and current date/time (replace with real implementations)
    gpsLocationController.text = "Lat: 12.34, Lon: 56.78";
    inspectionDateController.text = DateTime.now().toLocal().toString().split(' ')[0];
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

  /// Validate and create a new GDP activity.
  Future<void> createNewActivity(BuildContext context) async {
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
      if (selectedCertificationStatus.value.isEmpty) {
        emptyFields.add("Certification Status");
      }
      if (selectedCategoryOfDrugs.value.isEmpty) {
        emptyFields.add("Category of Drugs");
      }
      if (selectedFacilityType.value.isEmpty) {
        emptyFields.add("Facility Type");
      }
      if (recommendedForGpp.value.isEmpty) {
        emptyFields.add("Recommended for GPP");
      }

      if (selectedFacilityStatus.value != "Closed" && emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message: "Please input all the values and select all the dropdown values: ${emptyFields.join(', ')}.",
        );
        return;
      }

      // Create a new GdpActivity from the form inputs.
      var newActivity = GdpActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectionTime: DateTime.now(), // Alternatively, parse from inspectionTimeController if needed.
        inspectorName: inspectorNameController.text,
        gpsLocation: gpsLocationController.text,
        region: selectedRegion.value,
        district: selectedDistrict.value,
        facilityName: facilityNameController.text,
        facilityStatus: selectedFacilityStatus.value,
        name: nameController.text,
        contactQualifications: contactQualificationsController.text,
        qualifications: qualificationsController.text,
        categoryOfFacility: selectedCategoryOfFacility.value,
        facilityType: selectedFacilityType.value,
        categoryOfDrugs: selectedCategoryOfDrugs.value,
        certificationStatus: selectedCertificationStatus.value,
        recommendedForGpp: recommendedForGpp.value,
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
    contactQualificationsController.clear();
    qualificationsController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    selectedCategoryOfFacility.value = '';
    selectedCertificationStatus.value = '';
    selectedCategoryOfDrugs.value = '';
    selectedFacilityType.value = '';
    recommendedForGpp.value = '';
    nameController.clear();
  }
}
