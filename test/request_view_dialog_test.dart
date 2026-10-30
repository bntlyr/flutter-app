import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/ui/common/request/request_view_dialog.dart';

void main() {
  group('RequestViewDialog tests', () {
    testWidgets('renders Rejected status with red circle, X icon, and Paul Javinez as rejecter',
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
                        typeOfRequest: 'Allowance',
                        status: 'Rejected',
                        filingDate: 'May 15, 2026',
                        dateApplied: 'May 01, 2026',
                        allowanceType: 'Perfect Attendance',
                        reason: 'Request for allowance and perfect attendance from May1-15,2026. TY',
                        rejectedBy: 'Paul Javinez',
                        rejectedDate: 'May 18, 2026 09:53',
                      );
                    },
                    child: const Text('Open Rejected Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Rejected Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Details of Request'), findsOneWidget);
      expect(find.text('Rejected'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsWidgets);
      expect(find.text('May 15, 2026'), findsOneWidget);
      expect(find.text('Allowance'), findsOneWidget);
      expect(find.text('Perfect Attendance'), findsOneWidget);
      expect(find.textContaining('Paul Javinez'), findsOneWidget);
      expect(find.text('Cancel Request'), findsOneWidget);
    });

    testWidgets('renders Approved status with blue circle and Paul Javinez as approver',
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
                        typeOfRequest: 'Allowance',
                        status: 'Approved',
                        filingDate: 'May 01, 2026',
                        dateApplied: 'April 16, 2026',
                        allowanceType: 'Perfect Attendance',
                        reason: 'Request for allowance and perfect attendance from April16-30,2026',
                        approvedBy: 'Paul Javinez',
                        approvedDate: 'May 04, 2026 11:00',
                      );
                    },
                    child: const Text('Open Approved Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Approved Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Approved'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.textContaining('Paul Javinez'), findsOneWidget);
    });

    testWidgets('renders Pending status with orange circle and clock icon',
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
                        status: 'Pending',
                        filingDate: 'September 16, 2025',
                        timeIn: '--',
                        timeOut: '00:00',
                        reason: 'Didnt appear time out',
                      );
                    },
                    child: const Text('Open Pending Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Pending Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Pending'), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
      expect(find.text('Didnt appear time out'), findsOneWidget);
    });

    testWidgets('renders Pre-Approved status with green circle',
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
                        status: 'Pre-Approved',
                        filingDate: 'August 26, 2025',
                        timeIn: '--',
                        timeOut: '00:00',
                        reason: 'Not appear my time out in biometrics',
                        preApprovedBy: 'Panisales, Christine Mae',
                        preApprovedDate: 'August 26, 2025 16:27',
                      );
                    },
                    child: const Text('Open Pre-Approved Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Pre-Approved Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Pre-Approved'), findsOneWidget);
      expect(find.textContaining('Panisales, Christine Mae'), findsOneWidget);
    });
  });
}
