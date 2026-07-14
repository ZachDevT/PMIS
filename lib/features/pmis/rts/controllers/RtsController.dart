import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/rts/models/RtsModel.dart';
import 'package:pmis/data/repositories/RtsRepository/RtsRepository.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';

class RtsController extends GetxController {
  // List of RTS activities
  var activities = <RtsModel>[].obs;
  var filteredActivities = <RtsModel>[].obs;
  final repository = Get.find<RtsRepository>();

  // Search and filter variables
  var searchQuery = ''.obs;
  var filterRegion = ''.obs;
  var filterDistrict = ''.obs;

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

  // Section: RTS Specific Details
  final venueLocationController = TextEditingController();
  final numberOfParticipantsController = TextEditingController();
  final radioCompanyNameController = TextEditingController();
  final topicOfDiscussionController = TextEditingController();

  // GPS Location controller (auto-filled)
  final gpsLocationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
    // Defer activity loading to avoid blocking main thread during initialization
    Future.microtask(() => loadActivities());
  }

  void _initializeForm() {
    // Set default values
    inspectionDateController.text = DateTime.now().toString();
    inspectionTimeController.text = DateTime.now().toString();
    
    // Initialize with current location
    getCurrentLocation();

    // Auto-fill inspector name
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      inspectorNameController.text = authController.userDisplayName;
    }
  }

  /// Load activities from local storage or API
  Future<void> loadActivities() async {
    try {
      isLoading.value = true;
      var data = await repository.getRtsData();
      var rtsActivities = data.map((item) => RtsModel.fromJson(item)).toList();
      activities.assignAll(rtsActivities);
      filterActivities();
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: "Failed to load RTS activities: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update search query and filter activities
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterActivities();
  }

  /// Create new RTS activity
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
      if (inspectorNameController.text.isEmpty) emptyFields.add("Inspector Name");
      if (venueLocationController.text.isEmpty) emptyFields.add("Venue Location");
      if (topicOfDiscussionController.text.isEmpty) emptyFields.add("Topic of Discussion");

      if (emptyFields.isNotEmpty) {
        Loaders.errorSnackbar(
          title: "Error",
          message: "Please fill in the following fields: ${emptyFields.join(', ')}.",
        );
        return;
      }

      var newActivity = RtsModel(
        id: null, // Will be set by API
        inspectionDate: inspectionDateController.text,
        inspectorName: inspectorNameController.text,
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        region: selectedRegion.value,
        district: selectedDistrict.value,
        venueLocation: venueLocationController.text,
        topicOfDiscussion: topicOfDiscussionController.text,
        numberOfParticipants: int.tryParse(numberOfParticipantsController.text) ?? 0,
        radioCompanyName: radioCompanyNameController.text.isNotEmpty ? radioCompanyNameController.text : null,
      );

      bool online = await NetworkManager.instance.isconnected();
      var activityData = newActivity.toJson();
      
      if (online) {
        try {
          print('Sending RTS data: $activityData'); // Debug log
          await repository.postRtsData(activityData);
          activities.add(newActivity);
          Loaders.successSnackbar(
              title: "Success", message: "RTS activity added successfully...");
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
            message: "RTS activity saved locally. Will sync when online.");
      }
      
      // Clear the form fields after submission
      clearForm();
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: e.toString());
    }
  }

  /// Clear form fields
  void clearForm() {
    inspectionDateController.clear();
    inspectorNameController.clear();
    gpsLocationController.clear();
    venueLocationController.clear();
    topicOfDiscussionController.clear();
    numberOfParticipantsController.clear();
    radioCompanyNameController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
  
    _initializeForm();
  }

  /// Filter activities based on search and filter criteria
  void filterActivities() {
    // Get current user info
    final authController = Get.isRegistered<AuthController>() 
        ? Get.find<AuthController>() 
        : null;
    final isAdmin = authController?.isAdmin ?? false;
    final userDisplayName = authController?.userDisplayName ?? '';

    var filtered = activities.where((activity) {
      // Role-based filter: If not admin, only show activities created by this user
      // Match by inspectorName since RtsModel doesn't have inspectorId
      if (!isAdmin && userDisplayName.isNotEmpty) {
        if (activity.inspectorName.toLowerCase() != userDisplayName.toLowerCase()) {
          return false;
        }
      }

      bool matchesSearch = searchQuery.value.isEmpty ||
          activity.topicOfDiscussion.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          activity.inspectorName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          activity.venueLocation.toLowerCase().contains(searchQuery.value.toLowerCase());

      bool matchesRegion = filterRegion.value.isEmpty ||
          activity.region == filterRegion.value;

      bool matchesDistrict = filterDistrict.value.isEmpty ||
          activity.district == filterDistrict.value;

      return matchesSearch && matchesRegion && matchesDistrict;
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

  /// Submit RTS activity
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

      // Create RTS model
      final rtsActivity = RtsModel(
        inspectionDate: inspectionDateController.text,
        inspectorName: inspectorNameController.text,
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        region: selectedRegion.value,
        district: selectedDistrict.value,
        venueLocation: venueLocationController.text,
        topicOfDiscussion: topicOfDiscussionController.text,
        numberOfParticipants: int.tryParse(numberOfParticipantsController.text) ?? 0,
        radioCompanyName: radioCompanyNameController.text.isNotEmpty ? radioCompanyNameController.text : null,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      bool online = await NetworkManager.instance.isconnected();
      var activityData = rtsActivity.toJson();
      
      print('🔍 DEBUG: Network status: $online');
      print('🔍 DEBUG: Activity data to send: $activityData');
      
      if (online) {
        try {
          print('🚀 DEBUG: Attempting to send RTS data to API...');
          var result = await repository.postRtsData(activityData);
          print('✅ DEBUG: API response received: $result');
          
          activities.add(rtsActivity);
          Loaders.successSnackbar(
              title: "Success", message: "RTS activity sent to API successfully!");
          Navigator.pop(Get.context!); // Close on success
        } catch (e) {
          print('❌ DEBUG: API call failed: $e');
          // If online submission fails, save locally as fallback
          await repository.saveActivityLocally(activityData);
          activities.add(rtsActivity);
          Loaders.errorSnackbar(
              title: "Network Error", 
              message: "Failed to send to API. Saved locally for sync.");
          Navigator.pop(Get.context!); // Close on fallback success
        }
      } else {
        print('📱 DEBUG: Offline mode - saving locally');
        // For offline mode - save locally
        await repository.saveActivityLocally(activityData);
        activities.add(rtsActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message: "RTS activity saved locally. Will sync when online.");
        Navigator.pop(Get.context!); // Close on success
      }

      filterActivities();
      clearForm();
    } catch (e) {
      Loaders.errorSnackbar(title: "Error", message: "Failed to submit activity");
    } finally {
      isSubmitting.value = false;
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
