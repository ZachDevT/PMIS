// ------------------ GetX Controller ------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/GppRepo/GppRepo.dart';
import 'package:pmis/features/pmis/css/models/CssModel.dart';
import 'package:pmis/features/pmis/gpp/models/GppModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class GppController extends GetxController {
  var activities = <GppActivity>[].obs;
  final repository = GppRepository();

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
      var data = await repository.fetchActivities();
      activities.assignAll(data);
    } catch (e) {
      // Handle error and maybe load from local storage if offline.
    }
  }

  /// Validate and create a new activity.
  Future<void> createNewActivity(context) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      List<String> emptyFields = [];

      if (selectedFacilityStatus.value.isEmpty)
        emptyFields.add("Facility Status");
      if (selectedCategoryOfFacility.value.isEmpty)
        emptyFields.add("Category of Facility");
      if (personFoundController.value.isEmpty) emptyFields.add("Person Found");
      if (selectedLicensedStatus.value.isEmpty)
        emptyFields.add("Licensed Status");
      if (selectedCategoryOfDrugs.value.isEmpty)
        emptyFields.add("Category of Drugs");
      if (selectedFacilityType.value.isEmpty) emptyFields.add("Facility Type");
      if (selectedCertificationStatus.value.isEmpty)
        emptyFields.add("Certification Status");
      if (recommendedForGpp.value.isEmpty)
        emptyFields.add("Recommended for GPP");

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
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectionTime: DateTime
            .now(),
        inspectorName: inspectorNameController.text,
        gpsLocation: gpsLocationController.text,
        region: selectedRegion.value,
        district: selectedDistrict.value,
        facilityName: facilityNameController.text,
        personFound: personFoundController.value,
        contactQualifications: QualificationsController.text,
        facilityStatus: selectedFacilityStatus.value,
        name: nameController.text,

        categoryOfFacility: selectedCategoryOfFacility.value,
        licensedStatus: selectedLicensedStatus.value,
        categoryOfDrugs: selectedCategoryOfDrugs.value,
        facilityType: selectedFacilityType.value,
        certificationStatus: selectedCertificationStatus.value,
        recommendedForGpp: recommendedForGpp.value,
        contact: contactController.text,
      );

      // Here, check for connectivity (this is a dummy flag).
      bool online = await NetworkManager.instance.isconnected();
      if (online) {
        // Mimic API call to create new activity.
        activities.add(newActivity);
        await repository.addActivity(newActivity);
        Loaders.successSnackbar(
            title: "Success", message: "Activity added successfully...");
      } else {
        await repository.saveActivityLocally(newActivity);
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message: "Activity saved locally. Will sync when online.");
      }
      // Clear the form fields after submission.
      clearForm();
      Navigator.pop(context);
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: e.toString());
      // Handle error and maybe load from local storage if offline.
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
}
