import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/shiftmarket/models/ShiftMarketModel.dart';
import 'package:pmis/data/repositories/ShiftMarketRepository/ShiftMarketRepository.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';

class ShiftMarketController extends GetxController {
  // List of Shift Market activities
  var activities = <ShiftMarketModel>[].obs;
  var filteredActivities = <ShiftMarketModel>[].obs;
  final repository = Get.find<ShiftMarketRepository>();

  // Search and filter variables
  var searchQuery = ''.obs;
  var filterRegion = ''.obs;
  var filterDistrict = ''.obs;
  var filterFacilityStatus = ''.obs;
  var filterCategoryOfPremises = ''.obs;

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
  final inspectionTimeController = TextEditingController();
  final inspectorNameController = TextEditingController();

  // Section: Location Details
  var selectedRegion = ''.obs;
  var selectedDistrict = ''.obs;
  final facilityNameController = TextEditingController();

  // Section: Facility Details
  var selectedFacilityStatus = ''.obs;
  var selectedPersonFoundAtFacility =
      ''.obs; // New field replacing removed person fields

  // Section: Category and Actions
  var selectedCategoryOfPremises = ''.obs;
  var selectedRegulatoryAction = ''.obs;
  final regulatoryActionTakenController = TextEditingController();
  final consignmentsImpoundedController = TextEditingController();
  var selectedLicenseStatus = 'Licensed'.obs;
  var selectedPreviouslyLicensed = ''.obs;
  final licenseNoController = TextEditingController();
  final licenseExpiryController = TextEditingController();

  // GPS Location controller (auto-filled)
  final gpsLocationController = TextEditingController();

