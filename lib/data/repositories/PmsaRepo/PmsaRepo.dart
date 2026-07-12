import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/pms/PmsService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class PmsaRepository {
  final box = GetStorage();
  final PmsService _pmsService = PmsService();

  /// Fetch PMS activities from API.
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();

      if (!isOnline) {
        print('No internet connection, returning empty list');
        return [];
      }

      return await _pmsService.getPmsData();
    } on TimeoutException catch (e) {
      print('Timeout error fetching PMS activities: ${e.message}');
      return [];
    } on SocketException catch (e) {
      print('Network error fetching PMS activities: ${e.message}');
      return [];
    } on NetworkException catch (e) {
      print('Network exception: ${e.message}');
      return [];
    } catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('Future not completed')) {
        print('Timeout error detected: ${e.toString()}');
        return [];
      }
      print('Error fetching PMS activities: $e');
      return [];
    }
  }

  /// Get PMS data from the API (alias for fetchActivities).
  Future<List<Map<String, dynamic>>> getPmsData() async {
    return await fetchActivities();
  }

  /// Save a PMSA activity locally when offline.
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('pmsa_activities') ?? [];
      storedActivities.add(activityData);
      await box.write('pmsa_activities', storedActivities);
      print('PMS activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving PMSA activity locally: $e');
    }
  }

  /// Sync locally stored PMS activities to API when online.
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('pmsa_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _pmsService.postPmsData(activityData);
            print('PMS activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync PMS activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }

        // Remove successfully synced activities, keep failed ones
        await box.write('pmsa_activities', failedSyncs);
      }

      return storedActivities.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error syncing local PMS activities: $e');
      return [];
    }
  }

  /// Post PMS data to the API.
  Future<void> postPmsData(Map<String, dynamic> pmsData) async {
    try {
      await _pmsService.postPmsData(pmsData);
      print('PMS Activity submitted successfully');
    } catch (e) {
      print('Error submitting PMS activity: $e');
      // Optionally save locally if network call fails.
      await saveActivityLocally(pmsData);
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities = box.read<List>('pmsa_activities') ?? [];
    return storedActivities.length;
  }
}
