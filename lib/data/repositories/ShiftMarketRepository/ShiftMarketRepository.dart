import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/shiftmarket/ShiftMarketService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class ShiftMarketRepository {
  final ShiftMarketService _service = Get.find<ShiftMarketService>();
  final box = GetStorage();

  /// Fetch Shift Market data from the API
  Future<List<Map<String, dynamic>>> getShiftMarketData() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();

      if (!isOnline) {
        print('No internet connection, returning local data');
        List storedActivities = box.read<List>('shiftmarket_activities') ?? [];
        return storedActivities
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      List<Map<String, dynamic>> onlineData = [];
      try {
        onlineData = await _service.getShiftMarketData();
      } catch (e) {
        print('Service fetch error: $e');
      }

      // Merge with local unsynced activities
      List storedActivities = box.read<List>('shiftmarket_activities') ?? [];

      final Map<String, Map<String, dynamic>> mergedMap = {};
      for (var item in onlineData) {
        if (item['id'] != null) {
          final syncedItem = Map<String, dynamic>.from(item);
          syncedItem['isSynced'] = true;
          mergedMap[item['id'].toString()] = syncedItem;
        }
      }
      for (var item in storedActivities) {
        final local = Map<String, dynamic>.from(item);
        local['_localId'] ??=
            'shiftmarket-${DateTime.now().microsecondsSinceEpoch}';
        mergedMap['local:${local['_localId']}'] = local;
      }

      return mergedMap.values.toList();
    } on TimeoutException catch (e) {
      print('Timeout error fetching Shift Market data: ${e.message}');
      return [];
    } on SocketException catch (e) {
      print('Network error fetching Shift Market data: ${e.message}');
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
      print('Error fetching Shift Market data: $e');
      return [];
    }
  }

  /// Post Shift Market data to the API
  Future<Map<String, dynamic>> postShiftMarketData(
      Map<String, dynamic> shiftMarketData) {
    return _service.postShiftMarketData(shiftMarketData);
  }

  /// Save a Shift Market activity locally when offline
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('shiftmarket_activities') ?? [];
      final local = Map<String, dynamic>.from(activityData);
      local['_localId'] ??=
          'shiftmarket-${DateTime.now().microsecondsSinceEpoch}';
      storedActivities.add(local);
      await box.write('shiftmarket_activities', storedActivities);
      print('Shift Market activity saved locally: ${activityData['id']}');
    } catch (e) {
      print('Error saving Shift Market activity locally: $e');
    }
  }

  /// Sync locally stored Shift Market activities to API when online
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('shiftmarket_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      List<Map<String, dynamic>> successfulSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postShiftMarketData(activityData);
            successfulSyncs.add(Map<String, dynamic>.from(activityData));
            print(
                'Shift Market activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print(
                'Failed to sync Shift Market activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }

        // Remove successfully synced activities, keep failed ones
        await box.write('shiftmarket_activities', failedSyncs);
      }

      return successfulSyncs;
    } catch (e) {
      print('Error syncing local Shift Market activities: $e');
      return [];
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    try {
      List storedActivities = box.read<List>('shiftmarket_activities') ?? [];
      return storedActivities.length;
    } catch (e) {
      print('Error getting offline Shift Market activities count: $e');
      return 0;
    }
  }

  /// Add a new Shift Market activity directly when there is network
  Future<void> addActivity(Map<String, dynamic> activityData) async {
    try {
      await _service.postShiftMarketData(activityData);
      print('Shift Market activity added successfully: ${activityData['id']}');
    } catch (e) {
      print('Error adding Shift Market activity: $e');
      // Save locally if network fails
      await saveActivityLocally(activityData);
    }
  }
}
