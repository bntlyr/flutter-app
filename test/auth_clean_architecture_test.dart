import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/core/errors/exceptions.dart';
import 'package:flutter_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_app/features/auth/presentation/components/login_form.dart';
import 'package:flutter_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter_app/services/storage_service.dart';

class MockRemoteDataSource implements AuthRemoteDataSource {
  final UserModel? userToReturn;
  final Exception? exceptionToThrow;
  String? lastUsername;
  String? lastPassword;

  MockRemoteDataSource({this.userToReturn, this.exceptionToThrow});

  @override
  Future<String> getPublicKey() async => 'dummy_key';

  @override
  Future<UserModel> login({required String username, required String password}) async {
    lastUsername = username;
    lastPassword = password;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return userToReturn!;
  }
}

class MockAuthRepository implements AuthRepository {
  final User? userToReturn;
  final Exception? exceptionToThrow;

  MockAuthRepository({this.userToReturn, this.exceptionToThrow});

  @override
  Future<User> login({required String username, required String password}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return userToReturn!;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User?> getCurrentUser() async => userToReturn;

  @override
  Future<String?> getToken() async => userToReturn?.token;

  @override
  Future<bool> isAuthenticated() async => userToReturn != null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('Domain Layer: LoginUseCase', () {
    test('throws ArgumentError if username is empty', () async {
      final repo = MockAuthRepository();
      final usecase = LoginUseCase(repo);

      expect(
        () => usecase.execute(username: '', password: 'secret'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError if password is empty', () async {
      final repo = MockAuthRepository();
      final usecase = LoginUseCase(repo);

      expect(
        () => usecase.execute(username: 'admin', password: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('trims username and delegates to repository', () async {
      const expectedUser = User(
        id: 'usr-1',
        username: 'john.doe',
        email: 'john@example.com',
        name: 'John Doe',
        token: 'jwt-123',
      );
      final repo = MockAuthRepository(userToReturn: expectedUser);
      final usecase = LoginUseCase(repo);

      final user = await usecase.execute(username: '  john.doe  ', password: 'password123');
      expect(user.username, equals('john.doe'));
      expect(user.token, equals('jwt-123'));
    });
  });

  group('Data Layer: AuthLocalDataSource', () {
    test('caches user securely and restores from storage', () async {
      final storage = await StorageService.getInstance();
      final localDs = AuthLocalDataSourceImpl(storageService: storage);

      const user = UserModel(
        id: 'emp-101',
        username: 'emp101',
        email: 'emp101@company.com',
        name: 'Employee One',
        token: 'token_abc',
      );

      await localDs.cacheUser(user);
      final restored = await localDs.getCachedUser();
      expect(restored, isNotNull);
      expect(restored!.id, equals('emp-101'));
      expect(restored.username, equals('emp101'));
      expect(await localDs.getToken(), equals('token_abc'));

      await localDs.clearCache();
      expect(await localDs.getCachedUser(), isNull);
      expect(await localDs.getToken(), isNull);
    });
  });

  group('Data Layer: AuthRepositoryImpl', () {
    test('coordinates remote login and local caching', () async {
      final storage = await StorageService.getInstance();
      final localDs = AuthLocalDataSourceImpl(storageService: storage);
      const remoteUser = UserModel(
        id: 'usr-42',
        username: 'alice',
        email: 'alice@company.com',
        name: 'Alice',
        token: 'alice_jwt_token',
      );
      final remoteDs = MockRemoteDataSource(userToReturn: remoteUser);
      final repo = AuthRepositoryImpl(
        remoteDataSource: remoteDs,
        localDataSource: localDs,
      );

      final result = await repo.login(username: 'alice', password: 'password');
      expect(result.token, equals('alice_jwt_token'));

      final cached = await repo.getCurrentUser();
      expect(cached?.username, equals('alice'));
      expect(await repo.isAuthenticated(), isTrue);

      await repo.logout();
      expect(await repo.isAuthenticated(), isFalse);
    });
  });

  group('Presentation Layer: LoginViewModel', () {
    test('updates state on successful login', () async {
      const user = User(
        id: 'u1',
        username: 'cbc@67',
        email: 'cbc@company.com',
        name: 'CBC User',
        token: 'token123',
      );
      final repo = MockAuthRepository(userToReturn: user);
      final viewModel = LoginViewModel(loginUseCase: LoginUseCase(repo));

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.currentUser, isNull);

      final success = await viewModel.login('cbc@67', 'secret');
      expect(success, isTrue);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.currentUser?.username, equals('cbc@67'));
    });

    test('captures Invalid credentials and sets Username or password is incorrect', () async {
      final repo = MockAuthRepository(
        exceptionToThrow: const AuthException('Invalid credentials'),
      );
      final viewModel = LoginViewModel(loginUseCase: LoginUseCase(repo));

      final success = await viewModel.login('wrong', 'wrong');
      expect(success, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, equals('Username or password is incorrect'));
      expect(viewModel.currentUser, isNull);
    });

    testWidgets('LoginForm renders error banner and does NOT proceed on incorrect credentials', (tester) async {
      final repo = MockAuthRepository(
        exceptionToThrow: const AuthException('Invalid credentials'),
      );
      final viewModel = LoginViewModel(loginUseCase: LoginUseCase(repo));
      bool loginSuccessCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginForm(
            viewModel: viewModel,
            onLoginSuccess: () {
              loginSuccessCalled = true;
            },
          ),
        ),
      ));

      // Attempt login with incorrect credentials
      await tester.enterText(find.byType(TextFormField).first, 'SPPC@03');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpass');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      // Verify that navigation was NOT called
      expect(loginSuccessCalled, isFalse);
      // Verify error banner is visible
      expect(find.text('Username or password is incorrect'), findsOneWidget);
    });

    testWidgets('LoginForm calls onLoginSuccess only on valid credentials', (tester) async {
      const user = User(
        id: 'u-valid',
        username: 'SPPC@03',
        email: 'sppc@company.com',
        name: 'SPPC User',
        token: 'valid-jwt',
      );
      final repo = MockAuthRepository(userToReturn: user);
      final viewModel = LoginViewModel(loginUseCase: LoginUseCase(repo));
      bool loginSuccessCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginForm(
            viewModel: viewModel,
            onLoginSuccess: () {
              loginSuccessCalled = true;
            },
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField).first, 'SPPC@03');
      await tester.enterText(find.byType(TextFormField).last, 'correctpass');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(loginSuccessCalled, isTrue);
      expect(find.text('Username or password is incorrect'), findsNothing);
    });
  });
}
