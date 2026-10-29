import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Splash screen and navigation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially displays Splash Screen branding
    expect(find.text('Employee Self-Service Portal'), findsOneWidget);

    // Fast-forward past splash duration
    await tester.pumpAndSettle(const Duration(milliseconds: 2500));

    // Verify initial Portal tab is active
    expect(find.text('Welcome back, Alex!'), findsOneWidget);
    expect(find.text('Today Overview'), findsOneWidget);

    // Tap DTR tab
    await tester.tap(find.text('DTR'));
    await tester.pumpAndSettle();
    expect(find.text('Weekly Logs (Oct 25 - Oct 29)'), findsOneWidget);
    expect(find.text('Time In'), findsOneWidget);

    // Tap Request tab
    await tester.tap(find.text('Request'));
    await tester.pumpAndSettle();
    expect(find.text('Leave Application'), findsOneWidget);

    // Tap Status tab
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();
    expect(find.text('Submitted Requests Tracker'), findsOneWidget);

    // Tap Payslip tab
    await tester.tap(find.text('Payslip'));
    await tester.pumpAndSettle();
    expect(find.text('Net Take Home Pay'), findsOneWidget);

    // Tap Personal tab
    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();
    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });
}
