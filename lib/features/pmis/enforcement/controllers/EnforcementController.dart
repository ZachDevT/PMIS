import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/enforcement/models/EnforcementModel.dart';
import 'package:pmis/data/repositories/EnforcementRepository/EnforcementRepository.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';

class EnforcementController extends GetxController {
  // List of Enforcement activities
  var activities = <EnforcementModel>[].obs;
  var filteredActivities = <EnforcementModel>[].obs;
  final repository = Get.find<EnforcementRepository>();

  // Search and filter variables
  var searchQuery = ''.obs;
  var filterRegion = ''.obs;
  var filterDistrict = ''.obs;
  var filterFacilityStatus = ''.obs;
  var filterLicenseStatus = ''.obs;
  var filterEnforcementAction = ''.obs;

  // Form state
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var isGettingLocation = false.obs;

  // Location data
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;

  // ------------------ Form Controllers ------------------
  final formKey = GlobalKey<FormState>();

  // Section: Basic Information
  final inspectionDateController = TextEditingController();
  final gpsController = TextEditingController();
  final inspectorNameController = TextEditingController();
  final inspectorIdController = TextEditingController();

  // Section: Location Details
  var selectedRegion = ''.obs;
  var selectedDistrict = ''.obs;
  final facilityNameController = TextEditingController();

  // Section: Facility Details
  var selectedFacilityStatus = ''.obs;
  var selectedPersonFoundAtFacility = ''.obs;
  final personNameController = TextEditingController();
  final contactController = TextEditingController();
  final qualificationsController = TextEditingController();

  // Section: Category and Licensing
  var selectedCategoryOfPremises = ''.obs;
  var selectedLicenseStatus = 'Licensed'.obs;
  var selectedPreviouslyLicensed = ''.obs;
  var selectedCategoryStatus = ''.obs;
  final licenseNoController = TextEditingController();
  final licenseExpiryController = TextEditingController();

  // Section: Enforcement Actions
  var selectedEnforcementActionTaken = ''.obs;
  var selectedEnforcementActions = <String>[].obs;
  final otherCategoryController = TextEditingController();
  final commentsController = TextEditingController();

  // GPS Location controller (auto-filled)
  final gpsLocationController = TextEditingController();

  // Category of Premises options
  final List<String> categoryOfPremisesOptions = [
    "Wholesale Pharmacy",
    "Retail Pharmacy",
    "Drug Shop",
    "External Stores",
    "Hospital",
    "HCIV",
    "HCIII",
    "Clinic",
    "Herbal Selling Outlet",
    "Shift Market",
    "Pharmaceutical/Medical Device Manufacturing Premise",
    "RTS(Radio talk Show)",
    "Enforcement",
    "Other"
  ];

  // Enforcement Action options
  final List<String> enforcementActionOptions = [
    "Impound",
    "Warning",
    "Fine",
    "Closure",
    "Seizure",
    "Arrest",
    "Other"
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
    // Defer activity loading to avoid blocking main thread during initialization
    Future.microtask(() => loadActivities());
    // Clear dependent fields when facility status changes to Closed
    ever(selectedFacilityStatus, (String _) {
      if (selectedFacilityStatus.value == 'Closed') {
        personNameController.clear();
        contactController.clear();
        qualificationsController.clear();
        selectedCategoryOfPremises.value = '';
        selectedLicenseStatus.value = '';
        licenseNoController.clear();
        licenseExpiryController.clear();
        selectedCategoryStatus.value = '';
      }
    });
  }

  void _initializeForm() {
    // Set default values
    inspectionDateController.text = DateTime.now().toString();

    // Default license status to Licensed so fields show by default
    selectedLicenseStatus.value = 'Licensed';

    // Auto-fill inspector details from AuthController
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      inspectorNameController.text = authController.userDisplayName;
      inspectorIdController.text = authController.userId;
    }

