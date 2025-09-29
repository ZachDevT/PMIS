// controllers/CssController.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/CssRepository/CssRepository.dart';
import 'package:pmis/features/pmis/css/models/CssModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CssController extends GetxController {
  var activities = <CssModel>[].obs;
  var filteredActivities = <CssModel>[].obs;
  final repository = Get.find<CssRepository>();

  // Search and filter variables
  var searchQuery = ''.obs;
  var filterRegion = ''.obs;
  var filterFacilityStatus = ''.obs;
  var filterLicenseStatus = ''.obs;
  var filterCategoryOfDrugs = ''.obs;

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

  // Location variables
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var isGettingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
    getCurrentLocation(); // Get current location on init
    _autoFillDefaults();
    
    // Initialize filtered activities
    ever(activities, (_) => filterActivities());
    ever(searchQuery, (_) => filterActivities());
    ever(filterRegion, (_) => filterActivities());
    ever(filterFacilityStatus, (_) => filterActivities());
    ever(filterLicenseStatus, (_) => filterActivities());
    ever(filterCategoryOfDrugs, (_) => filterActivities());
  }

  void _autoFillDefaults() {
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    inspectionTimeController.text = TimeOfDay.now().format(Get.context!);
    // GPS location will be set by getCurrentLocation()
  }

  Future<void> loadActivities() async {
    try {
      var data = await repository.getCssData();
      var cssActivities = data.map((item) => CssModel.fromJson(item)).toList();
      activities.assignAll(cssActivities);
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: "Failed to load CSS data: ${e.toString()}");
    }
  }

  /// Filter activities based on search query and selected filters
  void filterActivities() {
    var filtered = activities.where((activity) {
      // Search query filter
      bool matchesSearch = searchQuery.value.isEmpty ||
          activity.facilityName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          activity.personName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          _getRegionName(activity.intRegion).toLowerCase().contains(searchQuery.value.toLowerCase());

      // Region filter
      bool matchesRegion = filterRegion.value.isEmpty ||
          _getRegionName(activity.intRegion) == filterRegion.value;

      // Facility status filter
      bool matchesFacilityStatus = filterFacilityStatus.value.isEmpty ||
          _getFacilityStatusText(activity.facilityStatus) == filterFacilityStatus.value;

      // License status filter
      bool matchesLicenseStatus = filterLicenseStatus.value.isEmpty ||
          _getLicenseStatusText(activity.licenseStatus) == filterLicenseStatus.value;

      // Category of drugs filter
      bool matchesCategoryOfDrugs = filterCategoryOfDrugs.value.isEmpty ||
          _getCategoryStatusText(activity.categoryStatus) == filterCategoryOfDrugs.value;

      return matchesSearch &&
          matchesRegion &&
          matchesFacilityStatus &&
          matchesLicenseStatus &&
          matchesCategoryOfDrugs;
    }).toList();

    filteredActivities.assignAll(filtered);
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Clear all filters
  void clearFilters() {
    searchQuery.value = '';
    filterRegion.value = '';
    filterFacilityStatus.value = '';
    filterLicenseStatus.value = '';
    filterCategoryOfDrugs.value = '';
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
      // Only require these fields if facility is not closed
      if (selectedFacilityStatus.value != "Closed") {
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
      }
      // Action Taken is always required
      if (selectedActionTaken.value.isEmpty) emptyFields.add("Action Taken");

      if (emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message:
              "Please fill in the following fields: ${emptyFields.join(', ')}.",
        );
        return;
      }

      var newActivity = CssModel(
        id: 0, // Will be set by API
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectorName: inspectorNameController.text,
        inspectorId: "INSP001", // Default inspector ID
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        intRegion: _getRegionGuid(selectedRegion.value),
        districtId: _getDistrictId(selectedDistrict.value),
        facilityName: facilityNameController.text,
        facilityStatus: _getFacilityStatus(selectedFacilityStatus.value),
        facilityPersonType: _getPersonType(selectedPersonFound.value),
        personName: nameController.text,
        contact: contactController.text,
        qualifications: qualificationsController.text,
        categoryOfpremises: _getCategoryOfPremises(selectedCategoryOfFacility.value),
        otherCategoryPremise: selectedCategoryOfFacility.value == "Other" ? "Other category" : "",
        licenseStatus: _getLicenseStatus(selectedLicensedStatus.value),
        licenseNo: "",
        unlicensed: _getUnlicensedStatus(selectedLicensedStatus.value) ?? 0,
        categoryStatus: _getCategoryStatus(selectedCategoryOfDrugs.value),
        premisesCondition: _getPremisesCondition(selectedConditionOfPremises.value),
        recordKeeping: _getRecordKeeping(selectedRecordKeeping.value) ?? 0,
        classofDrugs: _getClassOfDrugs(selectedClassOfDrugs.value) ?? 0,
        unRegisteredDrug: _getUnregisteredDrugs(selectedUnregisteredDrugs.value) ?? 0,
        unRegDrugQty: "",
        action: _getActionTaken(selectedActionTaken.value) ?? 0,
      );

      bool online = await NetworkManager.instance.isconnected();
      var activityData = newActivity.toJson();
      
      if (online) {
        try {
          print('Sending CSS data: $activityData'); // Debug log
          await repository.postCssData(activityData);
          activities.add(newActivity);
          Loaders.successSnackbar(
              title: "Success", message: "CSS activity added successfully...");
        } catch (e) {
          // If online submission fails, save locally as fallback
          await repository.saveActivityLocally(activityData);
          activities.add(newActivity);
          Loaders.errorSnackbar(
              title: "Network Error", 
              message: "Failed to send online. Saved locally for sync.");
        }
      } else {
        // For offline mode - save locally
        await repository.saveActivityLocally(activityData);
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

  // Helper methods for filter text conversion
  String _getFacilityStatusText(int status) {
    switch (status) {
      case 1: return "Open";
      case 0: return "Closed";
      default: return "Open";
    }
  }

  String _getLicenseStatusText(int status) {
    switch (status) {
      case 1: return "Licensed";
      case 2: return "Un-Licensed";
      case 3: return "Not-Applicable";
      default: return "Licensed";
    }
  }

  String _getCategoryStatusText(int status) {
    switch (status) {
      case 1: return "Medical Device";
      case 2: return "Veterinary drugs";
      case 3: return "Human drugs";
      case 4: return "Public Healthcare products";
      case 5: return "Herbal drugs";
      default: return "Medical Device";
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

  /// Get current location
  Future<void> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;
      
      // Check location permission
      PermissionStatus status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
      }
      
      if (status.isGranted) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        currentLatitude.value = position.latitude;
        currentLongitude.value = position.longitude;
        
        // Update GPS location controller
        gpsLocationController.text = 
            "Lat: ${position.latitude.toStringAsFixed(6)}, Lon: ${position.longitude.toStringAsFixed(6)}";
      } else {
        // Permission denied, use default values
        currentLatitude.value = 0.0;
        currentLongitude.value = 0.0;
        gpsLocationController.text = "Location permission denied";
      }
    } catch (e) {
      // Error getting location, use default values
      currentLatitude.value = 0.0;
      currentLongitude.value = 0.0;
      gpsLocationController.text = "Unable to get location";
    } finally {
      isGettingLocation.value = false;
    }
  }
}
