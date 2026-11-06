import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/payslip/presentation/components/payslip_breakdown_tables.dart';
import 'package:flutter_app/features/payslip/domain/repositories/payslip_repository.dart';
import 'package:flutter_app/features/payslip/domain/usecases/get_payslip_usecase.dart';
import 'package:flutter_app/features/payslip/presentation/viewmodels/payslip_viewmodel.dart';
import 'package:flutter_app/features/payslip/data/models/payslip_model.dart';
import 'package:flutter_app/features/payslip/data/graphql/__generated__/payslip.graphql.dart';

class MockPayslipRepository implements PayslipRepository {
  final PayslipEntity Function({String? cutoffId, String? cutoffText}) payslipHandler;
  final List<CutoffOptionEntity> cutoffs;

  MockPayslipRepository({
    required this.payslipHandler,
    this.cutoffs = const [],
  });

  @override
  Future<PayslipEntity> getPayslip({String? cutoffId, String? cutoffText}) async {
    return payslipHandler(cutoffId: cutoffId, cutoffText: cutoffText);
  }

  @override
  Future<List<CutoffOptionEntity>> getCutoffs() async {
    return cutoffs;
  }
}

void main() {
  group('Payslip Clean Architecture Tests', () {
    test(r'PayslipModelMapper correctly maps DB Query$PayrollDetail$payroll with rates and previous cutoff', () {
      final mockPayroll = Query$PayrollDetail$payroll(
        id: '3134',
        userId: '42b46a93-93d8-4ba7-b660-43d5d4aa5f14',
        cutOffId: 34,
        basicPay: 24068.25,
        gross: 38726.66,
        taxableAllowance: 14658.41,
        allowance: 0.0,
        overtime: 0.0,
        late: 0.0,
        sss: 1000.0,
        providentFund: 200.0,
        phic: 601.71,
        hdmf: 0.0,
        totalWht: 5168.69,
        netPay: 31756.26,
        salaryType: 'month',
        workDays: 11.0,
        leaveCount: 0.0,
        holidayCount: 0.0,
        info: Query$PayrollDetail$payroll$info(
          id: 'info-1',
          userId: '42b46a93-93d8-4ba7-b660-43d5d4aa5f14',
          firstName: 'Juan',
          lastName: 'Dela Cruz',
          basicSalary: 24068.25,
          user: Query$PayrollDetail$payroll$info$user(
            id: 'u-1',
            name: 'Juan Dela Cruz',
            company: Query$PayrollDetail$payroll$info$user$company(
              id: 'c-1',
              metadata: {
                'setting': {
                  'rate': 26.16666666666667,
                  'dailyHours': 8,
                }
              },
            ),
          ),
        ),
      );

      final prevPayroll = Query$PayrollDetail$payroll(
        id: '3000',
        userId: '42b46a93-93d8-4ba7-b660-43d5d4aa5f14',
        cutOffId: 33,
        basicPay: 24068.25,
        netPay: 32243.13,
      );

      final payslip = PayslipModelMapper.fromDetail(
        mockPayroll,
        prevPayroll: prevPayroll,
        cutoffLabel: 'APR-01-26 - APR-15-26',
        cutoffId: '34',
      );

      expect(payslip.cutoff, 'APR-01-26 - APR-15-26');
      expect(payslip.cutoffId, '34');
      expect(payslip.netPay, 31756.26);
      expect(payslip.totalGross, 38726.66);
      expect(payslip.basicPay, 24068.25);
      expect(payslip.allowanceTaxable, 14658.41);
      expect(payslip.tax, 5168.69);
      expect(payslip.contribution, 1801.71);
      expect(payslip.totalDeductions, 6970.40);
      expect(payslip.dailyRate, closeTo(1839.61, 0.01));
      expect(payslip.hourlyRate, closeTo(229.95, 0.01));
      expect(payslip.againstNetpay, closeTo(-1.51, 0.01));
    });

    test('PayslipViewModel loads dynamically from repository without hardcoding', () async {
      final cutoffs = [
        const CutoffOptionEntity(
          id: '34',
          payrollPeriod: 'APR-01-26 - APR-15-26',
          status: 4,
          isApproved: true,
        ),
        const CutoffOptionEntity(
          id: '33',
          payrollPeriod: 'MAR-16-26 - MAR-31-26',
          status: 4,
          isApproved: true,
        ),
      ];

      final repo = MockPayslipRepository(
        cutoffs: cutoffs,
        payslipHandler: ({cutoffId, cutoffText}) {
          if (cutoffId == '34' || cutoffText == 'APR-01-26 - APR-15-26') {
            return const PayslipEntity(
              cutoff: 'APR-01-26 - APR-15-26',
              cutoffId: '34',
              netPay: 31756.26,
              totalGross: 38726.66,
              totalDeductions: 6970.40,
              basicPay: 24068.25,
            );
          }
          return PayslipEntity.empty(cutoffText);
        },
      );

      final viewModel = PayslipViewModel(
        getPayslipUseCase: GetPayslipUseCase(repo),
      );

      expect(viewModel.isLoading, false);
      expect(viewModel.payslip, null);

      await viewModel.initialize(initialCutoff: 'APR-01-26 - APR-15-26');

      expect(viewModel.isLoading, false);
      expect(viewModel.availableCutoffs.length, 2);
      expect(viewModel.payslip?.netPay, 31756.26);
      expect(viewModel.payslip?.totalGross, 38726.66);
      expect(viewModel.selectedCutoffText, 'APR-01-26 - APR-15-26');

      await viewModel.selectCutoff('MAR-16-26 - MAR-31-26', '33');
      expect(viewModel.selectedCutoffId, '33');
    });

    testWidgets('PayslipBreakdownTables renders all detailed compensation rows and section headers even when zero', (tester) async {
      final entity = const PayslipEntity(
        cutoff: 'Oct-01-2026 – Oct-15-2026',
        netPay: 18500.0,
        totalGross: 18500.0,
        totalDeductions: 0.0,
        hourlyRate: 176.75,
        compensation: 220.94,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PayslipBreakdownTables(
                option: PayrollDetailOption.compensation,
                payslip: entity,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Regular Holidays Pay'), findsOneWidget);
      expect(find.text('For Regular'), findsOneWidget);
      expect(find.text('Rest And Holidays Pay - Daytime'), findsOneWidget);
      expect(find.text('Rest Day'), findsWidgets);
      expect(find.text('Special Holiday'), findsWidgets);
      expect(find.text('Special Holiday & Rest Day'), findsWidgets);
      expect(find.text('For Legal'), findsOneWidget);
      expect(find.text('Legal Holiday & Rest Day'), findsWidgets);
      expect(find.text('Overtime And Excess Pay - Daytime'), findsOneWidget);
      expect(find.text('Overtime'), findsOneWidget);
      expect(find.text('Night Differential Pay'), findsOneWidget);
      expect(find.text('Rest And Holidays Pay - ND'), findsOneWidget);
      expect(find.text('Overtime And Excess Pay - ND'), findsOneWidget);
      expect(find.text('Adjustment'), findsOneWidget);
      expect(find.text('Adjustment for Compensation'), findsOneWidget);
      expect(find.text('Total Compensation'), findsOneWidget);
      expect(find.text('Php 220.94'), findsOneWidget);
    });
  });
}