    // Initialize with current location
    getCurrentLocation();
  }

  /// Load activities from local storage or API
  Future<void> loadActivities() async {
    try {
      isLoading.value = true;
      var data = await repository.getEnforcementData();
      var enforcementActivities =
          data.map((item) => EnforcementModel.fromJson(item)).toList();
      activities.assignAll(enforcementActivities);
      filterActivities();
    } catch (e) {
      Loaders.errorSnackbar(
          title: "Error",
          message: "Failed to load Enforcement activities: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update search query and filter activities
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterActivities();
  }

  /// Submit Enforcement activity
  Future<void> submitActivity() async {
    if (!formKey.currentState!.validate()) {
        Loaders.errorSnackbar(
          title: "Incomplete Form",
          message: "Please fill in all the required fields.",
        );
        return;
      }

    try {
      isSubmitting.value = true;

      // Create Enforcement model
        final enforcementActivity = EnforcementModel(
        inspectionDate: inspectionDateController.text,
        gps: "${currentLatitude.value}, ${currentLongitude.value}",
        region: selectedRegion.value,
        district: selectedDistrict.value,
        facilityName: facilityNameController.text,
        facilityStatus: selectedFacilityStatus.value,
        personFoundAtFacility: selectedPersonFoundAtFacility.value,
        // When facility is Closed, clear person/contact/qualifications and
        // related category/license fields to mirror GPP/GDP behavior.
        personName: selectedFacilityStatus.value == "Closed"
          ? ""
          : personNameController.text,
        contact: selectedFacilityStatus.value == "Closed"
          ? ""
          : contactController.text,
        qualifications: selectedFacilityStatus.value == "Closed"
          ? ""
          : qualificationsController.text,
        categoryOfPremises: selectedFacilityStatus.value == "Closed"
          ? ""
          : (selectedCategoryOfPremises.value == "Other" ? otherCategoryController.text : selectedCategoryOfPremises.value),
        licenseStatus: selectedFacilityStatus.value == "Closed"
          ? ""
          : selectedLicenseStatus.value,
        licenseNo: selectedFacilityStatus.value == "Closed"
          ? ""
          : licenseNoController.text,
        licenseExpiryDate: selectedFacilityStatus.value == "Closed"
          ? ""
          : licenseExpiryController.text,
        categoryStatus: selectedFacilityStatus.value == "Closed"
          ? ""
          : selectedCategoryStatus.value,
        enforcementActionTaken: selectedEnforcementActions.join(", "),
        comments: commentsController.text,
        createdAt: DateTime.now(),
        inspectorName: inspectorNameController.text,
        inspectorId: inspectorIdController.text,
        isSynced: false,
        );

      bool online = await NetworkManager.instance.isconnected();
      var activityData = enforcementActivity.toJson();

      print('🔍 DEBUG: Network status: $online');
      print('🔍 DEBUG: Enforcement activity data to send: $activityData');

      if (online) {
        try {
          print('🚀 DEBUG: Attempting to send Enforcement data to API...');
          var result = await repository.postEnforcementData(activityData);
          print('✅ DEBUG: API response received: $result');

          activities.add(enforcementActivity);
          Loaders.successSnackbar(
              title: "Success",
              message: "Enforcement activity sent to API successfully!");
        } catch (e) {
          print('❌ DEBUG: API call failed: $e');
          // If online submission fails, save locally as fallback
          await repository.saveActivityLocally(activityData);
          activities.add(enforcementActivity);
          Loaders.errorSnackbar(
              title: "Network Error",
              message: "Failed to send to API. Saved locally for sync.");
        }
      } else {
        print('📱 DEBUG: Offline mode - saving locally');
        // For offline mode - save locally
        await repository.saveActivityLocally(activityData);
        activities.add(enforcementActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message:
                "Enforcement activity saved locally. Will sync when online.");
      }

      filterActivities();
      clearForm();
    } catch (e) {
      Loaders.errorSnackbar(
          title: "Error", message: "Failed to submit activity");
    } finally {
      isSubmitting.value = false;
      Navigator.pop(Get.context!); // Close the modal bottom sheet
    }
  }

  /// Filter activities based on search and filter criteria
  void filterActivities() {
    var filtered = activities.where((activity) {
      bool matchesSearch = searchQuery.value.isEmpty ||
          activity.facilityName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          activity.personName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      bool matchesRegion =
          filterRegion.value.isEmpty || activity.region == filterRegion.value;

      bool matchesDistrict = filterDistrict.value.isEmpty ||
          activity.district == filterDistrict.value;

      bool matchesFacilityStatus = filterFacilityStatus.value.isEmpty ||
          activity.facilityStatus == filterFacilityStatus.value;

      bool matchesLicenseStatus = filterLicenseStatus.value.isEmpty ||
          activity.licenseStatus == filterLicenseStatus.value;

      bool matchesEnforcementAction = filterEnforcementAction.value.isEmpty ||
          activity.enforcementActionTaken == filterEnforcementAction.value;

      return matchesSearch &&
          matchesRegion &&
          matchesDistrict &&
          matchesFacilityStatus &&
          matchesLicenseStatus &&
          matchesEnforcementAction;
    }).toList();

    // Sort by creation date (latest first)
    filtered.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });

    filteredActivities.value = filtered;
  }

  void clearForm() {
    inspectionDateController.clear();
    gpsController.clear();
    inspectorNameController.clear();
    inspectorIdController.clear();
    facilityNameController.clear();
    personNameController.clear();
    contactController.clear();
    qualificationsController.clear();
    commentsController.clear();
    licenseNoController.clear();
    licenseExpiryController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    selectedPersonFoundAtFacility.value = '';
    selectedCategoryOfPremises.value = '';
    selectedLicenseStatus.value = '';
    selectedCategoryStatus.value = '';
    selectedEnforcementActionTaken.value = '';
    selectedEnforcementActions.clear();
    otherCategoryController.clear();

    // Re-initialize with current values
    _initializeForm();
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
        gpsController.text =
            "Lat: ${position.latitude.toStringAsFixed(6)}, Lon: ${position.longitude.toStringAsFixed(6)}";
      } else {
        // Permission denied, use default values
        currentLatitude.value = 0.0;
        currentLongitude.value = 0.0;
        gpsController.text = "Location permission denied";
      }
    } catch (e) {
      // Error getting location, use default values
      currentLatitude.value = 0.0;
      currentLongitude.value = 0.0;
      gpsController.text = "Unable to get location";
    } finally {
      isGettingLocation.value = false;
    }
  }

  // Helper methods to map form values to API values
  String getRegionGuid(String region) {
    return RegionDistrictConstants.getRegionGuid(region);
  }

  int getDistrictId(String district) {
    return RegionDistrictConstants.getDistrictId(district);
  }

  String getRegionName(String guid) {
    return RegionDistrictConstants.getRegionName(guid);
  }

  String getDistrictName(int id) {
    return RegionDistrictConstants.getDistrictName(id);
  }
}
