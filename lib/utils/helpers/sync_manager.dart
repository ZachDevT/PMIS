import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:pmis/data/repositories/CssRepository/CssRepository.dart';
import 'package:pmis/data/repositories/GdpRepository/GdpRepository.dart';
import 'package:pmis/data/repositories/GppRepository/GppRepository.dart';
import 'package:pmis/data/repositories/PmsaRepo/PmsaRepo.dart';
import 'package:pmis/data/repositories/RtsRepository/RtsRepository.dart';
import 'package:pmis/data/repositories/ShiftMarketRepository/ShiftMarketRepository.dart';
import 'package:pmis/data/repositories/EnforcementRepository/EnforcementRepository.dart';
import 'package:pmis/data/repositories/SensitizationMeetingRepository/SensitizationMeetingRepository.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/enforcement/controllers/EnforcementController.dart';
import 'package:pmis/features/pmis/gdp/controllers/GdpController.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:pmis/features/pmis/rts/controllers/RtsController.dart';
import 'package:pmis/features/pmis/sensitizationmeeting/controllers/SensitizationMeetingController.dart';
import 'package:pmis/features/pmis/shiftmarket/controllers/ShiftMarketController.dart';
import 'package:pmis/utils/popups/loaders.dart';

class SyncManager extends GetxController {
  static SyncManager get instance => Get.find();

  // Use lazy getters instead of field initializers to avoid null errors
  CssRepository get _cssRepo => Get.find<CssRepository>();
  GdpRepository get _gdpRepo => Get.find<GdpRepository>();
  GppRepository get _gppRepo => Get.find<GppRepository>();
  PmsaRepository get _pmsaRepo => Get.find<PmsaRepository>();
  RtsRepository get _rtsRepo => Get.find<RtsRepository>();
  ShiftMarketRepository get _shiftMarketRepo =>
      Get.find<ShiftMarketRepository>();
  EnforcementRepository get _enforcementRepo =>
      Get.find<EnforcementRepository>();
  SensitizationMeetingRepository get _sensitizationRepo =>
      Get.find<SensitizationMeetingRepository>();

  final RxBool _isSyncing = false.obs;
  final RxInt _totalPendingItems = 0.obs;
  bool _isInitialized = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  int _connectivityRetryAttempts = 0;
  static const int _maxRetryAttempts = 5;

  /// Get sync status
  bool get isSyncing => _isSyncing.value;

  /// Get total pending items count
  int get totalPendingItems => _totalPendingItems.value;

  /// Check if SyncManager is already initialized
  bool get isInitialized => _isInitialized;

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// Initialize sync manager and listen for connectivity changes
  void initialize() {
    // Prevent multiple initializations
    if (_isInitialized) {
      print('⚠️ SyncManager already initialized, skipping...');
      return;
    }

    try {
      // Listen for connectivity changes
      _connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        try {
          final resolvedResult = _resolveConnectivityResult(results);
          if (resolvedResult != ConnectivityResult.none) {
            // Connection restored, trigger automatic sync with backoff
            print(
                '🌐 Internet connection restored - checking for pending data...');
            Future.microtask(() => _performSyncWithBackoff());
          }
        } catch (e) {
          print('Error handling connectivity change: $e');
        }
      });

      // Calculate initial pending count (defer to avoid blocking main thread)
      Future.microtask(refreshPendingCount);

