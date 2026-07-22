import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/PmsaRepo/PmsaRepo.dart';
import 'package:pmis/features/pmis/pmsa/models/PmsModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';

class PmsaController extends GetxController {
  // List of PMS activities.
  var activities = <PmsModel>[].obs;
  var filteredActivities = <PmsModel>[].obs;
  final repository = Get.find<PmsaRepository>();

  // Search and filter variables
  var searchQuery = ''.obs;
  var filterRegion = ''.obs;
  var filterFacilityStatus = ''.obs;
  var filterLicenseStatus = ''.obs;
  var filterPmsActivity = ''.obs;

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
  var selectedFacilityStatus = ''.obs;

  // Section: Additional Facility Information (if facility is not closed)
  var personFoundAtFacility = ''.obs;
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final qualificationsController = TextEditingController();
  final selectedQualification = ''.obs;
  final selectedQualificationId = Rxn<int>();

  // Section: Facility Category & Licensing
  var selectedCategoryOfFacility = ''.obs;
  var licensedStatus = ''.obs;
  var selectedPreviouslyLicensed = ''.obs;
  final licenseNoController = TextEditingController();
  final licenseExpiryDateController = TextEditingController();

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
  final postMarketComplaintNotedController = TextEditingController();
  final specifyActivityController = TextEditingController();

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
    _autoFillDefaults(); // Prepopulate inspector info

