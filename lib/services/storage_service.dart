import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing local persistent key-value storage.
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> setString(String key, String value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<bool> remove(String key) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<bool> clear() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
