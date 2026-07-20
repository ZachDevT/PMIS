import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/SensitizationMeetingRepository/SensitizationMeetingRepository.dart';
import 'package:pmis/features/pmis/sensitizationmeeting/models/SensitizationMeetingModel.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:pmis/features/pmis/location/controllers/LocationController.dart'
    as pmis_location;
import 'package:geolocator/geolocator.dart';
import 'package:pmis/features/authentification/controllers/login/authcontroller.dart';

class SensitizationMeetingController extends GetxController {
  var activities = <SensitizationMeetingActivity>[].obs;
  var filteredActivities = <SensitizationMeetingActivity>[].obs;
  final repository = Get.find<SensitizationMeetingRepository>();

  // Search and filter variables
  var searchQuery = ''.obs;
  var filterRegion = ''.obs;

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final inspectionDateController = TextEditingController();
  final inspectorNameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final venueLocationController = TextEditingController();
  final topicOfDiscussionController = TextEditingController();
  final numberOfParticipantsController = TextEditingController();

  // Dropdown Values
  var selectedRegion = ''.obs;
  var selectedDistrict = ''.obs;

  // Location variables
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var isGettingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Defer activity loading to avoid blocking main thread during initialization
    Future.microtask(() => loadActivities());
    getCurrentLocation();
    // Set current date
    _setCurrentDateTime();

