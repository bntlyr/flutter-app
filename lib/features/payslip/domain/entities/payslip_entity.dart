class CutoffOptionEntity {
  final String id;
  final String payrollPeriod;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final int status;
  final bool isApproved;

  const CutoffOptionEntity({
    required this.id,
    required this.payrollPeriod,
    this.timeStart,
    this.timeEnd,
    this.status = 0,
    this.isApproved = false,
  });
}

class PayslipDeductionItem {
  final String label;
  final String type;
  final double amount;

  const PayslipDeductionItem({
    required this.label,
    required this.type,
    required this.amount,
  });
}

class PayslipAllowanceItem {
  final String label;
  final String acquisitionType;
  final double amount;

  const PayslipAllowanceItem({
    required this.label,
    required this.acquisitionType,
    required this.amount,
  });
}

class PayslipEntity {
  final String cutoff;
  final String cutoffId;
  final double netPay;
  final double totalGross;
  final double totalDeductions;
  final double irregularAdjustment;
  final double againstNetpay;
  final double againstGrosspay;
  final double againstDeduction;
  final double againstIrregular;
  final String payrollAgreement;
  final double dailyRate;
  final double hourlyRate;
  final double basicPay;
  final double compensation;
  final double allowanceTaxable;
  final double punctuality;
  final double contribution;
  final double totalTaxableIncome;
  final double tax;
  final double afterTaxIncome;
  final double allowanceNonTaxable;
  final double otherBenefit;
  final double loanRepayment;
  final double sss;
  final double providentFund;
  final double phic;
  final double hdmf;
  final double workDays;
  final double leaveCount;
  final double adjustment;
  final double taxSettlement;
  final List<PayslipDeductionItem> loanItems;
  final List<PayslipAllowanceItem> allowanceItems;
  final double totalAllowance;
  final Map<String, double> overtimeHours;
  final Map<String, double> overtimeAmounts;
  final double overtimeAdjustment;

  const PayslipEntity({
    required this.cutoff,
    this.cutoffId = '',
    required this.netPay,
    required this.totalGross,
    required this.totalDeductions,
    this.irregularAdjustment = 0.0,
    this.againstNetpay = 0.0,
    this.againstGrosspay = 0.0,
    this.againstDeduction = 0.0,
    this.againstIrregular = 0.0,
    this.payrollAgreement = 'Monthly Basis',
    this.dailyRate = 0.0,
    this.hourlyRate = 0.0,
    this.basicPay = 0.0,
    this.compensation = 0.0,
    this.allowanceTaxable = 0.0,
    this.punctuality = 0.0,
    this.contribution = 0.0,
    this.totalTaxableIncome = 0.0,
    this.tax = 0.0,
    this.afterTaxIncome = 0.0,
    this.allowanceNonTaxable = 0.0,
    this.otherBenefit = 0.0,
    this.loanRepayment = 0.0,
    this.sss = 0.0,
    this.providentFund = 0.0,
    this.phic = 0.0,
    this.hdmf = 0.0,
    this.workDays = 0.0,
    this.leaveCount = 0.0,
    this.adjustment = 0.0,
    this.taxSettlement = 0.0,
    this.loanItems = const [],
    this.allowanceItems = const [],
    this.totalAllowance = 0.0,
    this.overtimeHours = const {},
    this.overtimeAmounts = const {},
    this.overtimeAdjustment = 0.0,
  });

  /// Default empty entity when no record exists.
  factory PayslipEntity.empty([String? cutoff, String? cutoffId]) {
    return PayslipEntity(
      cutoff: cutoff ?? 'N/A',
      cutoffId: cutoffId ?? '',
      netPay: 0.0,
      totalGross: 0.0,
      totalDeductions: 0.0,
      irregularAdjustment: 0.0,
      againstNetpay: 0.0,
      againstGrosspay: 0.0,
      againstDeduction: 0.0,
      againstIrregular: 0.0,
      payrollAgreement: 'N/A',
      dailyRate: 0.0,
      hourlyRate: 0.0,
      basicPay: 0.0,
      compensation: 0.0,
      allowanceTaxable: 0.0,
      punctuality: 0.0,
      contribution: 0.0,
      totalTaxableIncome: 0.0,
      tax: 0.0,
      afterTaxIncome: 0.0,
      allowanceNonTaxable: 0.0,
      otherBenefit: 0.0,
      loanRepayment: 0.0,
      sss: 0.0,
      providentFund: 0.0,
      phic: 0.0,
      hdmf: 0.0,
      workDays: 0.0,
      leaveCount: 0.0,
      adjustment: 0.0,
      taxSettlement: 0.0,
      loanItems: const [],
      allowanceItems: const [],
      totalAllowance: 0.0,
      overtimeHours: const {},
      overtimeAmounts: const {},
      overtimeAdjustment: 0.0,
    );
  }
}
