import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:flutter_app/features/portal/portal_screen.dart';
import 'package:flutter_app/features/portal/components/portal_manual_time_dialog.dart';

class MockGeolocatorPlatform extends GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.always;

  @override
  Future<LocationPermission> requestPermission() async =>
      LocationPermission.always;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    return Position(
      latitude: 14.3525033,
      longitude: 121.0637445,
      accuracy: 3.0,
      altitude: 51.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.050971198827028275,
      speedAccuracy: 0.0,
      timestamp: DateTime(2026, 11, 4),
    );
  }
}

class MockPlatformWebViewController extends PlatformWebViewController {
  MockPlatformWebViewController(super.params) : super.implementation();

  PlatformNavigationDelegate? _navDelegate;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {
    _navDelegate = handler;
  }

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    if (_navDelegate is MockPlatformNavigationDelegate) {
      (_navDelegate as MockPlatformNavigationDelegate).triggerPageFinished();
    }
  }

  @override
  Future<void> loadHtmlString(
    String html, {
    String? baseUrl,
  }) async {
    if (_navDelegate is MockPlatformNavigationDelegate) {
      (_navDelegate as MockPlatformNavigationDelegate).triggerPageFinished();
    }
  }
}

class MockPlatformNavigationDelegate extends PlatformNavigationDelegate {
  MockPlatformNavigationDelegate(super.params) : super.implementation();

  PageEventCallback? _onPageFinished;

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {
    _onPageFinished = onPageFinished;
  }

  void triggerPageFinished() {
    _onPageFinished?.call('');
  }
}

class MockPlatformWebViewWidget extends PlatformWebViewWidget {
  MockPlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: Key('mock_web_view_widget'),
    );
  }
}

class MockWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return MockPlatformWebViewController(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return MockPlatformNavigationDelegate(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return MockPlatformWebViewWidget(params);
  }
}

void main() {
  setUp(() {
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    WebViewPlatform.instance = MockWebViewPlatform();
    SharedPreferences.setMockInitialValues({});
  });

  group('PortalManualTimeDialog tests', () {
    testWidgets('renders Manual Time-In sheet with map, address, reload, and controls',
        (WidgetTester tester) async {
      bool confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    PortalManualTimeDialog.show(
                      context: context,
                      isTimeIn: true,
                      onConfirmed: () => confirmed = true,
                    );
                  },
                  child: const Text('Open Modal'),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Manual Time-In'), findsOneWidget);
      expect(find.byType(WebViewWidget), findsOneWidget);
      expect(find.text('My Place is Here:'), findsOneWidget);
      expect(find.byKey(const Key('manual_time_reload_button')), findsOneWidget);
      expect(find.text('Reload >'), findsOneWidget);
      expect(
        find.text('I acknowledge that my place is around here.'),
        findsOneWidget,
      );
      expect(
        find.text('Apply for timelogs correction for errors >'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('manual_time_cancel_button')), findsOneWidget);
      expect(find.byKey(const Key('manual_time_confirm_button')), findsOneWidget);

      // Confirm button is disabled before acknowledge checkbox is tapped
      final confirmBtnBefore = tester.widget<ElevatedButton>(
        find.byKey(const Key('manual_time_confirm_button')),
      );
      expect(confirmBtnBefore.onPressed, isNull);

      // Toggle acknowledgement checkbox
      await tester.tap(find.byKey(const Key('manual_time_acknowledge_checkbox')));
      await tester.pumpAndSettle();

      final confirmBtnAfter = tester.widget<ElevatedButton>(
        find.byKey(const Key('manual_time_confirm_button')),
      );
      expect(confirmBtnAfter.onPressed, isNotNull);

      // Tap Confirm
      await tester.tap(find.byKey(const Key('manual_time_confirm_button')));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(find.byType(PortalManualTimeDialog), findsNothing);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('portal_last_log_type'), 'IN');
      expect(prefs.getDouble('portal_last_log_lat'), 14.3525033);
      expect(prefs.getDouble('portal_last_log_lng'), 121.0637445);
      expect(prefs.getDouble('portal_last_log_accuracy'), 3.0);
    });

    testWidgets('PortalScreen tapping Time-In Now opens Manual Time-In bottom sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PortalScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Time-In Now'), findsOneWidget);
      await tester.tap(find.byKey(const Key('portal_time_in_button')));
      await tester.pumpAndSettle();

      expect(find.byType(PortalManualTimeDialog), findsOneWidget);
      expect(find.text('Manual Time-In'), findsOneWidget);

      // Close sheet via cancel
      await tester.tap(find.byKey(const Key('manual_time_cancel_button')));
      await tester.pumpAndSettle();

      expect(find.byType(PortalManualTimeDialog), findsNothing);
    });
  });
}
