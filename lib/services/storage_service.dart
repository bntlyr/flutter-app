import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing local persistent key-value and secure storage.
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String keyJwtToken = 'jwt_access_token';
  static const String keyUserSession = 'user_session_data';
  static const String keyPublicKey = 'rsa_public_key';
  static const String keyApiBaseUrl = 'api_base_url';

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // --- Secure Storage Operations (JWT, sensitive credentials) ---

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: keyJwtToken, value: token);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: keyJwtToken);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: keyJwtToken);
  }

  Future<void> saveSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAllSecure() async {
    await _secureStorage.deleteAll();
  }

  // --- General Preferences Operations ---

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
