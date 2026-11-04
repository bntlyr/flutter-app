import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/dtr/dtr_screen.dart';

void main() {
  group('DtrScreen tests', () {
    testWidgets('renders mobile DTR screen with header, summary, carousel, and details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DtrScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Refresh logs'), findsOneWidget);
      expect(find.text('Cut-off'), findsOneWidget);
      expect(find.text('Oct-16-26 — Oct-31-26'), findsOneWidget);

      // Summary Card
      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Approved Requests'), findsWidgets);
      expect(find.text('Absent'), findsWidgets);
      expect(find.text('Late'), findsWidgets);
      expect(find.text('Undertime'), findsWidgets);
      expect(find.text('Allowance'), findsWidgets);
      expect(find.text('₱632.00'), findsOneWidget);

      // Expand summary card
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pumpAndSettle();

      // Compensations appear
      expect(find.text('Compensations (Day)'), findsOneWidget);
      expect(find.text('Compensations (Night)'), findsOneWidget);
      expect(find.text('Overtime'), findsWidgets);
      expect(find.text('Legal Holiday'), findsWidgets);
      expect(find.text('Regular'), findsWidgets);

      // Collapse summary card back
      await tester.tap(find.byIcon(Icons.expand_less), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Date Carousel
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);

      // Details for default selected day (Oct 19)
      expect(find.text('October 19, 2026'), findsOneWidget);
      expect(find.text('In: 07:01   Out: 16:03'), findsOneWidget);
      expect(find.text('Punctuality'), findsOneWidget);
      expect(find.text('Day Rate Compensations'), findsOneWidget);
      expect(find.text('Allowances'), findsOneWidget);
      expect(find.text('Transportation'), findsWidgets);
      expect(find.text('Meal'), findsWidgets);

      // Select another day (Oct 22 - Absent day)
      await tester.ensureVisible(find.text('22'));
      await tester.tap(find.text('22'));
      await tester.pumpAndSettle();

      expect(find.text('October 22, 2026'), findsOneWidget);
      expect(find.text('leaveWithoutPay Leave'), findsOneWidget);
    });
  });
}
