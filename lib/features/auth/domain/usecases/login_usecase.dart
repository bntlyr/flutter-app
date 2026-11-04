import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Usecase for logging in a user with credentials.
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<User> execute({required String username, required String password}) {
    final cleanUsername = username.trim();
    if (cleanUsername.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    return repository.login(username: cleanUsername, password: password);
  }
}
