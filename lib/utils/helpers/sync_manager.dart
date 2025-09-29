import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/repositories/CssRepository/CssRepository.dart';
import 'package:pmis/data/repositories/GdpRepository/GdpRepository.dart';
import 'package:pmis/data/repositories/GppRepository/GppRepository.dart';
import 'package:pmis/data/repositories/PmsaRepo/PmsaRepo.dart';
import 'package:pmis/utils/popups/loaders.dart';

class SyncManager extends GetxController {
  static SyncManager get instance => Get.find();

  final CssRepository _cssRepo = Get.find<CssRepository>();
  final GdpRepository _gdpRepo = Get.find<GdpRepository>();
  final GppRepository _gppRepo = Get.find<GppRepository>();
  final PmsaRepository _pmsaRepo = Get.find<PmsaRepository>();

  final RxBool _isSyncing = false.obs;
  final RxInt _totalPendingItems = 0.obs;

  /// Get sync status
  bool get isSyncing => _isSyncing.value;

  /// Get total pending items count
  int get totalPendingItems => _totalPendingItems.value;

  /// Initialize sync manager and listen for connectivity changes
  void initialize() {
    // Listen for connectivity changes
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.first != ConnectivityResult.none) {
        // Connection restored, trigger automatic sync after a short delay
        print('🌐 Internet connection restored - checking for pending data...');
        Future.delayed(const Duration(seconds: 2), () async {
          await performSync(showProgress: true); // Show progress for connectivity restoration
        });
      }
    });

    // Calculate initial pending count
    _updatePendingCount();
    print('✅ SyncManager initialized - Automatic sync enabled');
  }

  /// Update the total count of pending sync items
  void _updatePendingCount() {
    try {
      final cssCount = _cssRepo.getOfflineActivitiesCount();
      final gppCount = _gppRepo.getOfflineActivitiesCount();

      // Get counts from repositories
      final gdpCount = _gdpRepo.getOfflineActivitiesCount();
      final pmsCount = _pmsaRepo.getOfflineActivitiesCount();

      _totalPendingItems.value = cssCount + gdpCount + gppCount + pmsCount;
    } catch (e) {
      print('Error updating pending count: $e');
    }
  }

  /// Perform synchronization for all modules
  Future<Map<String, int>> performSync({bool showProgress = true}) async {
    if (_isSyncing.value) {
      Loaders.warningSnackbar(
        title: "Already Syncing",
        message: "Synchronization is already in progress...",
      );
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
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity.first == ConnectivityResult.none) {
        Loaders.errorSnackbar(
          title: "No Internet",
          message: "Please check your internet connection",
        );
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

      // Update pending count
      _updatePendingCount();

      // Show success message
      if (showProgress) {
        final totalSynced =
            syncResults.values.fold(0, (sum, count) => sum + count);
        if (totalSynced > 0) {
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
        // Silent sync - but still show result
        final totalSynced =
            syncResults.values.fold(0, (sum, count) => sum + count);
        if (totalSynced > 0) {
          print(
              '✅ Auto-sync completed: $totalSynced activities synced successfully');
          Loaders.successSnackbar(
            title: "Auto-Sync Complete",
            message: "$totalSynced offline items synced successfully",
          );
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
    } finally {
      _isSyncing.value = false;
    }

    return syncResults;
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
        default:
          print('Unknown module: $moduleName');
          return 0;
      }

      _updatePendingCount();

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
      'total': _totalPendingItems.value,
    };
  }
}
