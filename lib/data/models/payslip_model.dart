enum PayrollCategory {
  basicPayCompensation,
  allowance,
  otherBenefit,
  punctuality,
  contribution,
  loanRepayment,
  tax,
  irregularAdjustment,
}

extension PayrollCategoryExtension on PayrollCategory {
  String get displayName {
    switch (this) {
      case PayrollCategory.basicPayCompensation:
        return 'Basic Pay Compensation';
      case PayrollCategory.allowance:
        return 'Allowance';
      case PayrollCategory.otherBenefit:
        return 'Other Benefit';
      case PayrollCategory.punctuality:
        return 'Punctuality';
      case PayrollCategory.contribution:
        return 'Contribution';
      case PayrollCategory.loanRepayment:
        return 'Loan Repayment';
      case PayrollCategory.tax:
        return 'Tax';
      case PayrollCategory.irregularAdjustment:
        return 'Irregular Adjustment';
    }
  }
}

class PayrollLineItem {
  final String description;
  final String basis; // e.g., "11 days @ $120.00" or "Monthly standard"
  final double employerShare;
  final double employeeAmount;
  final bool isDeduction;

  const PayrollLineItem({
    required this.description,
    required this.basis,
    this.employerShare = 0.0,
    required this.employeeAmount,
    this.isDeduction = false,
  });
}

class PayslipCutoffData {
  final String cutoffId;
  final String cutoffLabel;
  final String payoutDateStr;
  final double grossPay;
  final double totalDeductions;
  final double netPay;
  final double irregularAdjustment;
  final String employeeName;
  final String employeeId;
  final String department;
  final String paymentReference;
  final Map<PayrollCategory, List<PayrollLineItem>> categoryBreakdown;

  const PayslipCutoffData({
    required this.cutoffId,
    required this.cutoffLabel,
    required this.payoutDateStr,
    required this.grossPay,
    required this.totalDeductions,
    required this.netPay,
    required this.irregularAdjustment,
    required this.employeeName,
    required this.employeeId,
    required this.department,
    required this.paymentReference,
    required this.categoryBreakdown,
  });
}

class PayrollSummaryItem {
  final String cutoffId;
  final String cutoffPeriod;
  final double grossPay;
  final double deductions;
  final double netPay;
  final String payoutDate;
  final String status;

  const PayrollSummaryItem({
    required this.cutoffId,
    required this.cutoffPeriod,
    required this.grossPay,
    required this.deductions,
    required this.netPay,
    required this.payoutDate,
    required this.status,
  });
}
