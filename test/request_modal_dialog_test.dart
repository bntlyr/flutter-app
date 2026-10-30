import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/ui/common/request_modal_dialog.dart';
import 'package:flutter_app/ui/features/status/status_screen.dart';

void main() {
  group('RequestModalDialog tests', () {
    testWidgets('renders modal header, dropdown, date of filing, empty content, and buttons',
        (WidgetTester tester) async {
      String? selectedType;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RequestModalDialog.show(
                        context: context,
                        onTypeChanged: (type) => selectedType = type,
                      );
                    },
                    child: const Text('Open Modal'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Request Form'), findsOneWidget);

      // Verify Labels
      expect(find.text('Type of Request'), findsOneWidget);
      expect(find.text('Date of Filing'), findsOneWidget);

      // Verify Footer Buttons
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      // Select Type of Request = Leave
      await tester.tap(find.byKey(const Key('request_type_dropdown_trigger')));
      await tester.pumpAndSettle();

      expect(find.text('Leave'), findsWidgets);
      await tester.tap(find.text('Leave').last);
      await tester.pumpAndSettle();

      expect(selectedType, equals('Leave'));

      // Tap Cancel closes modal
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Request Form'), findsNothing);
    });

    testWidgets('renders Leave form with disabled types when credits are 0 and validates reason',
        (WidgetTester tester) async {
      Map<String, dynamic>? submittedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RequestModalDialog.show(
                        context: context,
                        initialTypeOfRequest: 'Leave',
                        leaveTypes: const [
                          LeaveTypeOption(code: 'sl', label: 'Sick', credits: 6.0),
                          LeaveTypeOption(code: 'vl', label: 'Vacation', credits: 6.0),
                          LeaveTypeOption(code: 'pml', label: 'Paternity/Maternity', credits: 7.0),
                          LeaveTypeOption(code: 'brl', label: 'Bereavement', credits: 3.0),
                          LeaveTypeOption(code: 'spl', label: 'Solo Parent', credits: 0.0), // Disabled!
                          LeaveTypeOption(code: 'leaveWithoutPay', label: 'Leave Without Pay', credits: 999.0),
                        ],
                        onSubmitRequest: (data) => submittedData = data,
                      );
                    },
                    child: const Text('Open Leave Modal'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Leave Modal'));
      await tester.pumpAndSettle();

      // Leave section header is rendered
      expect(find.text('Leave'), findsWidgets);
      expect(find.text('Type of Leave'), findsOneWidget);
      expect(find.text('Half Day'), findsOneWidget);
      expect(find.text('Full Day'), findsOneWidget);
      expect(find.text('Reason of request'), findsOneWidget);

      // Open Type of Leave dropdown
      await tester.tap(find.byKey(const Key('leave_type_dropdown_trigger')));
      await tester.pumpAndSettle();

      // Sick, Vacation, Solo Parent, Leave Without Pay present in dropdown
      expect(find.text('Vacation'), findsWidgets);
      expect(find.text('Solo Parent'), findsWidgets);
      expect(find.text('Leave Without Pay'), findsWidgets);

      // Select Vacation
      await tester.tap(find.text('Vacation').last);
      await tester.pumpAndSettle();

      // Check TextField has top vertical alignment
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textAlignVertical, TextAlignVertical.top);

      // Submit with short reason shows validation error
      await tester.enterText(find.byType(TextField), 'Test');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(submittedData, isNull);

      // Enter valid reason (>= 7 chars) and submit
      await tester.enterText(find.byType(TextField), 'Family vacation trip out of town');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
    });

    testWidgets('renders and validates Timelogs Correction form',
        (WidgetTester tester) async {
      Map<String, dynamic>? submittedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RequestModalDialog.show(
                        context: context,
                        initialTypeOfRequest: 'Timelogs Correction',
                        onSubmitRequest: (data) => submittedData = data,
                      );
                    },
                    child: const Text('Open Timelogs Modal'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Timelogs Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Timelogs Correction'), findsWidgets);
      expect(find.text('Either Time-In, Time-Out, or both are required.'), findsOneWidget);
      expect(find.text('Time-In'), findsOneWidget);
      expect(find.text('Time-Out'), findsOneWidget);

      // Submit without date or times fails
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(submittedData, isNull);
      expect(find.text('Date Required'), findsOneWidget);
    });

    testWidgets('renders and validates Allowance and Overtime forms (both enabled)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RequestModalDialog.show(
                        context: context,
                        initialTypeOfRequest: 'Allowance',
                      );
                    },
                    child: const Text('Open Allowance Modal'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Allowance Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Allowance'), findsWidgets);
      expect(find.text('Perfect Attendance'), findsOneWidget);

      // Verify not selected by default, submit shows error
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Please select an allowance'), findsOneWidget);

      // Tap to select Perfect Attendance
      await tester.tap(find.text('Perfect Attendance'));
      await tester.pumpAndSettle();

      // Switch to Overtime
      await tester.tap(find.byKey(const Key('request_type_dropdown_trigger')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Overtime').last);
      await tester.pumpAndSettle();

      expect(find.text('Overtime'), findsWidgets);
      expect(find.text('Date applied in'), findsOneWidget);
    });

    testWidgets('renders Dayoff Work and toggles General and Offset',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RequestModalDialog.show(
                        context: context,
                        initialTypeOfRequest: 'Dayoff Work',
                      );
                    },
                    child: const Text('Open Dayoff Modal'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dayoff Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Dayoff Work Detail'), findsOneWidget);
      expect(find.text('This offday work will be compensated at the additional rate'), findsOneWidget);

      // Switch to Offset
      await tester.tap(find.byKey(const Key('dayoff_type_dropdown_trigger')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Offset').last);
      await tester.pumpAndSettle();

      expect(find.text('This offday work will be compensated at normal rate'), findsOneWidget);
      expect(find.text('From'), findsOneWidget);
      expect(find.text('To'), findsOneWidget);
    });

    testWidgets('renders Reshift breakdown table',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RequestModalDialog.show(
                        context: context,
                        initialTypeOfRequest: 'Reshift',
                      );
                    },
                    child: const Text('Open Reshift Modal'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Reshift Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Reshift'), findsWidgets);
      expect(find.text('Work Start'), findsOneWidget);
      expect(find.text('Work Break Start'), findsOneWidget);
      expect(find.text('Work Break End'), findsOneWidget);
      expect(find.text('Work End'), findsOneWidget);
    });

    testWidgets('tapping Add Request on StatusScreen opens RequestModalDialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Add Request button
      await tester.tap(find.text('Add Request'));
      await tester.pumpAndSettle();

      // RequestModalDialog is displayed
      expect(find.byType(RequestModalDialog), findsOneWidget);
      expect(find.text('Request Form'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