    // Initialize filtered activities
    ever(activities, (_) => filterActivities());
    ever(searchQuery, (_) => filterActivities());
    ever(filterRegion, (_) => filterActivities());
    ever(filterFacilityStatus, (_) => filterActivities());
    ever(filterLicenseStatus, (_) => filterActivities());
    ever(filterPmsActivity, (_) => filterActivities());
  }

  void _autoFillDefaults() {
    // Set current date/time
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    final now = DateTime.now();
    inspectionTimeController.text =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
    numberOfSamplesCollectedController.text = "0";

    // Prepopulate inspector name and ID from logged-in user
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      inspectorNameController.text = authController.userDisplayName;
      inspectorIdController.text = authController.userId;
    }
  }

  Future<void> loadActivities() async {
    try {
      print('=== PMSA Controller: Loading Activities ===');
      var data = await repository.getPmsData();
      print('PMSA Controller: Raw data received: ${data.length} records');
      if (data.isNotEmpty) {
        print('PMSA Controller: First record: ${data.first}');
      }
      var pmsActivities = data.map((item) => PmsModel.fromJson(item)).toList();
      print('PMSA Controller: Parsed activities: ${pmsActivities.length}');
      if (pmsActivities.isNotEmpty) {
        print(
            'PMSA Controller: First parsed activity inspectorName: ${pmsActivities.first.inspectorName}');
        print(
            'PMSA Controller: First parsed activity inspectorId: ${pmsActivities.first.inspectorId}');
      }
      activities.assignAll(pmsActivities);
      print('=== End PMSA Controller: Loading Activities ===');
    } catch (e) {
      print('PMSA Controller Error: $e');
      Loaders.errorSnackbar(
          title: "Error", message: "Failed to load PMS data: ${e.toString()}");
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

      // PMS activity filter
      bool matchesPmsActivity = filterPmsActivity.value.isEmpty ||
          _getPmsActivityText(activity.pmsActivity) == filterPmsActivity.value;

      return matchesSearch &&
          matchesRegion &&
          matchesFacilityStatus &&
          matchesLicenseStatus &&
          matchesPmsActivity;
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
    filterPmsActivity.value = '';
  }

  /// Validate and create a new PMSA activity.
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

      // Basic validations
      if (selectedFacilityStatus.value.isEmpty) {
        emptyFields.add("Facility Status");
      }

      // Only require these fields if facility is not closed
      if (selectedFacilityStatus.value != "Closed") {
        if (selectedCategoryOfFacility.value.isEmpty) {
          emptyFields.add("Category of Facility");
        }
        if (licensedStatus.value.isEmpty) {
          emptyFields.add("Licensed Status");
        }
        if (pmsaActivityCarriesOut.value.isEmpty) {
          emptyFields.add("PMSA Activity");
        }
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
        if (selectedQualification.value.isEmpty) {
          emptyFields.add("Qualifications");
        }
      }
      // Activity-specific validations (only if facility is not closed and activity is not "None")
      if (selectedFacilityStatus.value != "Closed" &&
          pmsaActivityCarriesOut.value != "None") {
        String activity = pmsaActivityCarriesOut.value;

        // Common fields for Sampling, Complaint investigation, and Follow-up on Recall
        if (activity == "Sampling" ||
            activity == "Complaint investigation" ||
            activity == "Follow-up on Recall") {
          if (productSampledNameController.text.isEmpty) {
            emptyFields.add("Name of Product");
          }
          if (numberOfSamplesCollectedController.text.isEmpty ||
              numberOfSamplesCollectedController.text == "0") {
            emptyFields.add("Quantity");
          }
          if (batchNumberOfSampleController.text.isEmpty) {
            emptyFields.add("Batch Number");
          }
        }

        // Specific fields for Complaint investigation
        if (activity == "Complaint investigation") {
          if (postMarketComplaintNotedController.text.isEmpty) {
            emptyFields.add("State any post market complaint noted");
          }
        }

        // Specific fields for Follow-up on Recall
        if (activity == "Follow-up on Recall") {
          if (commentOnOverallFollowUpController.text.isEmpty) {
            emptyFields.add("Comment on Over all Follow up");
          }
        }

        // Specific field for Others
        if (activity == "Others") {
          if (specifyActivityController.text.isEmpty) {
            emptyFields.add("Specify Activity");
          }
        }
      }

      if (emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message:
              "Please fill all required fields: ${emptyFields.join(', ')}.",
        );
        return;
      }

      // Create a new PMS activity from the form inputs.
      var newActivity = PmsModel(
        id: 0, // Will be set by API
        inspectionDate: DateTime.parse(
            "${inspectionDateController.text} ${inspectionTimeController.text}"),
        inspectorName: inspectorNameController.text,
        inspectorId: inspectorIdController.text,
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        intRegion: RegionDistrictConstants.getRegionGuid(
            RegionDistrictConstants.getRegionForDistrict(
                selectedDistrict.value)),
        districtId: _getDistrictId(selectedDistrict.value),
        facilityName: facilityNameController.text,
        facilityStatus: _getFacilityStatus(selectedFacilityStatus.value),
        facilityPersonType: _getPersonType(personFoundAtFacility.value),
        personName: nameController.text,
        contact: contactController.text,
        qualifications: selectedQualification.value,
        qualificationId: selectedQualificationId.value,
        categoryOfpremises:
            _getCategoryOfPremises(selectedCategoryOfFacility.value),
        otherCategoryPremise:
            selectedCategoryOfFacility.value == "Other" ? "Other category" : "",
        licenseStatus: _getLicenseStatus(licensedStatus.value),
        licenseNo:
            licensedStatus.value == "Licensed" ? licenseNoController.text : "",
        licenseExpiryDate: licensedStatus.value == "Licensed"
            ? licenseExpiryDateController.text
            : "",
        unlicensed: licensedStatus.value == "Un-Licensed" ? 1 : 0,
        pmsActivity: _getPmsActivity(pmsaActivityCarriesOut.value),
        sampleProductName: productSampledNameController.text,
        sampleNo: int.tryParse(numberOfSamplesCollectedController.text) ?? 0,
        sampleBatch: batchNumberOfSampleController.text,
        followupComment: commentOnOverallFollowUpController.text,
        complaintProduct: postMarketComplaintNotedController.text.isNotEmpty
            ? postMarketComplaintNotedController.text
            : productComplaintInvestigatedController.text,
        otherActivity: specifyActivityController.text,
        previouslyLicensed: selectedFacilityStatus.value == "Closed"
            ? ""
            : selectedPreviouslyLicensed.value,
      );

      // Check connectivity status.
      bool online = await NetworkManager.instance.isconnected();
      var activityData = newActivity.toJson();

      if (online) {
        try {
          print('Sending PMS data: $activityData'); // Debug log
          await repository.postPmsData(activityData);
          activities.add(newActivity);
          Loaders.successSnackbar(
              title: "Success", message: "PMS activity added successfully...");
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
            message: "PMS activity saved locally. Will sync when online.");
      }
      // Clear form fields after submission.
      clearForm();
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: e.toString());
    }
  }

  void clearForm() {
    inspectionDateController.clear();
    inspectionTimeController.clear();
    inspectorNameController.clear();
    inspectorIdController.clear();
    licenseNoController.clear();
    licenseExpiryDateController.clear();
    // gpsLocationController remains auto-filled.
    facilityNameController.clear();
    personFoundAtFacility.value = '';
    nameController.clear();
    contactController.clear();
    qualificationsController.clear();
    selectedQualification.value = '';
    selectedQualificationId.value = null;
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    selectedCategoryOfFacility.value = '';
    licensedStatus.value = '';
    pmsaActivityCarriesOut.value = '';
    selectedCategoryOfDrugs.value = '';
    selectedCategoryOfProductSamples.value = '';
    productSampledNameController.clear();
    numberOfSamplesCollectedController.text = "0";
    batchNumberOfSampleController.clear();
    productBeingFollowedUpController.clear();
    commentOnOverallFollowUpController.clear();
    productComplaintInvestigatedController.clear();
    postMarketComplaintNotedController.clear();
    specifyActivityController.clear();

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
      case "Wholesale Pharmacy - Human":
        return 1;
      case "Wholesale Pharmacy - Vet":
        return 2;
      case "Retail Pharmacy - Human":
        return 3;
      case "Retail Pharmacy - Vet":
        return 4;
      case "Drug Shop":
        return 5;
      case "External Stores":
        return 6;
      case "Hospital":
        return 7;
      case "HCIV":
        return 8;
      case "HCIII":
        return 9;
      case "Clinic":
        return 10;
      case "Herbal Selling Outlet":
        return 11;
      case "Shift Market":
        return 12;
      case "Pharmaceutical/Medical Device Manufacturing Premise":
        return 13;
      case "Other":
      case "Others":
        return 14;
      default:
        return 3; // Default to Retail Pharmacy - Human
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

  int _getPmsActivity(String activity) {
    switch (activity) {
      case "Sampling":
        return 1;
      case "Follow-up on Recall":
        return 2;
      case "Complaint investigation":
        return 3;
      case "Others":
        return 4;
      case "None":
        return 5;
      default:
        return 5;
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

  String _getPmsActivityText(int activity) {
    switch (activity) {
      case 1:
        return "Sampling";
      case 2:
        return "Follow-up on Recall";
      case 3:
        return "Complaint investigation";
      case 4:
        return "Others";
      case 0:
        return "None";
      default:
        return "None";
    }
  }

  String _getRegionName(String guid) {
    return RegionDistrictConstants.getRegionName(guid);
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
}
