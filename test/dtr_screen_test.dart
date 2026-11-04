import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/dtr/presentation/pages/dtr_screen.dart';

void main() {
  group('DtrScreen tests', () {
    testWidgets('renders mobile DTR screen with header, summary, carousel, and details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DtrScreen(initialCutoff: 'Oct-16-2026 – Oct-31-2026'),
        ),
      );
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Refresh logs'), findsOneWidget);
      expect(find.text('Cut-off'), findsOneWidget);
      expect(find.text('Oct-16-2026 – Oct-31-2026'), findsOneWidget);

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

      // Details for default selected day (Oct 16)
      expect(find.text('October 16, 2026'), findsOneWidget);

      // Select Day 19
      await tester.ensureVisible(find.text('19'));
      await tester.tap(find.text('19'));
      await tester.pumpAndSettle();

      // Details for selected day (Oct 19)
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

    testWidgets('changing cutoff dynamically updates carousel days and selected day details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DtrScreen(initialCutoff: 'Oct-16-2026 – Oct-31-2026'),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Cut-off input to open CalendarCutOff picker
      await tester.tap(find.text('Oct-16-2026 – Oct-31-2026'));
      await tester.pumpAndSettle();

      // In CalendarCutOff picker, select Day 1 to Day 15
      await tester.tap(find.text('1').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('15').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Header now displays new cutoff
      expect(find.text('Oct-01-2026 – Oct-15-2026'), findsOneWidget);

      // Carousel now shows Day 01 (starts at index 0 = Oct 1)
      expect(find.text('October 01, 2026'), findsOneWidget);

      // Tap Day 05 in the new carousel
      await tester.tap(find.text('05'));
      await tester.pumpAndSettle();

      // Details update to October 05, 2026
      expect(find.text('October 05, 2026'), findsOneWidget);
    });

    test('DtrScreen.getDefaultCutoff dynamically computes correct cutoff based on date', () {
      expect(
        DtrScreen.getDefaultCutoff(DateTime(2026, 11, 4)),
        equals('Nov-01-2026 – Nov-15-2026'),
      );
      expect(
        DtrScreen.getDefaultCutoff(DateTime(2026, 11, 20)),
        equals('Nov-16-2026 – Nov-30-2026'),
      );
      expect(
        DtrScreen.getDefaultCutoff(DateTime(2026, 2, 10)),
        equals('Feb-01-2026 – Feb-15-2026'),
      );
      expect(
        DtrScreen.getDefaultCutoff(DateTime(2026, 2, 28)),
        equals('Feb-16-2026 – Feb-28-2026'),
      );
    });
  });
}
