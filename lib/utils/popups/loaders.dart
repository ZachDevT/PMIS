import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:get/get.dart';

class Loaders {
  /// Hide any currently showing toast
  static void hideSnackbar() {
    // toastification toasts are auto-dismissible
  }

  /// Custom toast message
  static customToast({required String message}) {
    final context = _getContext();
    if (context != null) {
      toastification.show(
        context: context,
        title: Text(message),
        type: ToastificationType.info,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(12),
      );
    }
  }

  /// Warning snackbar
  static warningSnackbar({required String title, String message = ""}) {
    final context = _getContext();
    if (context != null) {
      toastification.show(
        context: context,
        title: Text(title),
        description: message.isNotEmpty ? Text(message) : null,
        type: ToastificationType.warning,
        style: ToastificationStyle.flatColored,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(12),
      );
    }
  }

  /// Success snackbar
  static successSnackbar(
      {required String title, String message = "", int duration = 5}) {
    final context = _getContext();
    if (context != null) {
      toastification.show(
        context: context,
        title: Text(title),
        description: message.isNotEmpty ? Text(message) : null,
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        alignment: Alignment.topCenter,
        autoCloseDuration: Duration(seconds: duration),
        borderRadius: BorderRadius.circular(12),
      );
    }
  }

  /// Error snackbar
  static errorSnackbar(
      {required String title, String message = "", int duration = 5}) {
    final context = _getContext();
    if (context != null) {
      toastification.show(
        context: context,
        title: Text(title),
        description: message.isNotEmpty ? Text(message) : null,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        alignment: Alignment.topCenter,
        autoCloseDuration: Duration(seconds: duration),
        borderRadius: BorderRadius.circular(12),
      );
    }
  }

  /// Get context safely - tries multiple methods
  static BuildContext? _getContext() {
    try {
      // Try GetX context first
      final getContext = Get.key.currentContext ?? Get.context;
      if (getContext != null && getContext.mounted) {
        return getContext;
      }
    } catch (e) {
      // If GetX context fails, try again after a microtask delay
      Future.microtask(() {
        try {
          final getContext = Get.key.currentContext ?? Get.context;
          if (getContext != null && getContext.mounted) {
            return getContext;
          }
        } catch (e) {
          // Ignore
        }
        return null;
      });
    }
    return null;
  }
}
