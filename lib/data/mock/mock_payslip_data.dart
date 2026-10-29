import '../models/payslip_model.dart';

class MockPayslipData {
  static final List<PayrollSummaryItem> payrollSummaryList = [
    const PayrollSummaryItem(
      cutoffId: 'CO-2026-10-B',
      cutoffPeriod: 'Oct 11 – Oct 25, 2026',
      grossPay: 4150.00,
      deductions: 700.00,
      netPay: 3450.00,
      payoutDate: 'Oct 30, 2026',
      status: 'Ready',
    ),
    const PayrollSummaryItem(
      cutoffId: 'CO-2026-10-A',
      cutoffPeriod: 'Sep 26 – Oct 10, 2026',
      grossPay: 4100.00,
      deductions: 680.00,
      netPay: 3420.00,
      payoutDate: 'Oct 15, 2026',
      status: 'Paid',
    ),
    const PayrollSummaryItem(
      cutoffId: 'CO-2026-09-B',
      cutoffPeriod: 'Sep 11 – Sep 25, 2026',
      grossPay: 4050.00,
      deductions: 660.00,
      netPay: 3390.00,
      payoutDate: 'Sep 30, 2026',
      status: 'Paid',
    ),
  ];

  static final Map<String, PayslipCutoffData> cutoffPayslips = {
    'CO-2026-10-B': PayslipCutoffData(
      cutoffId: 'CO-2026-10-B',
      cutoffLabel: 'Oct 11 – Oct 25, 2026',
      payoutDateStr: 'Friday, Oct 30, 2026',
      grossPay: 4150.00,
      totalDeductions: 700.00,
      netPay: 3450.00,
      irregularAdjustment: 120.00,
      employeeName: 'Alex Morgan',
      employeeId: '#84920',
      department: 'Software Engineering',
      paymentReference: 'PAY-202610-84920-X1',
      categoryBreakdown: {
        PayrollCategory.basicPayCompensation: [
          const PayrollLineItem(
            description: 'Regular Basic Pay',
            basis: '11 Days Worked @ ₱320.00/day',
            employerShare: 0.0,
            employeeAmount: 3520.00,
          ),
          const PayrollLineItem(
            description: 'Overtime Pay (Regular Working Days)',
            basis: '4.5 hrs @ ₱25.00/hr (125% rate)',
            employerShare: 0.0,
            employeeAmount: 140.63,
          ),
          const PayrollLineItem(
            description: 'Paid Holiday Differential',
            basis: '1 General Public Holiday',
            employerShare: 0.0,
            employeeAmount: 320.00,
          ),
        ],
        PayrollCategory.allowance: [
          const PayrollLineItem(
            description: 'De Minimis Rice Subsidy',
            basis: 'Cutoff Non-taxable Standard',
            employerShare: 0.0,
            employeeAmount: 100.00,
          ),
          const PayrollLineItem(
            description: 'Internet & Remote Work Stipend',
            basis: 'Bi-monthly Allocation',
            employerShare: 0.0,
            employeeAmount: 85.00,
          ),
          const PayrollLineItem(
            description: 'Transportation Allowance',
            basis: 'Onsite duty reimbursement',
            employerShare: 0.0,
            employeeAmount: 45.00,
          ),
        ],
        PayrollCategory.otherBenefit: [
          const PayrollLineItem(
            description: 'Quarterly Tech Sprint Incentive',
            basis: 'Sprint 34 KPI Achievement',
            employerShare: 0.0,
            employeeAmount: 150.00,
          ),
          const PayrollLineItem(
            description: '13th Month Pro-rata Accrual',
            basis: 'Information Only (Year-end payout)',
            employerShare: 293.33,
            employeeAmount: 0.0,
          ),
        ],
        PayrollCategory.punctuality: [
          const PayrollLineItem(
            description: 'Punctuality & Perfect Attendance Reward',
            basis: 'Zero unexcused absence milestone',
            employerShare: 0.0,
            employeeAmount: 50.00,
          ),
          const PayrollLineItem(
            description: 'Tardiness Salary Deduction',
            basis: '14 minutes late @ ₱0.66/min',
            employerShare: 0.0,
            employeeAmount: 9.24,
            isDeduction: true,
          ),
        ],
        PayrollCategory.contribution: [
          const PayrollLineItem(
            description: 'Social Security / SSS Mandate',
            basis: 'Statutory Tier Ceiling',
            employerShare: 190.00,
            employeeAmount: 95.00,
            isDeduction: true,
          ),
          const PayrollLineItem(
            description: 'National Health Insurance / PhilHealth',
            basis: '5% shared equally',
            employerShare: 80.00,
            employeeAmount: 80.00,
            isDeduction: true,
          ),
          const PayrollLineItem(
            description: 'Housing Mutual Fund / Pag-IBIG',
            basis: 'Government standard contribution',
            employerShare: 50.00,
            employeeAmount: 50.00,
            isDeduction: true,
          ),
        ],
        PayrollCategory.loanRepayment: [
          const PayrollLineItem(
            description: 'Company Computer Salary Loan',
            basis: 'Amortization 06 of 12',
            employerShare: 0.0,
            employeeAmount: 125.00,
            isDeduction: true,
          ),
          const PayrollLineItem(
            description: 'Housing Fund Multipurpose Loan',
            basis: 'Installment 14 of 24',
            employerShare: 0.0,
            employeeAmount: 75.00,
            isDeduction: true,
          ),
        ],
        PayrollCategory.tax: [
          const PayrollLineItem(
            description: 'Withholding Income Tax (BIR / IRS)',
            basis: 'Graduated Tax Table (Semi-monthly bracket)',
            employerShare: 0.0,
            employeeAmount: 265.76,
            isDeduction: true,
          ),
        ],
        PayrollCategory.irregularAdjustment: [
          const PayrollLineItem(
            description: 'Retroactive Salary Grade Adjustment',
            basis: 'Q3 Merit revision discrepancy',
            employerShare: 0.0,
            employeeAmount: 120.00,
          ),
        ],
      },
    ),
  };
}
