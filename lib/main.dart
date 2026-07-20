import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'app.dart';
import 'package:pmis/utils/config.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    // Initialize widgets bindings
    final WidgetsBinding widgetsBinding =
        WidgetsFlutterBinding.ensureInitialized();

    // Initialize Get Storage
    await GetStorage.init();

    // Preserve the splash screen until other items load
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Set preferred device orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Handle Flutter errors gracefully (including SocketException)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // Check if it's a network error - don't show to user
      if (details.exception.toString().contains('SocketException') ||
          details.exception.toString().contains('Failed host lookup') ||
          details.exception.toString().contains('No address associated') ||
          details.exception.toString().contains('NetworkException')) {
        print('Network error handled: ${details.exception}');
        return; // Silently handle network errors
      }
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      // Check if it's a network error - don't show to user
      if (error.toString().contains('SocketException') ||
          error.toString().contains('Failed host lookup') ||
          error.toString().contains('No address associated') ||
          error.toString().contains('NetworkException')) {
        print('Async network error handled: $error');
        return true; // Error handled
      }
      // For other errors, let Flutter handle them
      return false;
    };

    // Remove splash screen
    Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();

    // Ensure config defaults are set
    // Initialize debug flags if not present
    // Default: enableRealtime = true, debugLogging = false
    GetStorage box = GetStorage();
    if (box.read('enableRealtime') == null) box.write('enableRealtime', true);
    if (box.read('debugLogging') == null) box.write('debugLogging', false);

    runApp(const MyApp());
  }, (error, stack) {
    // Handle uncaught errors gracefully to avoid crashing the app
    // Log error (mask sensitive data if needed)
    if (AppConfig.debugLogging) {
      // Full logging in debug mode
      print('Uncaught error (zone): $error');
      print(stack);
    } else {
      print('Uncaught error (zone): ${error.toString()}');
    }
  });
}
