import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/data/mock/mock_profile_data.dart';

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

    // 3. Tap Request tab in dock -> navigates to Status screen and opens Add Request modal
    await tester.tap(find.text('Request'));
    await tester.pumpAndSettle();
    expect(find.text('Request Form'), findsOneWidget);
    expect(find.text('Type of Request'), findsOneWidget);

    // Close the Add Request modal
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // 4. Verify we are now on Status tab
    expect(find.text('Add Request'), findsOneWidget);
    expect(find.text('Date'), findsWidgets);
    expect(find.text('Leave'), findsWidgets);
    expect(find.text('Timelogs Correction'), findsWidgets);
    expect(find.text('Approved'), findsWidgets);

    // 5. Tap Payslip tab
    await tester.tap(find.text('Payslip'));
    await tester.pumpAndSettle();
    expect(find.text('Amount of Net Pay'), findsOneWidget);
    expect(find.text('Amount of Gross Pay'), findsOneWidget);
    expect(find.text('Total Deduction'), findsOneWidget);
    expect(find.text('Payroll Breakdown'), findsOneWidget);
    expect(find.text('Payroll Detail'), findsOneWidget);
    // Default detail is empty select
    expect(find.text('Total Basic Pay'), findsNothing);

    // Open Cut-off calendar popup anchored below input
    await tester.tap(find.text('Oct-01-2026 – Oct-15-2026'));
    await tester.pumpAndSettle();
    expect(find.text('OCT'), findsOneWidget);
    // Tap custom range (Day 1, then Day 15) and Apply to select cutoff and close
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    // Select Basic Pay from dropdown to display table
    final detailDropdown = find.text('Select detail category');
    await tester.ensureVisible(detailDropdown);
    await tester.tap(detailDropdown, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Basic Pay').last);
    await tester.pumpAndSettle();
    expect(find.text('Total Basic Pay'), findsOneWidget);

    // Tap Clear > to clear detail table
    final clearBtn = find.text('Clear >');
    await tester.ensureVisible(clearBtn);
    await tester.tap(clearBtn);
    await tester.pumpAndSettle();
    expect(find.text('Total Basic Pay'), findsNothing);

    // 6. Tap Personal tab
    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();
    expect(find.text(MockProfileData.profile.fullName), findsAtLeastNWidgets(1));
    expect(find.text('Employee Information'), findsOneWidget);
    expect(find.text('Emergency Information'), findsOneWidget);

    // Tap Tab 1 (Work)
    await tester.tap(find.byIcon(Icons.work));
    await tester.pumpAndSettle();
    expect(find.text('Employment Information'), findsOneWidget);
    expect(find.text('Allowances'), findsOneWidget);
    expect(find.text('Entitlements'), findsOneWidget);

    // Tap Tab 2 (Leave)
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    expect(find.text('Leave Status'), findsOneWidget);
    expect(find.text('Contribution Info'), findsOneWidget);

    // Tap Tab 3 (Loans & Deductions)
    await tester.tap(find.byIcon(Icons.account_balance));
    await tester.pumpAndSettle();
    expect(find.text('Loan Information'), findsOneWidget);
    expect(find.text('Deductions'), findsOneWidget);

    // 7. Verify See work schedule navigation
    await tester.tap(find.text('See work schedule >'));
    await tester.pumpAndSettle();
    expect(find.text('Work Schedule'), findsOneWidget);
    expect(find.text('Work Shift Schedule'), findsOneWidget);
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text('Regular Shift'), findsOneWidget);
    expect(find.text('08:00 – 18:00 [ 9.5 hrs. ]'), findsOneWidget);

    // Tap Oct 21 (Night Shift)
    await tester.tap(find.text('21').first);
    await tester.pumpAndSettle();
    expect(find.text('Night Shift'), findsOneWidget);
    expect(find.text('19:00 – 04:00 [ 8.0 hrs. ]'), findsOneWidget);

    // Tap Oct 29 (Full Day Leave)
    await tester.tap(find.text('29').last);
    await tester.pumpAndSettle();
    expect(find.text('Leave For Full Day'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);

    // Tap Oct 30 (Half Day Leave - no () text)
    await tester.tap(find.text('30').last);
    await tester.pumpAndSettle();
    expect(find.text('Leave For Half Day'), findsOneWidget);
    expect(find.text('[ 4.8 hrs. ]'), findsOneWidget);
    expect(find.textContaining('()'), findsNothing);

    // Tap Oct 15 (15 backwards = other cut-offs)
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    expect(find.text('Other Cut-offs'), findsOneWidget);
    expect(find.text('08:00 – 17:00 [ 8.0 hrs. ]'), findsOneWidget);

    // Navigate to future date: November 2026
    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pumpAndSettle();
    expect(find.text('November 2026'), findsOneWidget);
    // Tap Nov 2 (weekday in future month = other cut-offs)
    await tester.tap(find.text('2').first);
    await tester.pumpAndSettle();
    expect(find.text('Other Cut-offs'), findsOneWidget);

    // Back to October 2026
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    // Back to Personal screen
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text(MockProfileData.profile.fullName), findsAtLeastNWidgets(1));
  });
}
