import '../models/user_model.dart';

/// Remote data source contract for Auth.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({required String email, required String password}) async {
    // Simulated remote authentication
    await Future.delayed(const Duration(milliseconds: 400));
    return UserModel(
      id: 'usr-6767',
      email: email,
      name: 'Paul Javinez',
      token: 'jwt_sample_token_6767',
    );
  }
}
