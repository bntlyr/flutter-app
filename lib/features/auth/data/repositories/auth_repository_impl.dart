import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository combining remote and local data sources.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
    AuthLocalDataSource? localDataSource,
  })  : remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl(),
        localDataSource = localDataSource ?? AuthLocalDataSourceImpl();

  @override
  Future<User> login({required String email, required String password}) async {
    final userModel = await remoteDataSource.login(email: email, password: password);
    await localDataSource.cacheUser(userModel);
    return userModel;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCache();
  }

  @override
  Future<User?> getCurrentUser() async {
    return localDataSource.getCachedUser();
  }
}
