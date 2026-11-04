import '../../../../core/graphql/graphql_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login({required String username, required String password}) async {
    final userModel = await remoteDataSource.login(
      username: username,
      password: password,
    );
    await localDataSource.cacheUser(userModel);
    return userModel;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCache();
    AppGraphQLClient.resetClient();
  }

  @override
  Future<User?> getCurrentUser() async {
    return localDataSource.getCachedUser();
  }

  @override
  Future<String?> getToken() async {
    return localDataSource.getToken();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}
