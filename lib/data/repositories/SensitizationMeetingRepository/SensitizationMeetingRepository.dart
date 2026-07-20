import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/sensitizationmeeting/SensitizationMeetingService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class SensitizationMeetingRepository {
  final box = GetStorage();
  final SensitizationMeetingService _service = SensitizationMeetingService();

  List<Map<String, dynamic>> _localActivities() =>
      (box.read<List>('sensitization_meeting_activities') ?? [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

  List<Map<String, dynamic>> _mergeWithLocal(
      List<Map<String, dynamic>> remoteActivities) {
    final merged = <String, Map<String, dynamic>>{};
    for (final item in remoteActivities) {
      merged['server:${item['id']}'] = item;
    }
    for (final item in _localActivities()) {
      final localId = item['_localId'] ?? item['id'];
      merged['local:$localId'] = item;
    }
    final activities = merged.values.toList();
    activities.sort((a, b) => _inspectionDate(b).compareTo(_inspectionDate(a)));
    return activities;
  }

  DateTime _inspectionDate(Map<String, dynamic> item) =>
      DateTime.tryParse((item['inspectionDate'] ?? item['InspectionDate'] ?? '')
          .toString()) ??
      DateTime.fromMillisecondsSinceEpoch(0);

  /// Fetch Sensitization Meeting activities from API.
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();

      if (!isOnline) {
        print('No internet connection, returning local data');
        return _mergeWithLocal(const []);
      }

      List<Map<String, dynamic>> remoteData =
          await _service.getSensitizationMeetingData();
      return _mergeWithLocal(remoteData);
    } on TimeoutException catch (e) {
      print(
          'Timeout error fetching Sensitization Meeting activities: ${e.message}');
      return _mergeWithLocal(const []);
    } on SocketException catch (e) {
      print(
          'Network error fetching Sensitization Meeting activities: ${e.message}');
      return _mergeWithLocal(const []);
    } on NetworkException catch (e) {
      print('Network exception: ${e.message}');
      return _mergeWithLocal(const []);
    } on ServerException catch (e) {
      // API endpoint may not be fully implemented - return empty list gracefully
      print(
          'Server exception (API may not be fully implemented): ${e.message}');
      return _mergeWithLocal(const []);
    } catch (e) {
      // Handle any other errors, including TimeoutException or ServerException that might not be caught above
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('Future not completed')) {
        print('Timeout error detected: ${e.toString()}');
        return _mergeWithLocal(const []);
      }
      if (e.toString().contains('ServerException') ||
          e.toString().contains('Server returned error') ||
          e.toString().contains('statusCode')) {
        print(
            'Server error detected (API may not be fully implemented): ${e.toString()}');
        return _mergeWithLocal(const []);
      }
      print('Error fetching Sensitization Meeting activities: $e');
      return _mergeWithLocal(const []);
    }
  }

  /// Get Sensitization Meeting data from the API
  Future<List<Map<String, dynamic>>> getSensitizationMeetingData() async {
    List<Map<String, dynamic>> onlineData = [];
    try {
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();
      if (isOnline) {
        onlineData = await _service.getSensitizationMeetingData();
      }
    } catch (e) {
      print('Error fetching Sensitization Meeting activities: $e');
    }

    return _mergeWithLocal(onlineData);
  }

  /// Save a Sensitization Meeting activity locally when offline.
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      final storedActivities = _localActivities();
      final localActivity = Map<String, dynamic>.from(activityData);
      localActivity['_localId'] ??=
          'sensitization-${DateTime.now().microsecondsSinceEpoch}';
      storedActivities.add(localActivity);
      await box.write('sensitization_meeting_activities', storedActivities);
      print(
          'Sensitization Meeting activity saved locally: ${localActivity['_localId']}');
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
      List<Map<String, dynamic>> successfulSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postSensitizationMeetingData(activityData);
            successfulSyncs.add(Map<String, dynamic>.from(activityData));
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

      return successfulSyncs;
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
