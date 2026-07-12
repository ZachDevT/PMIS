import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/sensitizationmeeting/SensitizationMeetingService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class SensitizationMeetingRepository {
  final box = GetStorage();
  final SensitizationMeetingService _service = SensitizationMeetingService();

  /// Fetch Sensitization Meeting activities from API.
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();

      if (!isOnline) {
        print('No internet connection, returning empty list');
        return [];
      }

      return await _service.getSensitizationMeetingData();
    } on TimeoutException catch (e) {
      print(
          'Timeout error fetching Sensitization Meeting activities: ${e.message}');
      return [];
    } on SocketException catch (e) {
      print(
          'Network error fetching Sensitization Meeting activities: ${e.message}');
      return [];
    } on NetworkException catch (e) {
      print('Network exception: ${e.message}');
      return [];
    } on ServerException catch (e) {
      // API endpoint may not be fully implemented - return empty list gracefully
      print(
          'Server exception (API may not be fully implemented): ${e.message}');
      return [];
    } catch (e) {
      // Handle any other errors, including TimeoutException or ServerException that might not be caught above
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('Future not completed')) {
        print('Timeout error detected: ${e.toString()}');
        return [];
      }
      if (e.toString().contains('ServerException') ||
          e.toString().contains('Server returned error') ||
          e.toString().contains('statusCode')) {
        print(
            'Server error detected (API may not be fully implemented): ${e.toString()}');
        return [];
      }
      print('Error fetching Sensitization Meeting activities: $e');
      return [];
    }
  }

  /// Get Sensitization Meeting data from the API
  Future<List<Map<String, dynamic>>> getSensitizationMeetingData() async {
    return await fetchActivities();
  }

  /// Save a Sensitization Meeting activity locally when offline.
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities =
          box.read<List>('sensitization_meeting_activities') ?? [];
      storedActivities.add(activityData);
      await box.write('sensitization_meeting_activities', storedActivities);
      print(
          'Sensitization Meeting activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving Sensitization Meeting activity locally: $e');
    }
  }

  /// Sync locally stored Sensitization Meeting activities to API when online.
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities =
          box.read<List>('sensitization_meeting_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postSensitizationMeetingData(activityData);
            print(
                'Sensitization Meeting activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print(
                'Failed to sync Sensitization Meeting activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }

        // Remove successfully synced activities, keep failed ones
        await box.write('sensitization_meeting_activities', failedSyncs);
      }

      return storedActivities.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error syncing local Sensitization Meeting activities: $e');
      return [];
    }
  }

  /// Post Sensitization Meeting data to the API.
  Future<void> postSensitizationMeetingData(
      Map<String, dynamic> meetingData) async {
    try {
      await _service.postSensitizationMeetingData(meetingData);
      print('Sensitization Meeting Activity submitted successfully');
    } catch (e) {
      print('Error submitting Sensitization Meeting activity: $e');
      // Save locally if network call fails
      await saveActivityLocally(meetingData);
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities =
        box.read<List>('sensitization_meeting_activities') ?? [];
    return storedActivities.length;
  }
}
