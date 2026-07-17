import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pmis/utils/popups/loaders.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();
  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> connectivitysubscription;

  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    connectivitysubscription = _connectivity.onConnectivityChanged
        .listen(_updateConnectionStatus);
  }

  // update the connection status
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final normalizedResult = _resolveConnectivityResult(results);
    _connectionStatus.value = normalizedResult;
    if (_connectionStatus.value == ConnectivityResult.none) {
      print('NetworkManager: Connection lost');
    }
  }

  ConnectivityResult _resolveConnectivityResult(List<ConnectivityResult> results) {
    if (results.isEmpty) return ConnectivityResult.none;
    if (results.any((item) => item != ConnectivityResult.none)) {
      return ConnectivityResult.wifi;
    }
    return ConnectivityResult.none;
  }

  // Check the internet connection status
  Future<bool> isconnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _resolveConnectivityResult(results) != ConnectivityResult.none;
    } on PlatformException catch (_) {
      return false;
    }
  }

  // on close

  @override
  void onClose() {
    super.onClose();
    connectivitysubscription.cancel();
  }
}
