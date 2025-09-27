// controllers/CssController.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/CssRepository/CssRepository.dart';
import 'package:pmis/features/pmis/css/models/CssModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';

class CssController extends GetxController {
  var activities = <CssActivity>[].obs;
  final repository = Get.find<CssRepository>();

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
      var data = await repository.getCssData();
      var cssActivities = data.map((item) => CssActivity.fromJson(item)).toList();
      activities.assignAll(cssActivities);
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: "Failed to load CSS data: ${e.toString()}");
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
        facilityPersonType: _getPersonType(selectedPersonFound.value),
        personName: nameController.text,
        contact: contactController.text,
        qualifications: qualificationsController.text,
        categoryOfpremises: _getCategoryOfPremises(selectedCategoryOfFacility.value),
        other_CategoryPremise: null,
        licenseStatus: _getLicenseStatus(selectedLicensedStatus.value),
        licenseNo: null,
        unlicensed: _getUnlicensedStatus(selectedLicensedStatus.value),
        categoryStatus: _getCategoryStatus(selectedCategoryOfDrugs.value),
        premisesCondition: _getPremisesCondition(selectedConditionOfPremises.value),
        recordKeeping: _getRecordKeeping(selectedRecordKeeping.value),
        classofDrugs: _getClassOfDrugs(selectedClassOfDrugs.value),
        unRegisteredDrug: _getUnregisteredDrugs(selectedUnregisteredDrugs.value),
        unRegDrugQty: null,
        action: _getActionTaken(selectedActionTaken.value),
      );

      bool online = await NetworkManager.instance.isconnected();
      if (online) {
        // Convert CssActivity to Map for API
        var activityData = newActivity.toJson();
        print('Sending CSS data: $activityData'); // Debug log
        await repository.postCssData(activityData);
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Success", message: "CSS activity added successfully...");
      } else {
        // For offline mode
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message: "CSS activity saved locally. Will sync when online.");
      }
      // Clear the form fields after submission.
      clearForm();
      if (context.mounted) {
        Navigator.pop(context);
      }
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

  int? _getUnlicensedStatus(String status) {
    switch (status) {
      case "Licensed": return 0;
      case "Un-Licensed": return 1;
      case "Not-Applicable": return null;
      default: return 0;
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

  int _getPremisesCondition(String condition) {
    switch (condition) {
      case "Good": return 1;
      case "Fair": return 2;
      case "Poor": return 3;
      default: return 1;
    }
  }

  int? _getRecordKeeping(String keeping) {
    switch (keeping) {
      case "Good": return 1;
      case "Fair": return 2;
      case "Poor": return 3;
      default: return null;
    }
  }

  int? _getClassOfDrugs(String drugs) {
    switch (drugs) {
      case "Class A": return 1;
      case "Class B": return 2;
      case "Class C": return 3;
      default: return null;
    }
  }

  int? _getUnregisteredDrugs(String drugs) {
    switch (drugs) {
      case "Yes": return 1;
      case "No": return 0;
      default: return null;
    }
  }

  int? _getActionTaken(String action) {
    switch (action) {
      case "Warning": return 1;
      case "Fine": return 2;
      case "Closure": return 3;
      default: return null;
    }
  }
}
