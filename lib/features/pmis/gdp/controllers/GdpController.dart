import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/GdpRepository/GdpRepository.dart';
import 'package:pmis/features/pmis/gdp/models/GdpModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';

class GdpController extends GetxController {
  // List of GDP inspection activities.
  var activities = <GdpModel>[].obs;
  var filteredActivities = <GdpModel>[].obs;
  final repository = GdpRepository();

  // Search and filter variables
  var searchQuery = ''.obs;
  var filterRegion = ''.obs;
  var filterFacilityStatus = ''.obs;
  var filterCertificationStatus = ''.obs;
  var filterCategoryOfDrugs = ''.obs;

  // ------------------ Form Controllers ------------------
  final formKey = GlobalKey<FormState>();

  // Section: Basic Information
  final inspectionDateController = TextEditingController();
  final inspectionTimeController = TextEditingController();
  final inspectorNameController = TextEditingController();
  final inspectorIdController = TextEditingController();
  final gpsLocationController =
      TextEditingController(); // auto-load current location

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
  var personFoundController = ''.obs; // Add person found dropdown

  // Section: Category of Facility
  var selectedCategoryOfFacility = ''.obs;
  final otherCategoryPremiseController = TextEditingController();

  // Section: Licensed/Unlicensed & Certification (in GDP, certification status applies)
  var selectedLicenseStatus = ''.obs;
  var selectedCertificationStatus = ''.obs;
  final licenseNoController = TextEditingController();
  final licenseExpiryDateController = TextEditingController();
  var selectedPreviouslyLicensed = ''.obs;

  // Section: Category of Drugs
  var selectedCategoryOfDrugs = ''.obs;

  // Section: Additional GDP Details
  var selectedFacilityType = ''.obs;
  var recommendedForGpp = ''.obs;

  // Contact controller for phone/email
  final contactController = TextEditingController();

  // Location variables
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var isGettingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Register listeners BEFORE loading so initial data propagates to filtered list
    ever(activities, (_) => filterActivities());
    ever(searchQuery, (_) => filterActivities());
    ever(filterRegion, (_) => filterActivities());
    ever(filterFacilityStatus, (_) => filterActivities());
    ever(filterCertificationStatus, (_) => filterActivities());
    ever(filterCategoryOfDrugs, (_) => filterActivities());

    // Defer activity loading to avoid blocking main thread during initialization
    Future.microtask(() => loadActivities());
    getCurrentLocation(); // Get current location on init
    _autoFillDefaults(); // Prepopulate inspector info

