import 'package:flutter_app/services/storage_service.dart';
import '../models/user_model.dart';

/// Local storage data source contract for Auth caching.
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _keyToken = 'auth_token';
  static const String _keyEmail = 'auth_email';
  static const String _keyName = 'auth_name';
  static const String _keyId = 'auth_id';

  @override
  Future<void> cacheUser(UserModel user) async {
    final storage = await StorageService.getInstance();
    await storage.setString(_keyId, user.id);
    await storage.setString(_keyEmail, user.email);
    await storage.setString(_keyName, user.name);
    if (user.token != null) {
      await storage.setString(_keyToken, user.token!);
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final storage = await StorageService.getInstance();
    final id = storage.getString(_keyId);
    final email = storage.getString(_keyEmail);
    final name = storage.getString(_keyName);
    final token = storage.getString(_keyToken);

    if (id != null && email != null && name != null) {
      return UserModel(id: id, email: email, name: name, token: token);
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    final storage = await StorageService.getInstance();
    await storage.remove(_keyId);
    await storage.remove(_keyEmail);
    await storage.remove(_keyName);
    await storage.remove(_keyToken);
  }
}
