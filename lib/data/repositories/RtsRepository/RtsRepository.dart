import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/rts/RtsService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';
import 'dart:math';

class RtsRepository {
  static final _random = Random();

  static String _newLocalId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 32)}';
  final RtsService _service = Get.find<RtsService>();
  final box = GetStorage();

  /// Fetch RTS data from the API
  Future<List<Map<String, dynamic>>> getRtsData() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();

      if (!isOnline) {
        print('No internet connection, returning local data');
        List storedActivities = box.read<List>('rts_activities') ?? [];
        return storedActivities
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      List<Map<String, dynamic>> onlineData = [];
      try {
        onlineData = await _service.getRtsData();
      } catch (e) {
        print('Service fetch error: $e');
      }

      // Merge with local unsynced activities
      List storedActivities = box.read<List>('rts_activities') ?? [];

      final Map<String, Map<String, dynamic>> mergedMap = {};
      for (var item in onlineData) {
        if (item['id'] != null) {
          // Mark API records as synced
          final syncedItem = Map<String, dynamic>.from(item);
          syncedItem['isSynced'] = true;
          mergedMap[item['id'].toString()] = syncedItem;
        }
      }
      for (var item in storedActivities) {
        final localItem = Map<String, dynamic>.from(item);
        final hasServerId = localItem['id'] != null;
        if (!hasServerId) localItem['_localId'] ??= _newLocalId();
        final key = hasServerId
            ? 'server:${localItem['id']}'
            : 'local:${localItem['_localId']}';
        mergedMap[key] = localItem;
      }

      return mergedMap.values.toList();
    } on TimeoutException catch (e) {
      print('Timeout error fetching RTS data: ${e.message}');
      return [];
    } on SocketException catch (e) {
      print('Network error fetching RTS data: ${e.message}');
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
      print('Error fetching RTS data: $e');
      return [];
    }
  }

  /// Post RTS data to the API
  Future<Map<String, dynamic>> postRtsData(Map<String, dynamic> rtsData) {
    return _service.postRtsData(rtsData);
  }

  /// Save a RTS activity locally when offline
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      List storedActivities = box.read<List>('rts_activities') ?? [];
      final localActivity = Map<String, dynamic>.from(activityData);
      localActivity['_localId'] ??= _newLocalId();
      final String? incomingId = localActivity['id']?.toString();
      final String localId = localActivity['_localId'].toString();

      if (incomingId != null && incomingId.isNotEmpty) {
        // Update existing record if id matches, otherwise append
        final idx = storedActivities.indexWhere(
          (e) => e['id']?.toString() == incomingId,
        );
        if (idx >= 0) {
          storedActivities[idx] = localActivity;
        } else {
          storedActivities.add(localActivity);
        }
      } else {
        final idx = storedActivities.indexWhere(
          (e) => e['_localId']?.toString() == localId,
        );
        if (idx >= 0) {
          storedActivities[idx] = localActivity;
        } else {
          storedActivities.add(localActivity);
        }
      }

      await box.write('rts_activities', storedActivities);
      print('RTS activity saved locally: $localId');
    } catch (e) {
      print('Error saving RTS activity locally: $e');
    }
  }

  /// Sync locally stored RTS activities to API when online
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('rts_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      List<Map<String, dynamic>> successfulSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _service.postRtsData(activityData);
            successfulSyncs.add(Map<String, dynamic>.from(activityData));
            print('RTS activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync RTS activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }

        // Remove successfully synced activities, keep failed ones
        await box.write('rts_activities', failedSyncs);
      }

      return successfulSyncs;
    } catch (e) {
      print('Error syncing local RTS activities: $e');
      return [];
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    try {
      List storedActivities = box.read<List>('rts_activities') ?? [];
      return storedActivities.length;
    } catch (e) {
      print('Error getting offline RTS activities count: $e');
      return 0;
    }
  }

  /// Add a new RTS activity directly when there is network
  Future<void> addActivity(Map<String, dynamic> activityData) async {
    try {
      await _service.postRtsData(activityData);
      print('RTS activity added successfully: ${activityData['id']}');
    } catch (e) {
      print('Error adding RTS activity: $e');
      // Save locally if network fails
      await saveActivityLocally(activityData);
    }
  }
}
