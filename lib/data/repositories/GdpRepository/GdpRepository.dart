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
      if (item['id'] != null) {
        mergedMap[item['id'].toString()] = Map<String, dynamic>.from(item);
      }
    }
    
    return mergedMap.values.toList();
  }

  /// Save a GDP activity locally when offline.
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('gdp_activities') ?? [];
      storedActivities.add(activityData);
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
      
      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _gdpService.postGdpData(activityData);
            print('GDP activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync GDP activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }
        
        // Remove successfully synced activities, keep failed ones
        await box.write('gdp_activities', failedSyncs);
      }
      
      return storedActivities.map((e) => e as Map<String, dynamic>).toList();
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
      // Optionally save locally if network call fails.
      await saveActivityLocally(activityData);
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities = box.read<List>('gdp_activities') ?? [];
    return storedActivities.length;
  }
}
