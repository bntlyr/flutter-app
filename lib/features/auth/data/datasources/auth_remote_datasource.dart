import 'dart:convert';
import 'dart:io';
import 'package:graphql/client.dart' as gql;
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/graphql/__generated__/schema.graphql.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/utils/rsa_encryptor.dart';
import '../../../../services/storage_service.dart';
import '../graphql/__generated__/signin.graphql.dart';
import '../models/user_model.dart';

/// Remote data source contract for Auth.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String username, required String password});
  Future<String> getPublicKey();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final gql.GraphQLClient? graphqlClient;
  final StorageService? storageService;
  final HttpClient httpClient;

  AuthRemoteDataSourceImpl({
    this.graphqlClient,
    this.storageService,
    HttpClient? httpClient,
  }) : httpClient = httpClient ?? HttpClient();

  Future<gql.GraphQLClient> get _client async =>
      graphqlClient ?? await AppGraphQLClient.getClient();

  Future<StorageService> get _storage async =>
      storageService ?? await StorageService.getInstance();

  @override
  Future<String> getPublicKey() async {
    final storage = await _storage;
    final cached = await storage.getSecureString(StorageService.keyPublicKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    try {
      final request = await httpClient.getUrl(Uri.parse(ApiEndpoints.publicKeyUrl));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(body);
        final key = decoded is String ? decoded : body;
        await storage.saveSecureString(StorageService.keyPublicKey, key);
        return key;
      }
      throw ServerException('Failed to fetch public key: HTTP ${response.statusCode}');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to reach public key endpoint: $e');
    }
  }

  @override
  Future<UserModel> login({required String username, required String password}) async {
    final cleanUsername = username.trim();
    final publicKey = await getPublicKey();

    final encryptedPassword = RsaEncryptor.encrypt(
      plainText: password,
      pemPublicKey: publicKey,
    );

    final client = await _client;
    final result = await client.mutate$Signin(
      Options$Mutation$Signin(
        variables: Variables$Mutation$Signin(
          creds: Input$CredentialsInput(
            username: cleanUsername,
            password: encryptedPassword,
          ),
        ),
        fetchPolicy: gql.FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final errors = result.exception?.graphqlErrors;
      if (errors != null && errors.isNotEmpty) {
        throw AuthException(errors.first.message);
      }
      final linkEx = result.exception?.linkException;
      throw ServerException(linkEx?.toString() ?? 'Network error during login');
    }

    final signinData = result.parsedData?.signin;
    if (signinData == null) {
      throw const AuthException('No response received from login mutation.');
    }

    if (signinData.userErrors.isNotEmpty) {
      final errorMsg = signinData.userErrors.map((e) => e.message).join(', ');
      throw AuthException(errorMsg.isNotEmpty ? errorMsg : 'Invalid credentials');
    }

    final token = signinData.token;
    if (token == null || token.isEmpty) {
      throw const AuthException('Authentication failed: Missing JWT access token.');
    }

    final company = signinData.company;

    return UserModel(
      id: company?.id ?? cleanUsername,
      username: cleanUsername,
      email: company?.companyEmail ?? '',
      name: cleanUsername,
      token: token,
      companyId: company?.id,
      companyName: company?.companyName,
    );
  }
}
