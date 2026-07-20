import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/gdp/GdpService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class GdpRepository {
  final box = GetStorage();
  final GdpService _gdpService = GdpService();

  /// Fetch GDP activities from API.
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    List<Map<String, dynamic>> onlineData = [];
    try {
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();
      if (isOnline) {
        onlineData = await _gdpService.getGdpData();
      }
    } catch (e) {
      print('Error fetching GDP activities: $e');
    }

    List storedActivities = box.read<List>('gdp_activities') ?? [];

    final Map<String, Map<String, dynamic>> mergedMap = {};
    for (var item in onlineData) {
      if (item['id'] != null) {
        mergedMap[item['id'].toString()] = item;
      }
    }
    for (var item in storedActivities) {
      final local = Map<String, dynamic>.from(item);
      local['_localId'] ??= 'gdp-${DateTime.now().microsecondsSinceEpoch}';
      mergedMap['local:${local['_localId']}'] = local;
    }

    return mergedMap.values.toList();
  }

  /// Save a GDP activity locally when offline.
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('gdp_activities') ?? [];
      final local = Map<String, dynamic>.from(activityData);
      local['_localId'] ??= 'gdp-${DateTime.now().microsecondsSinceEpoch}';
      storedActivities.add(local);
      await box.write('gdp_activities', storedActivities);
      print('GDP activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving GDP activity locally: $e');
    }
  }

  /// Sync locally stored GDP activities to API when online.
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('gdp_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      List<Map<String, dynamic>> successfulSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _gdpService.postGdpData(activityData);
            successfulSyncs.add(Map<String, dynamic>.from(activityData));
            print('GDP activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync GDP activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }

        // Remove successfully synced activities, keep failed ones
        await box.write('gdp_activities', failedSyncs);
      }

      return successfulSyncs;
    } catch (e) {
      print('Error syncing local GDP activities: $e');
      return [];
    }
  }

  /// Add a new GDP activity directly when there is network.
  Future<void> addActivity(Map<String, dynamic> activityData) async {
    try {
      await _gdpService.postGdpData(activityData);
      print('GDP Activity added successfully');
    } catch (e) {
      print('Error adding GDP activity: $e');
      rethrow;
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities = box.read<List>('gdp_activities') ?? [];
    return storedActivities.length;
  }
}
