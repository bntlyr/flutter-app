import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter_app/features/splash/splash_screen.dart';
import 'package:flutter_app/data/mock/mock_profile_data.dart';
import 'package:flutter_app/features/personal/presentation/viewmodels/personal_viewmodel.dart';

class _SmokeMockAuthRepository implements AuthRepository {
  @override
  Future<User> login({required String username, required String password}) async {
    return const User(
      id: 'smoke-usr',
      username: 'smoke.user',
      email: 'smoke@company.com',
      name: 'Smoke User',
      token: 'smoke_token',
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User?> getCurrentUser() async => null;

  @override
  Future<String?> getToken() async => 'smoke_token';

  @override
  Future<bool> isAuthenticated() async => true;
}

class _MockGeolocatorPlatform extends GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() async => LocationPermission.always;

  @override
  Future<LocationPermission> requestPermission() async => LocationPermission.always;

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) async {
    return Position(
      latitude: 14.3525033,
      longitude: 121.0637445,
      accuracy: 3.0,
      altitude: 51.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.05,
      speedAccuracy: 0.0,
      timestamp: DateTime(2026, 11, 4),
    );
  }
}

class _MockPlatformWebViewController extends PlatformWebViewController {
  _MockPlatformWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setPlatformNavigationDelegate(PlatformNavigationDelegate handler) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}
}

class _MockPlatformNavigationDelegate extends PlatformNavigationDelegate {
  _MockPlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}
}

class _MockPlatformWebViewWidget extends PlatformWebViewWidget {
  _MockPlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 100);
}

class _MockWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) =>
      _MockPlatformWebViewController(params);

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) =>
      _MockPlatformNavigationDelegate(params);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) =>
      _MockPlatformWebViewWidget(params);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    GeolocatorPlatform.instance = _MockGeolocatorPlatform();
    WebViewPlatform.instance = _MockWebViewPlatform();
  });

  testWidgets('PayrollNeo navigation and 6-page suite smoke test', (WidgetTester tester) async {
    final mockRepo = _SmokeMockAuthRepository();
    final mockViewModel = LoginViewModel(loginUseCase: LoginUseCase(mockRepo));

    await tester.pumpWidget(MyApp(
      home: SplashScreen(
        nextScreen: LoginPage(
          viewModel: mockViewModel,
          homeBuilder: (_) => MainNavigationScreen(
            personalViewModel: PersonalViewModel(
              initialProfile: MockProfileData.profile,
            ),
          ),
        ),
      ),
    ));

    // Initially displays Splash Screen branding
    expect(find.text('Employee Self-Service Portal'), findsOneWidget);

    // Fast-forward past splash duration
    await tester.pumpAndSettle(const Duration(milliseconds: 2500));

    // Fill credentials & tap Log In
    expect(find.text('Log In'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'smoke.user');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    // 1. Verify Portal Tab
    expect(find.text('Attendance Summary'), findsOneWidget);
    expect(find.text('Attendance Alert'), findsOneWidget);
    expect(find.text('Payroll Summary'), findsOneWidget);
    expect(find.text('Time-In Now'), findsOneWidget);
    expect(find.text('Time-Out Now'), findsOneWidget);

    // 2. Tap DTR tab
    await tester.tap(find.text('DTR'));
    await tester.pumpAndSettle();
    expect(find.text('Refresh logs'), findsOneWidget);
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Cut-off'), findsOneWidget);
    expect(find.text('Approved Requests'), findsWidgets);

    // 3. Tap Request tab in dock -> navigates to Status screen and opens Add Request modal
    await tester.tap(find.text('Request'));
    await tester.pumpAndSettle();
    expect(find.text('Request Form'), findsOneWidget);
    expect(find.text('Type of Request'), findsOneWidget);

    // Close the Add Request modal
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // 4. Verify we are now on Status tab
    expect(find.text('Add Request'), findsOneWidget);
    expect(find.text('Date'), findsWidgets);
    expect(find.text('Leave'), findsWidgets);
    expect(find.text('Timelogs Correction'), findsWidgets);

    // 5. Tap Payslip tab in dock
    await tester.tap(find.text('Payslip'));
    await tester.pumpAndSettle();
    expect(find.text('Net Pay'), findsOneWidget);
    expect(find.text('Total Deduction'), findsOneWidget);
    expect(find.text('Irregular Adjustment'), findsWidgets);

    // 6. Tap Personal tab in dock
    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Employee Information'), findsOneWidget);

    // Re-verify back to Portal screen
    await tester.tap(find.text('Portal'));
    await tester.pumpAndSettle();
    expect(find.text('Attendance Summary'), findsOneWidget);
    expect(find.text('Attendance Alert'), findsOneWidget);
    expect(find.text('Time-In Now'), findsOneWidget);
    expect(find.text('Time-Out Now'), findsOneWidget);

    // Tap Time-In Now and confirm bottom sheet opens
    await tester.tap(find.text('Time-In Now'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Manual Time-In'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Dismiss bottom sheet
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Attendance Summary'), findsOneWidget);
  });
}