    // Initialize filtered activities if repo is empty
    if (activities.isEmpty) {
      filterActivities();
    }
  }

  void _autoFillDefaults() {
    // Set current date/time
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    final now = DateTime.now();
    inspectionTimeController.text =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';

    // Prepopulate inspector name and ID from logged-in user
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      inspectorNameController.text = authController.userDisplayName;
      inspectorIdController.text = authController.userId;
    }

    // Default license status to Licensed so fields show by default
    selectedLicenseStatus.value = 'Licensed';
  }

  Future<void> loadActivities() async {
    try {
      print('=== GDP Controller: Loading Activities ===');
      var data = await repository.fetchActivities();
      print('GDP Controller: Raw data received: ${data.length} records');
      if (data.isNotEmpty) {
        print('GDP Controller: First record: ${data.first}');
      }
      var gdpActivities = data.map((item) => GdpModel.fromJson(item)).toList();
      print('GDP Controller: Parsed activities: ${gdpActivities.length}');
      if (gdpActivities.isNotEmpty) {
        print(
            'GDP Controller: First parsed activity inspectorName: ${gdpActivities.first.inspectorName}');
        print(
            'GDP Controller: First parsed activity inspectorId: ${gdpActivities.first.inspectorId}');
      }
      activities.assignAll(gdpActivities);
      // Ensure UI reflects initial load immediately
      filterActivities();
      print('=== End GDP Controller: Loading Activities ===');
    } catch (e) {
      print('GDP Controller Error: $e');
      Loaders.errorSnackbar(
          title: "Error", message: "Failed to load GDP data: ${e.toString()}");
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

      // Certification status filter
      bool matchesCertificationStatus =
          filterCertificationStatus.value.isEmpty ||
              _getCertStatusText(activity.certStatus) ==
                  filterCertificationStatus.value;

      // Category of drugs filter
      bool matchesCategoryOfDrugs = filterCategoryOfDrugs.value.isEmpty ||
          _getCategoryStatusText(activity.categoryStatus) ==
              filterCategoryOfDrugs.value;

      return matchesSearch &&
          matchesRegion &&
          matchesFacilityStatus &&
          matchesCertificationStatus &&
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
    filterCertificationStatus.value = '';
    filterCategoryOfDrugs.value = '';
  }

  /// Validate and create a new GDP activity.
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

      if (selectedFacilityStatus.value.isEmpty) {
        emptyFields.add("Facility Status");
      }

      // Only require these fields if facility is not closed
      if (selectedFacilityStatus.value != "Closed") {
        if (selectedCategoryOfFacility.value.isEmpty) {
          emptyFields.add("Category of Facility");
        }
        if (selectedCertificationStatus.value.isEmpty) {
          emptyFields.add("Certification Status");
        }
        if (selectedLicenseStatus.value.isEmpty) {
          emptyFields.add("License Status");
        }
        if (selectedLicenseStatus.value == "Licensed" &&
            licenseExpiryDateController.text.isEmpty) {
          emptyFields.add("License Expiry Date");
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
      }

      if (emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message:
              "Please input all the values and select all the dropdown values: ${emptyFields.join(', ')}.",
        );
        return;
      }

      // Create a new GdpModel from the form inputs.
      var newActivity = GdpModel(
        id: DateTime.now().millisecondsSinceEpoch,
        inspectionDate: DateTime.parse("${inspectionDateController.text} ${inspectionTimeController.text}"),
        inspectorName: inspectorNameController.text,
        gps: gpsLocationController.text,
        intRegion: _getRegionGuid(selectedRegion.value),
        districtId: _getDistrictId(selectedDistrict.value),
        facilityName: facilityNameController.text,
        facilityStatus: _getFacilityStatus(selectedFacilityStatus.value),
        facilityPersonType: selectedFacilityStatus.value == "Closed"
            ? 0
            : _getPersonType(personFoundController.value),
        personName:
            selectedFacilityStatus.value == "Closed" ? "" : nameController.text,
        contact: selectedFacilityStatus.value == "Closed"
            ? ""
            : contactController.text,
        qualifications: selectedFacilityStatus.value == "Closed"
            ? ""
            : qualificationsController.text,
        categoryOfpremises: selectedFacilityStatus.value == "Closed"
            ? 0
            : _getCategoryOfPremises(selectedCategoryOfFacility.value),
        licenseStatus: selectedFacilityStatus.value == "Closed"
            ? 0
            : _getLicenseStatus(selectedLicenseStatus.value),
        categoryStatus: selectedFacilityStatus.value == "Closed"
            ? 0
            : _getCategoryStatus(selectedCategoryOfDrugs.value),
        facilityType: selectedFacilityStatus.value == "Closed"
            ? 0
            : _getFacilityType(selectedFacilityType.value),
        certStatus: selectedFacilityStatus.value == "Closed"
            ? 0
            : _getCertStatus(selectedCertificationStatus.value),
        recommendedforGDP: selectedFacilityStatus.value == "Closed"
            ? 0
            : _getRecommendedForGdp(recommendedForGpp.value),
        inspectorId: inspectorIdController.text,
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        licenseNo: selectedFacilityStatus.value == "Closed"
            ? ""
            : (selectedLicenseStatus.value == "Licensed"
                ? licenseNoController.text
                : ""),
        licenseExpiryDate: selectedFacilityStatus.value == "Closed"
            ? ""
            : (selectedLicenseStatus.value == "Licensed"
                ? licenseExpiryDateController.text
                : ""),
        previouslyLicensed: selectedFacilityStatus.value == "Closed"
            ? ""
            : selectedPreviouslyLicensed.value,
      );

      // Check connectivity status.
      bool online = await NetworkManager.instance.isconnected();
      var activityData = newActivity.toJson();

      if (online) {
        try {
          print('Sending GDP data: $activityData'); // Debug log
          await repository.addActivity(activityData);
          activities.add(newActivity);
          Loaders.successSnackbar(
            title: "Success",
            message: "GDP activity added successfully...",
          );
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
          message: "GDP activity saved locally. Will sync when online.",
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
    inspectorIdController.clear();
    // gpsLocationController remains auto-filled.
    facilityNameController.clear();
    contactQualificationsController.clear();
    qualificationsController.clear();
    contactController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    personFoundController.value = '';
    selectedCategoryOfFacility.value = '';
    otherCategoryPremiseController.clear();
    selectedLicenseStatus.value = '';
    selectedCertificationStatus.value = '';
    selectedCategoryOfDrugs.value = '';
    selectedFacilityType.value = '';
    recommendedForGpp.value = '';
    licenseNoController.clear();
    licenseExpiryDateController.clear();
    nameController.clear();
  
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

  int _getFacilityType(String type) {
    switch (type) {
      case "Public Facility":
        return 1;
      case "Private Facility":
        return 2;
      default:
        return 1;
    }
  }

  int _getCertStatus(String status) {
    switch (status) {
      case "Certified":
        return 1;
      case "Not certified":
        return 2;
      default:
        return 1;
    }
  }

  int _getRecommendedForGdp(String recommendation) {
    switch (recommendation) {
      case "GDP certification":
        return 1;
      case "Not recommended for GDP certification":
        return 0;
      default:
        return 1;
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

  String _getCertStatusText(int status) {
    switch (status) {
      case 1:
        return "Certified";
      case 2:
        return "Not certified";
      default:
        return "Certified";
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
