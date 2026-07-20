import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/gpp/GppService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class GppRepository {
  final GppService _service = Get.find<GppService>();
  final box = GetStorage();

  /// Fetch GPP data from the API
  Future<List<Map<String, dynamic>>> getGppData() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();

      if (!isOnline) {
        print('No internet connection, returning local data');
        List storedActivities = box.read<List>('gpp_activities') ?? [];
        return storedActivities
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      // Try to fetch from API
      List<Map<String, dynamic>> onlineData = [];
      try {
        onlineData = await _service.getGppData();
      } catch (e) {
        print('Service fetch error: $e');
      }

      // Merge with local unsynced activities
      List storedActivities = box.read<List>('gpp_activities') ?? [];

      final Map<String, Map<String, dynamic>> mergedMap = {};
      for (var item in onlineData) {
        if (item['id'] != null) {
          mergedMap[item['id'].toString()] = item;
        }
      }
      for (var item in storedActivities) {
        final local = Map<String, dynamic>.from(item);
        local['_localId'] ??= 'gpp-${DateTime.now().microsecondsSinceEpoch}';
        mergedMap['local:${local['_localId']}'] = local;
      }

      return mergedMap.values.toList();
    } on TimeoutException catch (e) {
      print('Timeout error fetching GPP data: ${e.message}');
      return [];
    } on SocketException catch (e) {
      print('Network error fetching GPP data: ${e.message}');
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
      print('Error fetching GPP data: $e');
      return [];
    }
  }

  /// Post GPP data to the API
  Future<Map<String, dynamic>> postGppData(Map<String, dynamic> gppData) {
    return _service.postGppData(gppData);
  }

  /// Save a GPP activity locally when offline
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('gpp_activities') ?? [];
      final local = Map<String, dynamic>.from(activityData);
      local['_localId'] ??= 'gpp-${DateTime.now().microsecondsSinceEpoch}';
      storedActivities.add(local);
      await box.write('gpp_activities', storedActivities);
      print('GPP activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving GPP activity locally: $e');
    }
  }

  /// Sync locally stored GPP activities to API when online
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('gpp_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      List<Map<String, dynamic>> successfulSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postGppData(activityData);
            successfulSyncs.add(Map<String, dynamic>.from(activityData));
            print('GPP activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync GPP activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }

        // Remove successfully synced activities, keep failed ones
        await box.write('gpp_activities', failedSyncs);
      }

      return successfulSyncs;
    } catch (e) {
      print('Error syncing local GPP activities: $e');
      return [];
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities = box.read<List>('gpp_activities') ?? [];
    return storedActivities.length;
  }
}
