import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/core/utils/app_formatters.dart';
import 'package:flutter_app/data/mock/mock_requests_data.dart';
import 'package:flutter_app/data/models/request_model.dart';
import 'package:flutter_app/data/mock/mock_payslip_data.dart';
import 'package:flutter_app/data/models/payslip_model.dart';
import 'package:flutter_app/ui/features/request/request_screen.dart';

void main() {
  group('AppFormatters unit tests', () {
    test('formats positive and negative currency correctly', () {
      expect(AppFormatters.currency(3450.00), equals('₱3,450.00'));
      expect(AppFormatters.currency(0.0), equals('₱0.00'));
      expect(AppFormatters.currency(-125.50), equals('-₱125.50'));
    });

    test('formats dates correctly', () {
      final date = DateTime(2026, 10, 29);
      expect(AppFormatters.dateShort(date), equals('Oct 29, 2026'));
      expect(AppFormatters.dateWithDay(date), contains('Oct 29, 2026'));
    });
  });

  group('MockRequestsRepository reactive tests', () {
    test('can add a new request and cancel pending request', () {
      final repo = MockRequestsRepository();
      final initialCount = repo.requests.length;

      final newReq = UserRequest(
        id: 'REQ-TEST-001',
        type: RequestType.overtime,
        filingDate: DateTime.now(),
        title: 'Unit Test Overtime',
        description: 'Testing request state',
        status: RequestStatus.pending,
        approver: 'Jane Cooper',
      );

      repo.addRequest(newReq);
      expect(repo.requests.length, equals(initialCount + 1));
      expect(repo.requests.first.id, equals('REQ-TEST-001'));
      expect(repo.requests.first.status, equals(RequestStatus.pending));

      // Test cancelling
      repo.cancelRequest('REQ-TEST-001');
      final cancelled = repo.requests.firstWhere((r) => r.id == 'REQ-TEST-001');
      expect(cancelled.status, equals(RequestStatus.cancelled));
    });
  });

  group('MockPayslipData integrity tests', () {
    test('contains all 8 required breakdown categories', () {
      final payslip = MockPayslipData.cutoffPayslips.values.first;
      for (final cat in PayrollCategory.values) {
        expect(payslip.categoryBreakdown.containsKey(cat), isTrue,
            reason: 'Missing category breakdown for ${cat.displayName}');
      }
    });
  });

  group('RequestScreen 2-column grid layout tests', () {
    testWidgets('renders 6 request cards in 2-column pairs without scrolling requirement',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RequestScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all 6 cards are present
      final leaveFinder = find.text('Leave Application');
      final timelogsFinder = find.text('Timelogs Correction');
      final allowanceFinder = find.text('Allowance & Reimbursement');
      final overtimeFinder = find.text('Overtime (OT) Request');
      final dayOffFinder = find.text('Day Off Work');
      final reshiftFinder = find.text('Reshift / Shift Swap');

      expect(leaveFinder, findsOneWidget);
      expect(timelogsFinder, findsOneWidget);
      expect(allowanceFinder, findsOneWidget);
      expect(overtimeFinder, findsOneWidget);
      expect(dayOffFinder, findsOneWidget);
      expect(reshiftFinder, findsOneWidget);

      // Verify 2-column alignment (paired items share the same vertical Y coordinate)
      final leaveTop = tester.getTopLeft(leaveFinder).dy;
      final timelogsTop = tester.getTopLeft(timelogsFinder).dy;
      expect((leaveTop - timelogsTop).abs(), lessThan(5.0),
          reason: 'Leave Application and Timelogs Correction should be in row 1 side-by-side');

      final allowanceTop = tester.getTopLeft(allowanceFinder).dy;
      final overtimeTop = tester.getTopLeft(overtimeFinder).dy;
      expect((allowanceTop - overtimeTop).abs(), lessThan(5.0),
          reason: 'Allowance & Reimbursement and Overtime should be in row 2 side-by-side');

      final dayOffTop = tester.getTopLeft(dayOffFinder).dy;
      final reshiftTop = tester.getTopLeft(reshiftFinder).dy;
      expect((dayOffTop - reshiftTop).abs(), lessThan(5.0),
          reason: 'Day Off Work and Reshift should be in row 3 side-by-side');

      // Verify horizontal ordering (item 1 left, item 2 right)
      expect(tester.getTopLeft(leaveFinder).dx, lessThan(tester.getTopLeft(timelogsFinder).dx));
      expect(tester.getTopLeft(allowanceFinder).dx, lessThan(tester.getTopLeft(overtimeFinder).dx));
      expect(tester.getTopLeft(dayOffFinder).dx, lessThan(tester.getTopLeft(reshiftFinder).dx));

      // Test tapping a card opens the filing bottom sheet
      await tester.tap(leaveFinder);
      await tester.pumpAndSettle();
      expect(find.text('File Leave Request'), findsOneWidget);
      expect(find.text('Submit Request for Approval'), findsOneWidget);
    });
  });
}
