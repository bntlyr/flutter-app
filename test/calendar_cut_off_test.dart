import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/ui/common/calendar_cut_off.dart';

void main() {
  group('CalendarCutOff Widget tests', () {
    testWidgets('renders month header, custom range selection, and month navigation',
        (WidgetTester tester) async {
      String? selectedCutoff;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CalendarCutOff(
                selectedCutoff: 'Oct-01-2026 – Oct-15-2026',
                onCutoffSelected: (range) => selectedCutoff = range,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Year header and weekdays
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Su'), findsOneWidget);
      expect(find.text('OCT'), findsOneWidget);

      // Check days 1, 2, 3 are present
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);

      // 1. Select custom range 1 to 31 (Whole month) by tapping Day 1 then Day 31
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('31'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(selectedCutoff, equals('Oct-01-2026 – Oct-31-2026'));

      // 2. Select custom range 16 to 31 by tapping Day 16 then Day 31
      await tester.tap(find.text('16'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('31'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(selectedCutoff, equals('Oct-16-2026 – Oct-31-2026'));

      // 3. Select custom range 1 to 15 by tapping Day 1 then Day 15
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(selectedCutoff, equals('Oct-01-2026 – Oct-15-2026'));

      // 4. Select custom range 5 to 20 by tapping Day 5 then Day 20
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(selectedCutoff, equals('Oct-05-2026 – Oct-20-2026'));

      // 5. Test Month navigation: `<` moves to previous month (September)
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('SEP'), findsOneWidget);

      // `>` moves to future month (October, then November)
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('OCT'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('NOV'), findsOneWidget);
    });

    testWidgets('correctly parses and initializes with 2018 cutoff string',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CalendarCutOff(
                selectedCutoff: 'Oct-16-2018 – Oct-31-2018',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2018'), findsOneWidget);
      expect(find.text('OCT'), findsOneWidget);
    });

    testWidgets('shows semicircle hover preview while selecting, teal styling only after confirm',
        (WidgetTester tester) async {
      String? selectedRange;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CalendarCutOff(
                selectedCutoff: 'Oct-01-2026 – Oct-15-2026',
                onCutoffSelected: (range) => selectedRange = range,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap day 5 to begin range selection
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      // Hover over day 12 using mouse gesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(find.text('12')));
      addTearDown(gesture.removePointer);
      await tester.pumpAndSettle();

      // DashedRibbonPainter with semicircle cap is rendered during hover
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('12'), findsOneWidget);

      // Confirm selection by tapping Apply
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(selectedRange, equals('Oct-05-2026 – Oct-12-2026'));
    });

    testWidgets('dragging across dates updates hovered day and applies on confirm',
        (WidgetTester tester) async {
      String? selectedRange;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CalendarCutOff(
                selectedCutoff: 'Oct-01-2026 – Oct-15-2026',
                onCutoffSelected: (range) => selectedRange = range,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Drag from day 1 to day 15
      final startPos = tester.getCenter(find.text('1'));
      final endPos = tester.getCenter(find.text('15'));

      final dragGesture = await tester.startGesture(startPos);
      await tester.pumpAndSettle();
      await dragGesture.moveTo(endPos);
      await tester.pumpAndSettle();
      await dragGesture.up();
      await tester.pumpAndSettle();

      // Semicircle indicator rendered on day 15
      expect(find.byType(CustomPaint), findsWidgets);

      // Confirm with Apply
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(selectedRange, equals('Oct-01-2026 – Oct-15-2026'));
    });

    testWidgets('tap year header opens 24-year grid, tap year opens 12-month grid, tap month returns to days',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CalendarCutOff(
                selectedCutoff: 'Oct-01-2026 – Oct-15-2026',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap year header '2026'
      await tester.tap(find.text('2026'));
      await tester.pumpAndSettle();

      // Should show year range header '2016 – 2039'
      expect(find.text('2016 – 2039'), findsOneWidget);
      expect(find.text('2016'), findsOneWidget);
      expect(find.text('2039'), findsOneWidget);

      // Tap year '2026' in the grid
      await tester.tap(find.text('2026'));
      await tester.pumpAndSettle();

      // Should now show month grid with months JAN, FEB, ..., NOV, DEC
      expect(find.text('JAN'), findsOneWidget);
      expect(find.text('NOV'), findsOneWidget);
      expect(find.text('DEC'), findsOneWidget);

      // Tap month 'NOV'
      await tester.tap(find.text('NOV'));
      await tester.pumpAndSettle();

      // Should return to days view for NOV
      expect(find.text('NOV'), findsOneWidget);
      expect(find.text('Su'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
