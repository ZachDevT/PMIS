import 'package:get_storage/get_storage.dart';

class AppConfig {
  static final _box = GetStorage();

  /// Toggle realtime usage (useful for debugging or unstable networks)
  static bool get enableRealtime => _box.read<bool>('enableRealtime') ?? true;
  static set enableRealtime(bool value) => _box.write('enableRealtime', value);

  /// Toggle verbose debug logging
  static bool get debugLogging => _box.read<bool>('debugLogging') ?? false;
  static set debugLogging(bool value) => _box.write('debugLogging', value);
}
