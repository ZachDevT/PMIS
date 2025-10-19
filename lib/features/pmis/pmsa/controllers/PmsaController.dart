import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/PmsaRepo/PmsaRepo.dart';
import 'package:pmis/features/pmis/pmsa/models/PmsModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Section: Facility Category & Licensing
  var selectedCategoryOfFacility = ''.obs;
  var licensedStatus = ''.obs;
  final licenseNoController = TextEditingController();

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
  final specifyActivityController = TextEditingController();

  // Location variables
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var isGettingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
    getCurrentLocation(); // Get current location on init
    // Set current date/time
    inspectionDateController.text =
        DateTime.now().toLocal().toString().split(' ')[0];
    inspectionTimeController.text = TimeOfDay.now().format(Get.context!);
    
    // Initialize filtered activities
    ever(activities, (_) => filterActivities());
    ever(searchQuery, (_) => filterActivities());
    ever(filterRegion, (_) => filterActivities());
    ever(filterFacilityStatus, (_) => filterActivities());
    ever(filterLicenseStatus, (_) => filterActivities());
    ever(filterPmsActivity, (_) => filterActivities());
  }

  Future<void> loadActivities() async {
    try {
      var data = await repository.getPmsData();
      var pmsActivities =
          data.map((item) => PmsModel.fromJson(item)).toList();
      activities.assignAll(pmsActivities);
    } catch (e) {
      Loaders.errorSnackbar(
          title: "Error", message: "Failed to load PMS data: ${e.toString()}");
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
        if (selectedCategoryOfDrugs.value.isEmpty) {
          emptyFields.add("Category of Drugs");
        }
        if (selectedCategoryOfProductSamples.value.isEmpty) {
          emptyFields.add("Category of Product Samples");
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
        if (qualificationsController.text.isEmpty) {
          emptyFields.add("Qualifications");
        }
      }
      // Follow-up & complaint details are only required if facility is Open
      if (selectedFacilityStatus.value != "Closed") {
        if (productBeingFollowedUpController.text.isEmpty) {
          emptyFields.add("Product Being Followed Up");
        }
        if (commentOnOverallFollowUpController.text.isEmpty) {
          emptyFields.add("Comment on Overall Follow Up");
        }
        if (productComplaintInvestigatedController.text.isEmpty) {
          emptyFields.add("Product Complaint Investigated");
        }
        if (specifyActivityController.text.isEmpty) {
          emptyFields.add("Specify Activity");
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
        inspectionDate: DateTime.parse(inspectionDateController.text),
        inspectorName: inspectorNameController.text,
        inspectorId: "INSP001", // Default inspector ID
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        intRegion: _getRegionGuid(selectedRegion.value),
        districtId: _getDistrictId(selectedDistrict.value),
        facilityName: facilityNameController.text,
        facilityStatus: _getFacilityStatus(selectedFacilityStatus.value),
        facilityPersonType: _getPersonType(personFoundAtFacility.value),
        personName: nameController.text,
        contact: contactController.text,
        qualifications: qualificationsController.text,
        categoryOfpremises:
            _getCategoryOfPremises(selectedCategoryOfFacility.value),
        otherCategoryPremise: selectedCategoryOfFacility.value == "Other" ? "Other category" : "",
        licenseStatus: _getLicenseStatus(licensedStatus.value),
        licenseNo: licensedStatus.value == "Licensed" ? licenseNoController.text : "",
        unlicensed: licensedStatus.value == "Un-Licensed" ? 1 : 0,
        pmsActivity: _getPmsActivity(pmsaActivityCarriesOut.value),
        sampleProductName: productSampledNameController.text,
        sampleNo: int.tryParse(numberOfSamplesCollectedController.text) ?? 0,
        sampleBatch: batchNumberOfSampleController.text,
        followupComment: commentOnOverallFollowUpController.text,
        complaintProduct: productComplaintInvestigatedController.text,
        otherActivity: specifyActivityController.text,
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
    licenseNoController.clear();
    // gpsLocationController remains auto-filled.
    facilityNameController.clear();
    personFoundAtFacility.value = '';
    nameController.clear();
    contactController.clear();
    qualificationsController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    selectedFacilityStatus.value = '';
    selectedCategoryOfFacility.value = '';
    licensedStatus.value = '';
    pmsaActivityCarriesOut.value = '';
    selectedCategoryOfDrugs.value = '';
    selectedCategoryOfProductSamples.value = '';
    productSampledNameController.clear();
    numberOfSamplesCollectedController.clear();
    batchNumberOfSampleController.clear();
    productBeingFollowedUpController.clear();
    commentOnOverallFollowUpController.clear();
    productComplaintInvestigatedController.clear();
    specifyActivityController.clear();
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
      case "Retail Pharmacy":
        return 1;
      case "Drug Shop":
        return 2;
      case "Hospital":
        return 3;
      case "HCIV":
        return 4;
      case "HCIII":
        return 5;
      case "Clinic":
        return 6;
      default:
        return 1;
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
      case "Product Sampling":
        return 1;
      case "Follow-up":
        return 2;
      case "Complaint Investigation":
        return 3;
      case "Other":
        return 4;
      default:
        return 1;
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

  String _getPmsActivityText(int activity) {
    switch (activity) {
      case 1: return "Product Sampling";
      case 2: return "Follow-up";
      case 3: return "Complaint Investigation";
      case 4: return "Other";
      default: return "Product Sampling";
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
