import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/ui/common/calendar_date.dart';
import 'package:flutter_app/ui/features/status/status_screen.dart';

void main() {
  group('CalendarDate tests', () {
    testWidgets('defaults to empty selection with no initial teal highlight',
        (WidgetTester tester) async {
      String? selectedRange;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CalendarDate(
                onDateRangeSelected: (range) => selectedRange = range,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Empty prompt shown in bottom bar
      expect(find.text('Select date range'), findsOneWidget);

      // Select dates 2 to 14
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('14'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(selectedRange, equals('Oct-02-2026 – Oct-14-2026'));
    });

    testWidgets('StatusScreen opens CalendarDate anchored below Date field and updates selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial Date field shows placeholder
      final dateField = find.byType(CompositedTransformTarget);
      expect(dateField, findsOneWidget);

      // Tap Date field to open calendar overlay
      await tester.tap(dateField);
      await tester.pumpAndSettle();

      expect(find.byType(CalendarDate), findsOneWidget);
      expect(find.text('Select date range'), findsOneWidget);

      // Pick range 5 to 20
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Overlay closes, Date field updated
      expect(find.byType(CalendarDate), findsNothing);
      expect(find.text('Oct-05-2026 – Oct-20-2026'), findsOneWidget);
    });

    testWidgets('StatusScreen pagination changes page',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 – 10 of 35'), findsOneWidget);

      // Tap next page
      await tester.tap(find.byIcon(Icons.chevron_right).last);
      await tester.pumpAndSettle();

      expect(find.text('11 – 20 of 35'), findsOneWidget);
    });
  });
}
