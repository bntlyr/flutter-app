import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:flutter_app/ui/common/modal_map_dialog.dart';
import 'package:flutter_app/ui/common/request_view_dialog.dart';

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
    WebViewPlatform.instance = MockWebViewPlatform();
  });

  group('ModalMapDialog tests', () {
    testWidgets('renders modal-map header, location title and address',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      ModalMapDialog.show(
                        context: context,
                        title: 'Map',
                        locationTitle: 'My Location is Around Here:',
                        address:
                            'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines',
                      );
                    },
                    child: const Text('Open Map Modal'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Map Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Map'), findsOneWidget);
      expect(find.byKey(const Key('modal_map_close_button')), findsOneWidget);
      expect(find.byType(WebViewWidget), findsOneWidget);
      expect(find.text('My Location is Around Here:'), findsOneWidget);
      expect(
        find.text(
            'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines'),
        findsOneWidget,
      );

      // Close modal
      await tester.tap(find.byKey(const Key('modal_map_close_button')));
      await tester.pumpAndSettle();

      expect(find.text('My Location is Around Here:'), findsNothing);
    });

    testWidgets(
        'RequestViewDialog clicking "See the applied location" opens ModalMapDialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RequestViewDialog.show(
                        context: context,
                        typeOfRequest: 'Timelogs Correction',
                        status: 'Approved',
                        filingDate: 'October 28, 2026',
                        dateApplied: 'October 28, 2026',
                        timeIn: '06:55',
                        timeOut: '--',
                        reason:
                            'I acknowledge that my place is around the pinned location in the map.',
                        approvedBy: 'Paul Javinez',
                        locationTitle: 'My Location is Around Here:',
                        locationAddress:
                            'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines',
                      );
                    },
                    child: const Text('Open Request Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Request Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Details of Request'), findsOneWidget);
      expect(find.text('Timelogs Correction'), findsOneWidget);
      expect(find.text('06:55'), findsOneWidget);
      expect(find.byKey(const Key('see_applied_location_button')), findsOneWidget);

      // Tap on "See the applied location"
      await tester.tap(find.byKey(const Key('see_applied_location_button')));
      await tester.pumpAndSettle();

      // Verify modal map is open
      expect(find.byType(ModalMapDialog), findsOneWidget);
      expect(find.byType(WebViewWidget), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(ModalMapDialog), matching: find.text('Map')),
        findsOneWidget,
      );
      expect(find.text('My Location is Around Here:'), findsOneWidget);
      expect(
        find.text(
            'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines'),
        findsOneWidget,
      );
    });

    testWidgets('GoogleMapPage renders WebViewWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GoogleMapPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WebViewWidget), findsOneWidget);
      expect(find.text('Google Maps'), findsOneWidget);
    });
  });
}
