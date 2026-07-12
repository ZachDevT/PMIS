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
        print('No internet connection, returning empty list');
        return [];
      }
      
      // Try to fetch from API
      return await _service.getGppData();
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
      if (e.toString().contains('TimeoutException') || e.toString().contains('Future not completed')) {
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
      storedActivities.add(activityData);
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
      
      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postGppData(activityData);
            print('GPP activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync GPP activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }
        
        // Remove successfully synced activities, keep failed ones
        await box.write('gpp_activities', failedSyncs);
      }
      
      return storedActivities.map((e) => e as Map<String, dynamic>).toList();
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