  // Category of Premises options
  final List<String> categoryOfPremisesOptions = [
    "Wholesale Pharmacy - Human",
    "Wholesale Pharmacy - Vet",
    "Retail Pharmacy - Human",
    "Retail Pharmacy - Vet",
    "Drug Shop",
    "External Stores",
    "Hospital",
    "HCIV",
    "HCIII",
    "Clinic",
    "Herbal Selling Outlet",
    "Shift Market",
    "Pharmaceutical/Medical Device Manufacturing Premise",
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
        selectedPersonFoundAtFacility.value = '';
        // clear visible controllers
        regulatoryActionTakenController.clear();
        consignmentsImpoundedController.clear();
        selectedCategoryOfPremises.value = '';
        selectedLicenseStatus.value = '';
        licenseNoController.clear();
        licenseExpiryController.clear();
      }
    });
  }

  void _initializeForm() {
    // Set default values
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    final now = DateTime.now();
    inspectionTimeController.text =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';

    // Initialize with current location
    getCurrentLocation();

    // Auto-fill inspector name
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      inspectorNameController.text = authController.userDisplayName;
    }

    // Default license status to Licensed so fields show by default
    selectedLicenseStatus.value = 'Licensed';
    // Default facility status to Open so fields show by default
    selectedFacilityStatus.value = 'Open';
    selectedCategoryOfPremises.value = 'Shift Market';
  }

  /// Load activities from local storage or API
  Future<void> loadActivities() async {
    try {
      isLoading.value = true;
      var data = await repository.getShiftMarketData();
      var shiftMarketActivities =
          data.map((item) => ShiftMarketModel.fromJson(item)).toList();
      activities.assignAll(shiftMarketActivities);
      filterActivities();
    } catch (e) {
      Loaders.errorSnackbar(
          title: "Error",
          message: "Failed to load ShiftMarket activities: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update search query and filter activities
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterActivities();
  }

  /// Submit ShiftMarket activity
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

      // Create ShiftMarket model
      final shiftMarketActivity = ShiftMarketModel(
        inspectionDate:
            "${inspectionDateController.text} ${inspectionTimeController.text}",
        inspectorName: inspectorNameController.text,
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        region: RegionDistrictConstants.getRegionForDistrict(
            selectedDistrict.value),
        district: selectedDistrict.value,
        facilityName: facilityNameController.text,
        facilityStatus: selectedFacilityStatus.value,
        personFoundAtFacility: selectedFacilityStatus.value == 'Closed'
            ? ''
            : selectedPersonFoundAtFacility.value,
        categoryOfPremises: selectedFacilityStatus.value == 'Closed'
            ? ''
            : selectedCategoryOfPremises.value,
        licenseStatus: selectedFacilityStatus.value == 'Closed'
            ? ''
            : selectedLicenseStatus.value,
        licenseNo: selectedFacilityStatus.value == 'Closed'
            ? ''
            : licenseNoController.text,
        licenseExpiryDate: selectedFacilityStatus.value == 'Closed'
            ? ''
            : licenseExpiryController.text,
        regulatoryActionTaken: regulatoryActionTakenController.text,
        consignmentsImpounded: consignmentsImpoundedController.text,
        previouslyLicensed: selectedFacilityStatus.value == 'Closed'
            ? ''
            : selectedPreviouslyLicensed.value,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      bool online = await NetworkManager.instance.isconnected();
      var activityData = shiftMarketActivity.toJson();

      print('🔍 DEBUG: Network status: $online');
      print('🔍 DEBUG: ShiftMarket activity data to send: $activityData');

      if (online) {
        try {
          print('🚀 DEBUG: Attempting to send ShiftMarket data to API...');
          var result = await repository.postShiftMarketData(activityData);
          print('✅ DEBUG: API response received: $result');

          activities.add(shiftMarketActivity.copyWith(isSynced: true));
          Loaders.successSnackbar(
              title: "Success",
              message: "ShiftMarket activity sent to API successfully!");
          Navigator.pop(Get.context!); // Close on success
        } catch (e) {
          print('❌ DEBUG: API call failed: $e');
          // If online submission fails, save locally as fallback
          await repository.saveActivityLocally(activityData);
          activities.add(shiftMarketActivity);
          Loaders.errorSnackbar(
              title: "Network Error",
              message: "Failed to send to API. Saved locally for sync.");
          Navigator.pop(Get.context!); // Close on fallback success
        }
      } else {
        print('📱 DEBUG: Offline mode - saving locally');
        // For offline mode - save locally
        await repository.saveActivityLocally(activityData);
        activities.add(shiftMarketActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message:
                "ShiftMarket activity saved locally. Will sync when online.");
        Navigator.pop(Get.context!); // Close on success
      }

      filterActivities();
      clearForm();
    } catch (e) {
      Loaders.errorSnackbar(
          title: "Error", message: "Failed to submit activity");
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Filter activities based on search and filter criteria
  void filterActivities() {
    // Get current user info
    final authController =
        Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    final isAdmin = authController?.isAdmin ?? false;
    final userDisplayName = authController?.userDisplayName ?? '';

    var filtered = activities.where((activity) {
      // Role-based filter: If not admin, only show activities created by this user
      // Match by inspectorName since ShiftMarketModel doesn't have inspectorId
      if (!isAdmin && userDisplayName.isNotEmpty) {
        if (activity.inspectorName.toLowerCase() !=
            userDisplayName.toLowerCase()) {
          return false;
        }
      }

      bool matchesSearch = searchQuery.value.isEmpty ||
          activity.facilityName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          activity.inspectorName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          activity.personFoundAtFacility
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      bool matchesRegion =
          filterRegion.value.isEmpty || activity.region == filterRegion.value;

      bool matchesDistrict = filterDistrict.value.isEmpty ||
          activity.district == filterDistrict.value;

      // Remove facilityStatus filter since field no longer exists
      // bool matchesFacilityStatus = filterFacilityStatus.value.isEmpty ||
      //     activity.facilityStatus == filterFacilityStatus.value;

      bool matchesCategory = filterCategoryOfPremises.value.isEmpty ||
          activity.categoryOfPremises == filterCategoryOfPremises.value;

      return matchesSearch &&
          matchesRegion &&
          matchesDistrict &&
          matchesCategory;
    }).toList();

    // Sort by creation date (latest first)
    filtered.sort((a, b) {
      final aDate = a.createdAt ??
          DateTime.tryParse(a.inspectionDate) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ??
          DateTime.tryParse(b.inspectionDate) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    filteredActivities.value = filtered;
  }

  void clearForm() {
    inspectionDateController.clear();
    inspectionTimeController.clear();
    inspectorNameController.clear();
    facilityNameController.clear();
    regulatoryActionTakenController.clear();
    selectedRegulatoryAction.value = '';
    consignmentsImpoundedController.clear();
    licenseNoController.clear();
    licenseExpiryController.clear();
    selectedLicenseStatus.value = '';
    selectedFacilityStatus.value = '';
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedPersonFoundAtFacility.value = '';
    selectedCategoryOfPremises.value = '';

    // Re-initialize with current values
    _initializeForm();
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

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
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
