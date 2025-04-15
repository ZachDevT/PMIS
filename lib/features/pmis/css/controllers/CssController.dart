// controllers/CssController.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/CssRepo/CssRepo.dart';
import 'package:pmis/features/pmis/css/models/CssModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class CssController extends GetxController {
  var activities = <CssActivity>[].obs;
  final repository = CssRepository();

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final inspectionDateController = TextEditingController();
  final inspectionTimeController = TextEditingController();
  final inspectorNameController = TextEditingController();
  final gpsLocationController = TextEditingController();
  final facilityNameController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final qualificationsController = TextEditingController();

  // Dropdown Values
  var selectedRegion = ''.obs;
  var selectedDistrict = ''.obs;
  var selectedFacilityStatus = ''.obs;
  var selectedPersonFound = ''.obs;
  var selectedCategoryOfFacility = ''.obs;
  var selectedLicensedStatus = ''.obs;
  var selectedCategoryOfDrugs = ''.obs;
  var selectedClassOfDrugs = ''.obs;
  var selectedUnregisteredDrugs = ''.obs;
  var selectedConditionOfPremises = ''.obs;
  var selectedRecordKeeping = ''.obs;
  var selectedActionTaken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
    _autoFillDefaults();
  }

  void _autoFillDefaults() {
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    inspectionTimeController.text = TimeOfDay.now().format(Get.context!);
    gpsLocationController.text =
        'Lat: 12.34, Lon: 56.78'; // Replace with actual GPS logic
  }

  Future<void> loadActivities() async {
    try {
      var data = await repository.fetchActivities();
      activities.assignAll(data);
    } catch (e) {
      print('Error loading activities: $e');
    }
  }

  Future<void> createNewActivity(BuildContext context) async {
    try {
      if (!formKey.currentState!.validate()) return;
      List<String> emptyFields = [];
      if (selectedRegion.value.isEmpty) emptyFields.add("Region");
      if (selectedDistrict.value.isEmpty) emptyFields.add("District");
      if (selectedFacilityStatus.value.isEmpty) {
        emptyFields.add("Facility Status");
      }
      if (selectedFacilityStatus.value != "Closed") {
        if (selectedPersonFound.value.isEmpty) emptyFields.add("Person Found");
        if (nameController.text.isEmpty) emptyFields.add("Name");
        if (contactController.text.isEmpty) emptyFields.add("Contact");
        if (qualificationsController.text.isEmpty) {
          emptyFields.add("Qualifications");
        }
      }
      if (facilityNameController.text.isEmpty) emptyFields.add("Facility Name");
      if (selectedCategoryOfFacility.value.isEmpty) {
        emptyFields.add("Category of Facility");
      }
      if (selectedLicensedStatus.value.isEmpty) {
        emptyFields.add("Licensed Status");
      }
      if (selectedCategoryOfDrugs.value.isEmpty) {
        emptyFields.add("Category of Drugs");
      }
      if (selectedClassOfDrugs.value.isEmpty) emptyFields.add("Class of Drugs");
      if (selectedUnregisteredDrugs.value.isEmpty) {
        emptyFields.add("Unregistered Drugs");
      }
      if (selectedConditionOfPremises.value.isEmpty) {
        emptyFields.add("Condition of Premises");
      }
      if (selectedRecordKeeping.value.isEmpty) {
        emptyFields.add("Record Keeping");
      }
      if (selectedActionTaken.value.isEmpty) emptyFields.add("Action Taken");

      if (emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message:
              "Please fill in the following fields: ${emptyFields.join(', ')}.",
        );
        return;
      }

      var newActivity = CssActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectionTime: DateTime.now(),
        inspectorName: inspectorNameController.text,
        gpsLocation: gpsLocationController.text,
        region: selectedRegion.value,
        district: selectedDistrict.value,
        facilityName: facilityNameController.text,
        personFound: selectedPersonFound.value,
        name: nameController.text,
        contactQualifications: qualificationsController.text,
        facilityStatus: selectedFacilityStatus.value,
        contact: contactController.text,
        categoryOfFacility: selectedCategoryOfFacility.value,
        licensedStatus: selectedLicensedStatus.value,
        categoryOfDrugs: selectedCategoryOfDrugs.value,
        classOfDrugs: selectedClassOfDrugs.value,
        unregisteredDrugs: selectedUnregisteredDrugs.value,
        conditionOfPremises: selectedConditionOfPremises.value,
        recordKeeping: selectedRecordKeeping.value,
        actionTaken: selectedActionTaken.value,
      );

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
    gpsLocationController.clear();
    facilityNameController.clear();
    nameController.clear();
    contactController.clear();
    qualificationsController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    selectedPersonFound.value = '';
    selectedCategoryOfFacility.value = '';
    selectedLicensedStatus.value = '';
    selectedCategoryOfDrugs.value = '';
    selectedClassOfDrugs.value = '';
    selectedUnregisteredDrugs.value = '';
    selectedConditionOfPremises.value = '';
    selectedRecordKeeping.value = '';
    selectedActionTaken.value = '';
  }
}
