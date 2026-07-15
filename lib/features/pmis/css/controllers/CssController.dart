// controllers/CssController.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/CssRepository/CssRepository.dart';
import 'package:pmis/features/pmis/css/models/CssModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';

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
  final inspectorIdController = TextEditingController();
  final gpsLocationController = TextEditingController();
  final facilityNameController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final qualificationsController = TextEditingController();
  final otherCategoryPremiseController = TextEditingController();
  final licenseNoController = TextEditingController();
  final licenseExpiryDateController = TextEditingController();
  final unRegDrugQtyController = TextEditingController();

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
  var selectedActionTaken = <String>[].obs;
  var selectedPreviouslyLicensed = ''.obs;

  // Location variables
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var isGettingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Defer activity loading to avoid blocking main thread during initialization
    Future.microtask(() => loadActivities());
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
    final now = DateTime.now();
    inspectionTimeController.text =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
    // GPS location will be set by getCurrentLocation()

    // Prepopulate inspector name and ID from logged-in user
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      inspectorNameController.text = authController.userDisplayName;
      inspectorIdController.text = authController.userId;
    }
  }

  Future<void> loadActivities() async {
    try {
      print('=== CSS Controller: Loading Activities ===');
      var data = await repository.getCssData();
      print('CSS Controller: Raw data received: ${data.length} records');
      if (data.isNotEmpty) {
        print('CSS Controller: First record: ${data.first}');
      }
      var cssActivities = data.map((item) => CssModel.fromJson(item)).toList();
      print('CSS Controller: Parsed activities: ${cssActivities.length}');
      if (cssActivities.isNotEmpty) {
        print(
            'CSS Controller: First parsed activity inspectorName: ${cssActivities.first.inspectorName}');
        print(
            'CSS Controller: First parsed activity inspectorId: ${cssActivities.first.inspectorId}');
      }
      activities.assignAll(cssActivities);
      print('=== End CSS Controller: Loading Activities ===');
    } catch (e) {
      // Repository now handles network errors gracefully and returns empty list
      // Only show error for unexpected errors
      if (!e.toString().contains('SocketException') &&
          !e.toString().contains('NetworkException')) {
        print('CSS Controller Error: $e');
        Loaders.errorSnackbar(
            title: "Error",
            message:
                "Failed to load CSS data. Please check your connection and try again.");
      } else {
        print(
            'CSS Controller: No network connection, loading from local storage if available');
      }
      // Ensure activities list is initialized even on error
      if (activities.isEmpty) {
        activities.assignAll([]);
      }
    }
  }

  /// Filter activities based on search query and selected filters
  void filterActivities() {
    // Get current user info
    final authController =
        Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    final isAdmin = authController?.isAdmin ?? false;
    final userId = authController?.userId ?? '';

    var filtered = activities.where((activity) {
      // Role-based filter: If not admin, only show activities created by this user
      if (!isAdmin && userId.isNotEmpty) {
        if (activity.inspectorId != userId) {
          return false;
        }
      }

      // Search query filter
      bool matchesSearch = searchQuery.value.isEmpty ||
          activity.facilityName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          activity.personName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          _getRegionName(activity.intRegion)
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      // Region filter
      bool matchesRegion = filterRegion.value.isEmpty ||
          _getRegionName(activity.intRegion) == filterRegion.value;

      // Facility status filter
      bool matchesFacilityStatus = filterFacilityStatus.value.isEmpty ||
          _getFacilityStatusText(activity.facilityStatus) ==
              filterFacilityStatus.value;

      // License status filter
      bool matchesLicenseStatus = filterLicenseStatus.value.isEmpty ||
          _getLicenseStatusText(activity.licenseStatus) ==
              filterLicenseStatus.value;

      // Category of drugs filter
      bool matchesCategoryOfDrugs = filterCategoryOfDrugs.value.isEmpty ||
          _getCategoryStatusText(activity.categoryStatus) ==
              filterCategoryOfDrugs.value;

      return matchesSearch &&
          matchesRegion &&
          matchesFacilityStatus &&
          matchesLicenseStatus &&
          matchesCategoryOfDrugs;
    }).toList();

    // Sort by inspection date (latest first)
    filtered.sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));

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
      if (!formKey.currentState!.validate()) {
        Loaders.errorSnackbar(
          title: "Incomplete Form",
          message: "Please fill in all the required fields.",
        );
        return;
      }
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
        if (selectedClassOfDrugs.value.isEmpty)
          emptyFields.add("Class of Drugs");
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
      // Action Taken is only required when facility is Open
      if (selectedFacilityStatus.value == "Open") {
        if (selectedActionTaken.value.isEmpty) emptyFields.add("Action Taken");
      }

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
        inspectionDate: DateTime.parse("${inspectionDateController.text} ${inspectionTimeController.text}"),
        inspectorName: inspectorNameController.text,
        inspectorId: inspectorIdController.text,
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
        categoryOfpremises:
            _getCategoryOfPremises(selectedCategoryOfFacility.value),
        otherCategoryPremise: selectedCategoryOfFacility.value == "Others"
            ? otherCategoryPremiseController.text
            : "",
        licenseStatus: _getLicenseStatus(selectedLicensedStatus.value),
        licenseNo: selectedLicensedStatus.value == "Licensed"
            ? licenseNoController.text
            : "",
        licenseExpiryDate: selectedLicensedStatus.value == "Licensed"
            ? licenseExpiryDateController.text
            : "",
        unlicensed: _getUnlicensedStatus(selectedLicensedStatus.value) ?? 0,
        categoryStatus: _getCategoryStatus(selectedCategoryOfDrugs.value),
        premisesCondition:
            _getPremisesCondition(selectedConditionOfPremises.value),
        recordKeeping: _getRecordKeeping(selectedRecordKeeping.value) ?? 0,
        classofDrugs: _getClassOfDrugs(selectedClassOfDrugs.value) ?? 0,
        unRegisteredDrug:
            _getUnregisteredDrugs(selectedUnregisteredDrugs.value) ?? 0,
        unRegDrugQty: selectedUnregisteredDrugs.value == "Present"
            ? unRegDrugQtyController.text
            : "",
        previouslyLicensed: selectedPreviouslyLicensed.value,
        action: selectedActionTaken.join(', '),
      );

      bool online = await NetworkManager.instance.isconnected();
      var activityData = newActivity.toJson();

      if (online) {
        try {
          print('Sending CSS data: $activityData'); // Debug log
          await repository.postCssData(activityData);
          activities.add(newActivity);
          // Show success message
          Loaders.successSnackbar(
              title: "Success", message: "CSS activity added successfully...");
          // Wait a moment to ensure snackbar is visible before closing
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          // If online submission fails, save locally as fallback
          await repository.saveActivityLocally(activityData);
          activities.add(newActivity);
          Loaders.errorSnackbar(
              title: "Network Error",
              message: "Failed to send online. Saved locally for sync.");
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } else {
        // For offline mode - save locally
        await repository.saveActivityLocally(activityData);
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message: "CSS activity saved locally. Will sync when online.");
        // Wait a moment to ensure snackbar is visible before closing
        await Future.delayed(const Duration(milliseconds: 500));
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
    inspectorIdController.clear();
    gpsLocationController.clear();
    facilityNameController.clear();
    nameController.clear();
    contactController.clear();
    qualificationsController.clear();
    otherCategoryPremiseController.clear();
    licenseNoController.clear();
    licenseExpiryDateController.clear();
    unRegDrugQtyController.clear();
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
    selectedActionTaken.clear();
    selectedPreviouslyLicensed.value = '';
  
    _autoFillDefaults();
  }

  // Helper methods to map form values to API values
  String _getRegionGuid(String region) {
    return RegionDistrictConstants.getRegionGuid(region);
  }

  int _getDistrictId(String district) {
    return RegionDistrictConstants.getDistrictId(district);
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
      case "Wholesale Pharmacy":
        return 1;
      case "Retail Pharmacy":
        return 2;
      case "Drug Shop":
        return 3;
      case "External Stores":
        return 4;
      case "Hospital":
        return 5;
      case "HCIV":
        return 6;
      case "HCIII":
        return 7;
      case "Clinic":
        return 8;
      case "Herbal Selling Outlet":
        return 9;
      case "Shift Market":
        return 10;
      case "Pharmaceutical/Medical Device Manufacturing Premise":
        return 11;
      case "Others":
        return 12;
      default:
        return 2; // Default to Retail Pharmacy
    }
  }

  int _getLicenseStatus(String status) {
    switch (status) {
      case "Licensed":
        return 1;
      case "Un-Licensed":
      case "Unlicensed":
        return 2;
      case "Not-Applicable":
      case "Not Applicable":
        return 3;
      default:
        return 1;
    }
  }

  int? _getUnlicensedStatus(String status) {
    switch (status) {
      case "Licensed":
        return 0;
      case "Un-Licensed":
      case "Unlicensed":
        return 1;
      case "Not-Applicable":
      case "Not Applicable":
        return null;
      default:
        return 0;
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

  int _getPremisesCondition(String condition) {
    switch (condition) {
      case "Good":
        return 1;
      case "Fair":
        return 2;
      case "Poor":
        return 3;
      default:
        return 1;
    }
  }

  int? _getRecordKeeping(String keeping) {
    switch (keeping) {
      case "Good":
        return 1;
      case "Fair":
        return 2;
      case "Poor":
        return 3;
      default:
        return null;
    }
  }

  int? _getClassOfDrugs(String drugs) {
    switch (drugs) {
      case "Class A":
        return 1;
      case "Class B":
        return 2;
      case "Class C":
        return 3;
      default:
        return null;
    }
  }

  int? _getUnregisteredDrugs(String drugs) {
    switch (drugs) {
      case "Yes":
        return 1;
      case "No":
        return 0;
      default:
        return null;
    }
  }

  

  // Helper methods for filter text conversion
  String _getFacilityStatusText(int status) {
    switch (status) {
      case 1:
        return "Open";
      case 0:
        return "Closed";
      default:
        return "Open";
    }
  }

  String _getLicenseStatusText(int status) {
    switch (status) {
      case 1:
        return "Licensed";
      case 2:
        return "Un-Licensed";
      case 3:
        return "Not-Applicable";
      default:
        return "Licensed";
    }
  }

  String _getCategoryStatusText(int status) {
    switch (status) {
      case 1:
        return "Medical Device";
      case 2:
        return "Veterinary drugs";
      case 3:
        return "Human drugs";
      case 4:
        return "Public Healthcare products";
      case 5:
        return "Herbal drugs";
      default:
        return "Medical Device";
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

      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentLatitude.value = 0.3156;
        currentLongitude.value = 32.5811;
        gpsLocationController.text = "Lat: 0.315600, Lon: 32.581100";
        return;
      }

      // 2. Check and request geolocator permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        // 3. Try to get current position with low accuracy and 4s timeout
        Position? position;
        try {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 4),
          );
        } catch (e) {
          // Timeout or exception, try to get last known position
          position = await Geolocator.getLastKnownPosition();
        }

        if (position != null) {
          currentLatitude.value = position.latitude;
          currentLongitude.value = position.longitude;
          gpsLocationController.text =
              "Lat: ${position.latitude.toStringAsFixed(6)}, Lon: ${position.longitude.toStringAsFixed(6)}";
        } else {
          currentLatitude.value = 0.3156;
          currentLongitude.value = 32.5811;
          gpsLocationController.text = "Lat: 0.315600, Lon: 32.581100";
        }
      } else {
        currentLatitude.value = 0.3156;
        currentLongitude.value = 32.5811;
        gpsLocationController.text = "Lat: 0.315600, Lon: 32.581100";
      }
    } catch (e) {
      currentLatitude.value = 0.3156;
      currentLongitude.value = 32.5811;
      gpsLocationController.text = "Lat: 0.315600, Lon: 32.581100";
    } finally {
      isGettingLocation.value = false;
    }
  }
}
