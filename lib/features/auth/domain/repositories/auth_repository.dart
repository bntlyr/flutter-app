import '../entities/user.dart';

/// Contract for authentication operations in Domain layer.
abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<void> logout();
  Future<User?> getCurrentUser();
}
