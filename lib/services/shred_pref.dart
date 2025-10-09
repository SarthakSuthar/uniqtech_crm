import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  /// Initialize preferences (call this once, e.g. in main())
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save integer
  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Get integer
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Save string
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get string
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Save boolean
  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get boolean
  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Remove a key
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all saved preferences
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
