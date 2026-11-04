import 'dart:convert';
import 'package:flutter_app/services/storage_service.dart';
import '../models/user_model.dart';

/// Local storage data source contract for Auth caching.
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService? storageService;

  AuthLocalDataSourceImpl({this.storageService});

  Future<StorageService> get _storage async =>
      storageService ?? await StorageService.getInstance();

  @override
  Future<void> cacheUser(UserModel user) async {
    final storage = await _storage;
    if (user.token != null && user.token!.isNotEmpty) {
      await storage.saveToken(user.token!);
    }
    await storage.saveSecureString(
      StorageService.keyUserSession,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final storage = await _storage;
    final jsonStr = await storage.getSecureString(StorageService.keyUserSession);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return UserModel.fromJson(map);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<String?> getToken() async {
    final storage = await _storage;
    return storage.getToken();
  }

  @override
  Future<void> clearCache() async {
    final storage = await _storage;
    await storage.deleteToken();
    await storage.deleteSecure(StorageService.keyUserSession);
  }
}
