import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets('PayrollNeo navigation and 6-page suite smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially displays Splash Screen branding
    expect(find.text('Employee Self-Service Portal'), findsOneWidget);

    // Fast-forward past splash duration
    await tester.pumpAndSettle(const Duration(milliseconds: 2500));

    // 1. Verify Portal Tab
    expect(find.text('Attendance Summary'), findsOneWidget);
    expect(find.text('Attendance Alerts'), findsOneWidget);
    expect(find.text('Payroll Summary'), findsOneWidget);
    expect(find.text('Time In'), findsOneWidget);
    expect(find.text('Time Out'), findsOneWidget);

    // 2. Tap DTR tab
    await tester.tap(find.text('DTR'));
    await tester.pumpAndSettle();
    expect(find.text('Cutoff DTR Summary'), findsOneWidget);
    expect(find.text('Daily Time Record Logs'), findsOneWidget);
    expect(find.text('Total Regular Hours'), findsOneWidget);

    // Toggle Table view in DTR
    final dtrToggle = find.byTooltip('Switch to Table View').first;
    await tester.tap(dtrToggle);
    await tester.pumpAndSettle();
    expect(find.byType(DataTable), findsOneWidget);

    // 3. Tap Request tab
    await tester.tap(find.text('Request'));
    await tester.pumpAndSettle();
    expect(find.text('FILING DATE & TIME'), findsOneWidget);
    expect(find.text('Leave Application'), findsOneWidget);
    expect(find.text('Timelogs Correction'), findsOneWidget);
    expect(find.text('Allowance & Reimbursement'), findsOneWidget);
    expect(find.text('Overtime (OT) Request'), findsOneWidget);
    expect(find.text('Day Off Work'), findsOneWidget);
    expect(find.text('Reshift / Shift Swap'), findsOneWidget);

    // 4. Tap Status tab
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();
    expect(find.text('Request Tracker'), findsOneWidget);
    expect(find.text('Add Request'), findsOneWidget);
    expect(find.text('All Statuses'), findsOneWidget);

    // 5. Tap Payslip tab
    await tester.tap(find.text('Payslip'));
    await tester.pumpAndSettle();
    expect(find.text('Net Take-Home Pay'), findsOneWidget);
    expect(find.text('Gross Compensation'), findsAtLeastNWidgets(1));
    expect(find.text('Total Deductions'), findsOneWidget);
    expect(find.text('Irregular Adjustment'), findsAtLeastNWidgets(1));
    expect(find.text('PAYROLL ADVICE'), findsOneWidget);
    expect(find.text('Payroll Breakdown Details'), findsOneWidget);

    // Toggle Table view in Payslip breakdown
    final payslipToggle = find.byTooltip('Switch to Table View');
    await tester.ensureVisible(payslipToggle);
    await tester.tap(payslipToggle);
    await tester.pumpAndSettle();
    expect(find.byType(DataTable), findsOneWidget);

    // 6. Tap Personal tab
    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();
    expect(find.text('Alex Morgan'), findsAtLeastNWidgets(1));
    expect(find.text('Employee Information'), findsOneWidget);
    expect(find.text('Employment Information'), findsOneWidget);
    expect(find.text('Leave Status & Balances'), findsOneWidget);
    expect(find.text('Contribution Information'), findsOneWidget);
    expect(find.text('Loan Information'), findsOneWidget);
    expect(find.text('Recurring Deductions'), findsOneWidget);
  });
}
