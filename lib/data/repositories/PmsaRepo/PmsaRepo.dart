import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/services/pms/PmsService.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'dart:io';

class PmsaRepository {
  final box = GetStorage();
  final PmsService _pmsService = PmsService();

  List<Map<String, dynamic>> _localActivities() =>
      (box.read<List>('pmsa_activities') ?? [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

  static const _duplicateWindow = Duration(seconds: 30);

  String _fingerprint(Map<String, dynamic> activity) {
    final copy = Map<String, dynamic>.from(activity)
      ..remove('id')
      ..remove('_localId')
      ..remove('_queuedAt')
      ..remove('_submissionId');
    return jsonEncode(_sortForJson(copy));
  }

  dynamic _sortForJson(dynamic value) {
    if (value is Map) {
      final sorted = value.entries.toList()
        ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
      return <String, dynamic>{
        for (final entry in sorted)
          entry.key.toString(): _sortForJson(entry.value),
      };
    }
    if (value is List) return value.map(_sortForJson).toList();
    return value;
  }

  bool _isRecentDuplicate(List<Map<String, dynamic>> storedActivities,
      Map<String, dynamic> candidate) {
    final candidateFingerprint = _fingerprint(candidate);
    final now = DateTime.now();
    return storedActivities.any((stored) {
      final queuedAt = DateTime.tryParse(stored['_queuedAt']?.toString() ?? '');
      return queuedAt != null &&
          now.difference(queuedAt).abs() <= _duplicateWindow &&
          _fingerprint(stored) == candidateFingerprint;
    });
  }

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

  /// Fetch PMS activities from API.
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    try {
      // Check connectivity before making API call
      final networkManager = Get.find<NetworkManager>();
      final isOnline = await networkManager.isconnected();

      if (!isOnline) {
        print('No internet connection, returning local PMSA data');
        return _mergeWithLocal(const []);
      }

      return _mergeWithLocal(await _pmsService.getPmsData());
    } on TimeoutException catch (e) {
      print('Timeout error fetching PMS activities: ${e.message}');
      return _mergeWithLocal(const []);
    } on SocketException catch (e) {
      print('Network error fetching PMS activities: ${e.message}');
      return _mergeWithLocal(const []);
    } on NetworkException catch (e) {
      print('Network exception: ${e.message}');
      return _mergeWithLocal(const []);
    } catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('Future not completed')) {
        print('Timeout error detected: ${e.toString()}');
        return _mergeWithLocal(const []);
      }
      print('Error fetching PMS activities: $e');
      return _mergeWithLocal(const []);
    }
  }

  /// Get PMS data from the API (alias for fetchActivities).
  Future<List<Map<String, dynamic>>> getPmsData() async {
    return await fetchActivities();
  }

  /// Save a PMSA activity locally when offline.
  Future<void> saveActivityLocally(Map<String, dynamic> activityData) async {
    try {
      final storedActivities = _localActivities();
      final localActivity = Map<String, dynamic>.from(activityData);
      if (_isRecentDuplicate(storedActivities, localActivity)) {
        print('Skipped duplicate PMS activity in local sync queue');
        return;
      }
      localActivity['_localId'] ??=
          'pmsa-${DateTime.now().microsecondsSinceEpoch}';
      localActivity['_submissionId'] ??= localActivity['_localId'];
      localActivity['_queuedAt'] ??= DateTime.now().toIso8601String();
      storedActivities.add(localActivity);
      await box.write('pmsa_activities', storedActivities);
      print('PMS activity saved locally: ${localActivity['_localId']}');
    } catch (e) {
      print('Error saving PMSA activity locally: $e');
    }
  }

  /// Sync locally stored PMS activities to API when online.
  Future<List<Map<String, dynamic>>> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('pmsa_activities') ?? [];
      List<Map<String, dynamic>> failedSyncs = [];
      List<Map<String, dynamic>> successfulSyncs = [];

      if (storedActivities.isNotEmpty) {
        for (var activityData in storedActivities) {
          try {
            await _pmsService.postPmsData(activityData);
            successfulSyncs.add(Map<String, dynamic>.from(activityData));
            print('PMS activity synced successfully: ${activityData['id']}');
          } catch (e) {
            print('Failed to sync PMS activity ${activityData['id']}: $e');
            failedSyncs.add(activityData);
          }
        }

        // Remove successfully synced activities, keep failed ones
        await box.write('pmsa_activities', failedSyncs);
      }

      return successfulSyncs;
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
      rethrow;
    }
  }

  /// Get count of locally stored offline activities
  int getOfflineActivitiesCount() {
    List storedActivities = box.read<List>('pmsa_activities') ?? [];
    return storedActivities.length;
  }
}