      _isInitialized = true;
      print('✅ SyncManager initialized - Automatic sync enabled');
    } catch (e) {
      print('Error initializing SyncManager: $e');
      Future.microtask(refreshPendingCount);
      _isInitialized = false;
      Future.delayed(const Duration(seconds: 2), initialize);
    }
  }

  Future<void> _performSyncWithBackoff() async {
    _connectivityRetryAttempts = 0;
    while (_connectivityRetryAttempts < _maxRetryAttempts) {
      try {
        await performSync(showProgress: false, throwOnFailure: true);
        // Success - reset attempts and break
        _connectivityRetryAttempts = 0;
        break;
      } catch (e) {
        _connectivityRetryAttempts++;
        final backoffMs = (1000 * (1 << _connectivityRetryAttempts));
        print(
            'Auto-sync attempt $_connectivityRetryAttempts failed: $e. Retrying in ${backoffMs}ms');
        await Future.delayed(Duration(milliseconds: backoffMs));
      }
    }
  }

  ConnectivityResult _resolveConnectivityResult(
      List<ConnectivityResult> results) {
    if (results.isEmpty) return ConnectivityResult.none;
    if (results.any((item) => item != ConnectivityResult.none)) {
      return ConnectivityResult.wifi;
    }
    return ConnectivityResult.none;
  }

  /// Update the total count of pending sync items
  void refreshPendingCount() {
    try {
      final cssCount = _cssRepo.getOfflineActivitiesCount();
      final gppCount = _gppRepo.getOfflineActivitiesCount();

      // Get counts from repositories
      final gdpCount = _gdpRepo.getOfflineActivitiesCount();
      final pmsCount = _pmsaRepo.getOfflineActivitiesCount();
      final rtsCount = _rtsRepo.getOfflineActivitiesCount();
      final shiftMarketCount = _shiftMarketRepo.getOfflineActivitiesCount();
      final enforcementCount = _enforcementRepo.getOfflineActivitiesCount();
      final sensitizationCount = _sensitizationRepo.getOfflineActivitiesCount();

      _totalPendingItems.value = cssCount +
          gdpCount +
          gppCount +
          pmsCount +
          rtsCount +
          shiftMarketCount +
          enforcementCount +
          sensitizationCount;
    } catch (e) {
      print('Error updating pending count: $e');
    }
  }

  /// Perform synchronization for all modules
  Future<Map<String, int>> performSync({
    bool showProgress = true,
    bool throwOnFailure = false,
  }) async {
    if (_isSyncing.value) {
      if (showProgress) {
        Loaders.warningSnackbar(
          title: "Sync in Progress",
          message: "A synchronization is already running...",
        );
      }
      return {};
    }

    _isSyncing.value = true;

    if (showProgress) {
      Loaders.successSnackbar(
        title: "Sync Started",
        message: "Synchronizing offline data...",
      );
    }

    Map<String, int> syncResults = {};

    try {
      // Check connectivity
      final results = await Connectivity().checkConnectivity();
      if (_resolveConnectivityResult(results) == ConnectivityResult.none) {
        if (showProgress) {
          Loaders.errorSnackbar(
            title: "No Internet",
            message: "Please check your internet connection",
          );
        }
        if (throwOnFailure) {
          throw StateError('No network interface is available');
        }
        return {};
      }

      // Sync CSS activities
      try {
        final cssSynced = await _cssRepo.syncLocalActivities();
        syncResults['css'] = cssSynced.length;
        print('CSS sync completed: ${cssSynced.length} items');
      } catch (e) {
        print('CSS sync failed: $e');
        syncResults['css'] = 0;
      }

      // Sync GDP activities
      try {
        final gdpSynced = await _gdpRepo.syncLocalActivities();
        syncResults['gdp'] = gdpSynced.length;
        print('GDP sync completed: ${gdpSynced.length} items');
      } catch (e) {
        print('GDP sync failed: $e');
        syncResults['gdp'] = 0;
      }

      // Sync GPP activities
      try {
        final gppSynced = await _gppRepo.syncLocalActivities();
        syncResults['gpp'] = gppSynced.length;
        print('GPP sync completed: ${gppSynced.length} items');
      } catch (e) {
        print('GPP sync failed: $e');
        syncResults['gpp'] = 0;
      }

      // Sync PMS activities
      try {
        final pmsSynced = await _pmsaRepo.syncLocalActivities();
        syncResults['pms'] = pmsSynced.length;
        print('PMS sync completed: ${pmsSynced.length} items');
      } catch (e) {
        print('PMS sync failed: $e');
        syncResults['pms'] = 0;
      }

      // Sync RTS activities
      try {
        final rtsSynced = await _rtsRepo.syncLocalActivities();
        syncResults['rts'] = rtsSynced.length;
        print('RTS sync completed: ${rtsSynced.length} items');
      } catch (e) {
        print('RTS sync failed: $e');
        syncResults['rts'] = 0;
      }

      // Sync Shift Market activities
      try {
        final shiftMarketSynced = await _shiftMarketRepo.syncLocalActivities();
        syncResults['shiftmarket'] = shiftMarketSynced.length;
        print('Shift Market sync completed: ${shiftMarketSynced.length} items');
      } catch (e) {
        print('Shift Market sync failed: $e');
        syncResults['shiftmarket'] = 0;
      }

      // Sync Enforcement activities
      try {
        final enforcementSynced = await _enforcementRepo.syncLocalActivities();
        syncResults['enforcement'] = enforcementSynced.length;
        print('Enforcement sync completed: ${enforcementSynced.length} items');
      } catch (e) {
        print('Enforcement sync failed: $e');
        syncResults['enforcement'] = 0;
      }

      // Sync Sensitization Meeting activities
      try {
        final sensitizationSynced =
            await _sensitizationRepo.syncLocalActivities();
        syncResults['sensitization'] = sensitizationSynced.length;
        print(
            'Sensitization Meeting sync completed: ${sensitizationSynced.length} items');
      } catch (e) {
        print('Sensitization Meeting sync failed: $e');
        syncResults['sensitization'] = 0;
      }

      // Update pending count
      refreshPendingCount();

      if (_totalPendingItems.value > 0 && throwOnFailure) {
        throw StateError(
          '${_totalPendingItems.value} offline item(s) remain pending',
        );
      }

      // Reload controller data but don't block main thread — schedule non-blocking refresh
      Future.microtask(() async {
        try {
          await _reloadAllControllerData(nonBlocking: true);
        } catch (e) {
          print('Error reloading controllers after sync: $e');
        }
      });

      // Show success message
      if (showProgress) {
        final totalSynced =
            syncResults.values.fold(0, (sum, count) => sum + count);
        if (_totalPendingItems.value > 0) {
          Loaders.warningSnackbar(
            title: "Sync Incomplete",
            message:
                "$totalSynced synced; ${_totalPendingItems.value} still pending",
          );
        } else if (totalSynced > 0) {
          Loaders.successSnackbar(
            title: "Sync Complete",
            message: "Successfully synced $totalSynced offline activities",
          );
        } else {
          Loaders.successSnackbar(
            title: "Nothing to Sync",
            message: "No offline data found to sync",
          );
        }
      } else {
        // Truly silent sync - just log the result
        final totalSynced =
            syncResults.values.fold(0, (sum, count) => sum + count);
        if (totalSynced > 0) {
          print(
              '✅ Auto-sync completed: $totalSynced activities synced successfully');
        }
      }
    } catch (e) {
      print('Sync error: $e');
      if (showProgress) {
        Loaders.errorSnackbar(
          title: "Sync Failed",
          message: "Failed to synchronize data. Please try again.",
        );
      }
      if (throwOnFailure) rethrow;
    } finally {
      _isSyncing.value = false;
    }

    return syncResults;
  }

  /// Reload all controller data after sync to show synced records immediately
  Future<void> _reloadAllControllerData({bool nonBlocking = false}) async {
    print('🔄 Reloading all controller data after sync...');

    // Reload CSS controller if registered
    try {
      if (Get.isRegistered<CssController>()) {
        final controller = Get.find<CssController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print(' Reloaded CSS data');
            } catch (e) {
              print('Error reloading CSS data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print(' Reloaded CSS data');
        }
      }
    } catch (e) {
      print('CSS controller not registered or error reloading: $e');
    }

    // Reload GPP controller
    try {
      if (Get.isRegistered<GppController>()) {
        final controller = Get.find<GppController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print('✓ Reloaded GPP data');
            } catch (e) {
              print('Error reloading GPP data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print('✓ Reloaded GPP data');
        }
      }
    } catch (e) {
      print('GPP controller not registered or error reloading: $e');
    }

    // Reload GDP controller
    try {
      if (Get.isRegistered<GdpController>()) {
        final controller = Get.find<GdpController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print('✓ Reloaded GDP data');
            } catch (e) {
              print('Error reloading GDP data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print('✓ Reloaded GDP data');
        }
      }
    } catch (e) {
      print('GDP controller not registered or error reloading: $e');
    }

    // Reload PMSA controller
    try {
      if (Get.isRegistered<PmsaController>()) {
        final controller = Get.find<PmsaController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print('✓ Reloaded PMSA data');
            } catch (e) {
              print('Error reloading PMSA data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print('✓ Reloaded PMSA data');
        }
      }
    } catch (e) {
      print('PMSA controller not registered or error reloading: $e');
    }

    // Reload RTS controller
    try {
      if (Get.isRegistered<RtsController>()) {
        final controller = Get.find<RtsController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print('✓ Reloaded RTS data');
            } catch (e) {
              print('Error reloading RTS data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print('✓ Reloaded RTS data');
        }
      }
    } catch (e) {
      print('RTS controller not registered or error reloading: $e');
    }

    // Reload Shift Market controller
    try {
      if (Get.isRegistered<ShiftMarketController>()) {
        final controller = Get.find<ShiftMarketController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print('✓ Reloaded Shift Market data');
            } catch (e) {
              print('Error reloading Shift Market data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print('✓ Reloaded Shift Market data');
        }
      }
    } catch (e) {
      print('Shift Market controller not registered or error reloading: $e');
    }

    // Reload Enforcement controller
    try {
      if (Get.isRegistered<EnforcementController>()) {
        final controller = Get.find<EnforcementController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print('✓ Reloaded Enforcement data');
            } catch (e) {
              print('Error reloading Enforcement data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print('✓ Reloaded Enforcement data');
        }
      }
    } catch (e) {
      print('Enforcement controller not registered or error reloading: $e');
    }

    // Reload Sensitization Meeting controller
    try {
      if (Get.isRegistered<SensitizationMeetingController>()) {
        final controller = Get.find<SensitizationMeetingController>();
        if (nonBlocking) {
          Future.microtask(() async {
            try {
              await controller.loadActivities();
              print('✓ Reloaded Sensitization Meeting data');
            } catch (e) {
              print(
                  'Error reloading Sensitization Meeting data (non-blocking): $e');
            }
          });
        } else {
          await controller.loadActivities();
          print('✓ Reloaded Sensitization Meeting data');
        }
      }
    } catch (e) {
      print(
          'Sensitization Meeting controller not registered or error reloading: $e');
    }

    print('✅ Controller data reload complete');
  }

  /// Sync specific module only
  Future<int> syncModule(String moduleName) async {
    if (_isSyncing.value) return 0;

    _isSyncing.value = true;

    try {
      List<Map<String, dynamic>> syncedItems = [];

      switch (moduleName.toLowerCase()) {
        case 'css':
          syncedItems = await _cssRepo.syncLocalActivities();
          break;
        case 'gdp':
          syncedItems = await _gdpRepo.syncLocalActivities();
          break;
        case 'gpp':
          syncedItems = await _gppRepo.syncLocalActivities();
          break;
        case 'pms':
        case 'pmsa':
          syncedItems = await _pmsaRepo.syncLocalActivities();
          break;
        case 'rts':
          syncedItems = await _rtsRepo.syncLocalActivities();
          break;
        case 'shiftmarket':
        case 'sm':
          syncedItems = await _shiftMarketRepo.syncLocalActivities();
          break;
        case 'enforcement':
        case 'enf':
          syncedItems = await _enforcementRepo.syncLocalActivities();
          break;
        case 'sensitization':
        case 'sensitizationmeeting':
          syncedItems = await _sensitizationRepo.syncLocalActivities();
          break;
        default:
          print('Unknown module: $moduleName');
          return 0;
      }

      refreshPendingCount();

      Loaders.successSnackbar(
        title: "Module Sync Complete",
        message: "Synced ${syncedItems.length} $moduleName activities",
      );

      return syncedItems.length;
    } catch (e) {
      print('Module sync error: $e');
      Loaders.errorSnackbar(
        title: "Sync Failed",
        message: "Failed to sync $moduleName data",
      );
      return 0;
    } finally {
      _isSyncing.value = false;
    }
  }

  /// Get sync statistics
  Map<String, int> getSyncStats() {
    return {
      'css': _cssRepo.getOfflineActivitiesCount(),
      'gdp': _gdpRepo.getOfflineActivitiesCount(),
      'gpp': _gppRepo.getOfflineActivitiesCount(),
      'pms': _pmsaRepo.getOfflineActivitiesCount(),
      'rts': _rtsRepo.getOfflineActivitiesCount(),
      'shiftmarket': _shiftMarketRepo.getOfflineActivitiesCount(),
      'enforcement': _enforcementRepo.getOfflineActivitiesCount(),
      'sensitization': _sensitizationRepo.getOfflineActivitiesCount(),
      'total': _totalPendingItems.value,
    };
  }
}
