import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pmis/utils/helpers/sync_manager.dart';
import 'package:pmis/utils/helpers/networkmanager.dart';

class AppInitController extends GetxController with WidgetsBindingObserver {
  static AppInitController get instance => Get.find();

  final RxBool _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void _initializeApp() async {
    try {
      // Request location permission on launch
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }
      } catch (e) {
        print('Location permission request on launch failed: $e');
      }

      // Wait for bindings to be ready
      await Future.delayed(const Duration(milliseconds: 100));

      // Initialize SyncManager AFTER first frame so Overlay/Navigator are available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final syncManager = Get.find<SyncManager>();
          syncManager.initialize();
        } catch (e) {
          // If initialization fails here, retry shortly after
          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              final syncManager = Get.find<SyncManager>();
              syncManager.initialize();
            } catch (_) {}
          });
        }
      });

      // Initialize NetworkManager for connectivity monitoring
      if (!Get.isRegistered<NetworkManager>()) {
        Get.put(NetworkManager());
      }
      Get.find<NetworkManager>();

      // Start automatic sync checking
      _startAutomaticSync();

      _isInitialized.value = true;
      print('✅ App initialization completed - Auto sync enabled');
    } catch (e) {
      print('❌ App initialization error: $e');
      // Retry initialization after a delay
      Future.delayed(const Duration(seconds: 2), () {
        _initializeApp();
      });
    }
  }

  void _startAutomaticSync() {
    // Check if there are any pending items and sync if online
    _performBackgroundSync();

    // Set up periodic sync check every 30 seconds when app is active
    Future.delayed(const Duration(seconds: 30), () {
      if (_isInitialized.value) {
        _performBackgroundSync();
        _startAutomaticSync(); // Recursive call for continuous monitoring
      }
    });
  }

  void _performBackgroundSync() async {
    try {
      final syncManager = Get.find<SyncManager>();
      final networkManager = Get.find<NetworkManager>();

      // Queue contents can change after SyncManager initialization.
      syncManager.refreshPendingCount();

      // Check if online and has pending items
      bool isOnline = await networkManager.isconnected();
      final pendingCount = syncManager.totalPendingItems;

      if (isOnline && pendingCount > 0 && !syncManager.isSyncing) {
        print('🔄 Auto-syncing $pendingCount offline items...');
        await syncManager.performSync(showProgress: false); // Silent sync
      }
    } catch (e) {
      print('❌ Background sync error: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // When app comes back to foreground, try to sync any pending data
      if (_isInitialized.value) {
        _performBackgroundSync();
      }
    }
  }

  /// Manual trigger for sync (can be called from anywhere in the app)
  Future<void> triggerSync() async {
    if (_isInitialized.value) {
      try {
        final syncManager = Get.find<SyncManager>();
        await syncManager.performSync();
      } catch (e) {
        print('❌ Manual sync trigger error: $e');
      }
    }
  }
}