    // Auto-fill inspector name
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      inspectorNameController.text = authController.userDisplayName;
    }

    // Initialize filtered activities
    ever(activities, (_) => filterActivities());
    ever(searchQuery, (_) => filterActivities());
    ever(filterRegion, (_) => filterActivities());
  }

  Future<void> loadActivities() async {
    try {
      var data = await repository.getSensitizationMeetingData();
      var meetingActivities = data
          .map((item) => SensitizationMeetingActivity.fromJson(item))
          .toList();
      activities.assignAll(meetingActivities);
    } catch (e) {
      print('SensitizationMeeting Controller Error: $e');
      Loaders.errorSnackbar(
          title: "Error",
          message: "Failed to load meeting data: ${e.toString()}");
    }
  }

  void filterActivities() {
    // Get current user info
    final authController =
        Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    final isAdmin = authController?.isAdmin ?? false;
    final userDisplayName = authController?.userDisplayName ?? '';

    var filtered = activities.where((activity) {
      // Role-based filter: If not admin, only show activities created by this user
      // Match by inspectorName since SensitizationMeetingModel doesn't have inspectorId
      if (!isAdmin && userDisplayName.isNotEmpty) {
        if (activity.inspectorName.toLowerCase() !=
            userDisplayName.toLowerCase()) {
          return false;
        }
      }

      bool matchesSearch = searchQuery.value.isEmpty ||
          activity.inspectorName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          activity.venueLocation
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          activity.topicOfDiscussion
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      bool matchesRegion =
          filterRegion.value.isEmpty || activity.region == filterRegion.value;

      return matchesSearch && matchesRegion;
    }).toList();

    filtered.sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));
    filteredActivities.assignAll(filtered);
  }

  Future<void> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Loaders.warningSnackbar(
            title: "Location Service", message: "Location service is disabled");
        isGettingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Loaders.warningSnackbar(
              title: "Permission Denied",
              message: "Location permission is denied");
          isGettingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Loaders.warningSnackbar(
            title: "Permission Required",
            message: "Location permission is permanently denied");
        isGettingLocation.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;
      latitudeController.text = position.latitude.toStringAsFixed(2);
      longitudeController.text = position.longitude.toStringAsFixed(2);
    } catch (e) {
      print('Error getting location: $e');
      Loaders.errorSnackbar(
          title: "Location Error", message: "Failed to get location");
    } finally {
      isGettingLocation.value = false;
    }
  }

  Future<void> createActivity(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      Loaders.errorSnackbar(
        title: "Incomplete Form",
        message: "Please fill in all the required fields.",
      );
      return;
    }

    try {
      DateTime inspectionDate;
      try {
        final dateTimeParts = inspectionDateController.text.split(',');
        final dateParts = dateTimeParts[0].trim().split('/');
        final timeParts = dateTimeParts.length > 1
            ? dateTimeParts[1].trim().split(':')
            : const <String>[];
        final secondParts =
            timeParts.length > 2 ? timeParts[2].split('.') : const <String>[];
        inspectionDate = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
          timeParts.isNotEmpty ? int.parse(timeParts[0]) : 0,
          timeParts.length > 1 ? int.parse(timeParts[1]) : 0,
          secondParts.isNotEmpty ? int.parse(secondParts[0]) : 0,
          secondParts.length > 1 ? int.parse(secondParts[1]) : 0,
        );
      } catch (e) {
        // Fallback to current date if parsing fails
        inspectionDate = DateTime.now();
      }

      final newActivity = SensitizationMeetingActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        inspectionDate: inspectionDate,
        inspectorName: inspectorNameController.text.trim(),
        latitude: double.tryParse(latitudeController.text) ?? 0.0,
        longitude: double.tryParse(longitudeController.text) ?? 0.0,
        region: selectedRegion.value,
        district: selectedDistrict.value,
        venueLocation: venueLocationController.text.trim(),
        topicOfDiscussion: topicOfDiscussionController.text.trim(),
        numberOfParticipants:
            int.tryParse(numberOfParticipantsController.text) ?? 0,
      );

      bool online = await NetworkManager.instance.isconnected();

      if (online) {
        var apiData = newActivity.toApiJson();
        var localData = newActivity.toJson();
        try {
          await repository.postSensitizationMeetingData(apiData);
          activities.add(newActivity);
          Loaders.successSnackbar(
              title: "Success", message: "Meeting recorded successfully...");
        } catch (e) {
          // Any exception means API call failed - save locally and continue
          await repository.saveActivityLocally(localData);
          activities.add(newActivity);
          // Check if it's a 404 (endpoint not implemented)
          if (e.toString().contains('404') ||
              e.toString().contains('endpoint not found')) {
            Loaders.successSnackbar(
                title: "Saved Locally",
                message:
                    "API endpoint not available. Data saved locally for sync.");
          } else {
            Loaders.warningSnackbar(
                title: "Saved Locally",
                message: "Failed to send online. Saved locally for sync.");
          }
        }
      } else {
        var localData = newActivity.toJson();
        await repository.saveActivityLocally(localData);
        activities.add(newActivity);
        Loaders.successSnackbar(
            title: "Offline",
            message: "Meeting saved locally. Will sync when online.");
      }

      clearForm();
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = "Failed to create meeting record";
      if (e.toString().contains("ValidationException")) {
        errorMessage = "Please check all required fields are filled correctly";
      } else if (e.toString().contains("NetworkException")) {
        errorMessage = "Network error. Please check your connection";
      } else if (e.toString().contains("AuthException")) {
        errorMessage = "Authentication required. Please login again";
      } else if (e.toString().contains("ServerException")) {
        // Check if it's a 404 (endpoint not implemented)
        if (e.toString().contains('404') ||
            e.toString().contains('endpoint not found')) {
          errorMessage =
              "API endpoint not available. Data will be saved locally.";
        } else {
          errorMessage = "Server error. Please try again later";
        }
      }
      Loaders.errorSnackbar(title: "Error", message: errorMessage);
    }
  }

  void clearForm() {
    _setCurrentDateTime();
    inspectorNameController.clear();
    latitudeController.clear();
    longitudeController.clear();
    venueLocationController.clear();
    topicOfDiscussionController.clear();
    numberOfParticipantsController.clear();
    selectedRegion.value = '';
    selectedDistrict.value = '';
    currentLatitude.value = 0.0;
    currentLongitude.value = 0.0;
  }

  void _setCurrentDateTime() {
    final now = DateTime.now();
    inspectionDateController.text =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}, '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
  }

  String getRegionName(int regionIndex) {
    if (regionIndex >= 0 &&
        regionIndex < RegionDistrictConstants.regions.length) {
      return RegionDistrictConstants.regions[regionIndex];
    }
    return '';
  }

  List<String> getDistrictsForRegion(String regionName) {
    if (Get.isRegistered<pmis_location.LocationController>()) {
      return pmis_location.LocationController.instance
          .getDistrictsForRegion(regionName);
    }
    return RegionDistrictConstants.districts;
  }

  void clearFilters() {
    filterRegion.value = '';
  }

  @override
  void onClose() {
    inspectionDateController.dispose();
    inspectorNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    venueLocationController.dispose();
    topicOfDiscussionController.dispose();
    numberOfParticipantsController.dispose();
    super.onClose();
  }
}
