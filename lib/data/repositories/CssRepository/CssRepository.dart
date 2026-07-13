import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/css/CssService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class CssRepository extends GetxController {
  final CssService _service = Get.find<CssService>();
  final box = GetStorage();

  Future<List<Map<String, dynamic>>> getCssData() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();
      
      if (!isOnline) {
        print('No internet connection, returning local data');
        List storedActivities = box.read<List>('css_activities') ?? [];
        return storedActivities.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      
      // Try to fetch from API - wrap in additional try-catch for SocketException
      try {
        List<Map<String, dynamic>> onlineData = [];
      try {
        onlineData = await _service.getCssData();
      } catch(e) {
        print('Service fetch error: $e');
      }
      
      // Merge with local unsynced activities
      List storedActivities = box.read<List>('css_activities') ?? [];
      
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
      } on TimeoutException catch (e) {
        print('TimeoutException in CSS service: ${e.message}');
        return [];
      } on SocketException catch (e) {
        print('SocketException in CSS service: ${e.message}');
        return [];
      } on HttpException catch (e) {
        print('HttpException in CSS service: ${e.message}');
        return [];
      }
    } on TimeoutException catch (e) {
      // Handle timeout errors gracefully
      print('Timeout error fetching CSS data: ${e.message}');
      return [];
    } on SocketException catch (e) {
      // Handle network errors gracefully
      print('Network error fetching CSS data: ${e.message}');
      return [];
    } on NetworkException catch (e) {
      // Handle network exceptions gracefully
      print('Network exception: ${e.message}');
      return [];
    } catch (e) {
      // Handle any other errors gracefully, including TimeoutException that might not be caught above
      if (e.toString().contains('TimeoutException') || 
          e.toString().contains('Future not completed') ||
          e.toString().contains('SocketException') || 
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('No address associated')) {
        print('Error (detected in catch): ${e.toString()}');
        return [];
      }
      print('Error fetching CSS data: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> postCssData(Map<String, dynamic> data) async {
    return await _service.postCssData(data);
  }

  /// Save a CSS activity locally when offline
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('css_activities') ?? [];
      storedActivities.add(activityData);
      await box.write('css_activities', storedActivities);
      print('CSS activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving CSS activity locally: $e');
    }
  }

  /// Sync locally stored CSS activities to API when online
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('css_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      
      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postCssData(activityData);
            print('CSS activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync CSS activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }
        
        // Remove successfully synced activities, keep failed ones
        await box.write('css_activities', failedSyncs);
      }
      
      return storedActivities.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error syncing local CSS activities: $e');
      return [];
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities = box.read<List>('css_activities') ?? [];
    return storedActivities.length;
  }
}
