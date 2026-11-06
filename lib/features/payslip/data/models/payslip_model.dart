import '../../domain/entities/payslip_entity.dart';
import '../graphql/__generated__/payslip.graphql.dart';

export '../../domain/entities/payslip_entity.dart';

class PayslipModel extends PayslipEntity {
  const PayslipModel({
    required super.cutoff,
    super.cutoffId = '',
    required super.netPay,
    required super.totalGross,
    required super.totalDeductions,
    super.irregularAdjustment = 0.0,
    super.againstNetpay = 0.0,
    super.againstGrosspay = 0.0,
    super.againstDeduction = 0.0,
    super.againstIrregular = 0.0,
    super.payrollAgreement = 'Monthly Basis',
    super.dailyRate = 0.0,
    super.hourlyRate = 0.0,
    super.basicPay = 0.0,
    super.compensation = 0.0,
    super.allowanceTaxable = 0.0,
    super.punctuality = 0.0,
    super.contribution = 0.0,
    super.totalTaxableIncome = 0.0,
    super.tax = 0.0,
    super.afterTaxIncome = 0.0,
    super.allowanceNonTaxable = 0.0,
    super.otherBenefit = 0.0,
    super.loanRepayment = 0.0,
    super.sss = 0.0,
    super.providentFund = 0.0,
    super.phic = 0.0,
    super.hdmf = 0.0,
    super.workDays = 0.0,
    super.leaveCount = 0.0,
    super.adjustment = 0.0,
    super.taxSettlement = 0.0,
    super.loanItems = const [],
    super.allowanceItems = const [],
    super.totalAllowance = 0.0,
    super.overtimeHours = const {},
    super.overtimeAmounts = const {},
    super.overtimeAdjustment = 0.0,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      cutoff: json['cutoff'] as String? ?? '',
      cutoffId: json['cutoffId']?.toString() ?? '',
      netPay: (json['netPay'] as num?)?.toDouble() ?? 0.0,
      totalGross: (json['totalGross'] as num?)?.toDouble() ?? 0.0,
      totalDeductions: (json['totalDeductions'] as num?)?.toDouble() ?? 0.0,
      irregularAdjustment: (json['irregularAdjustment'] as num?)?.toDouble() ?? 0.0,
      againstNetpay: (json['againstNetpay'] as num?)?.toDouble() ?? 0.0,
      againstGrosspay: (json['againstGrosspay'] as num?)?.toDouble() ?? 0.0,
      dailyRate: (json['dailyRate'] as num?)?.toDouble() ?? 0.0,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      basicPay: (json['basicPay'] as num?)?.toDouble() ?? 0.0,
      compensation: (json['compensation'] as num?)?.toDouble() ?? 0.0,
      allowanceTaxable: (json['allowanceTaxable'] as num?)?.toDouble() ?? 0.0,
      punctuality: (json['punctuality'] as num?)?.toDouble() ?? 0.0,
      contribution: (json['contribution'] as num?)?.toDouble() ?? 0.0,
      totalTaxableIncome: (json['totalTaxableIncome'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      afterTaxIncome: (json['afterTaxIncome'] as num?)?.toDouble() ?? 0.0,
      allowanceNonTaxable: (json['allowanceNonTaxable'] as num?)?.toDouble() ?? 0.0,
      otherBenefit: (json['otherBenefit'] as num?)?.toDouble() ?? 0.0,
      loanRepayment: (json['loanRepayment'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PayslipModelMapper {
  static PayslipEntity fromDetail(
    Query$PayrollDetail$payroll payroll, {
    Query$PayrollDetail$payroll? prevPayroll,
    String? cutoffLabel,
    String? cutoffId,
    List<PayslipAllowanceItem>? allowanceItems,
    Map<String, double>? overtimeHours,
    Map<String, double>? overtimeAmounts,
    double? overtimeAdjustment,
  }) {
    final basicPay = (payroll.basicPay as num?)?.toDouble() ?? 0.0;
    final overtime = (payroll.overtime as num?)?.toDouble() ?? 0.0;
    final taxableAllowance = (payroll.taxableAllowance as num?)?.toDouble() ?? 0.0;
    final allowance = (payroll.allowance as num?)?.toDouble() ?? 0.0;
    final late = (payroll.late as num?)?.toDouble() ?? 0.0;

    final sss = (payroll.sss as num?)?.toDouble() ?? 0.0;
    final providentFund = (payroll.providentFund as num?)?.toDouble() ?? 0.0;
    final phic = (payroll.phic as num?)?.toDouble() ?? 0.0;
    final hdmf = (payroll.hdmf as num?)?.toDouble() ?? 0.0;
    final contribution = sss + providentFund + phic + hdmf;

    final totalTaxableIncome = (basicPay + overtime + taxableAllowance) - (late + contribution);
    final totalWht = (payroll.totalWht as num?)?.toDouble() ?? 0.0;
    final afterTaxIncome = totalTaxableIncome - totalWht;

    final separationPay = (payroll.separationPay as num?)?.toDouble() ?? 0.0;
    final adjustment = (payroll.adjustment as num?)?.toDouble() ?? 0.0;
    final taxSettlement = (payroll.taxSettlement as num?)?.toDouble() ?? 0.0;
    final irregularAdjustment = adjustment + taxSettlement;

    final List<PayslipDeductionItem> loanItems = [];
    double loanRepayment = 0.0;
    if (payroll.deductions is List) {
      for (final item in payroll.deductions as List) {
        if (item is Map) {
          final type = item['type']?.toString() ?? '';
          final label = item['label']?.toString() ?? '';
          final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
          if (type == 'Loan') {
            loanRepayment += amount;
          }
          loanItems.add(PayslipDeductionItem(label: label, type: type, amount: amount));
        }
      }
    }

    final totalAllowance = taxableAllowance + allowance;
    final List<PayslipAllowanceItem> effectiveAllowanceItems = (allowanceItems != null && allowanceItems.isNotEmpty)
        ? allowanceItems
        : const [];

    final grossPay = basicPay + overtime + taxableAllowance + allowance - late;
    final totalDeductions = contribution + totalWht + loanRepayment;
    final netPay = (payroll.netPay as num?)?.toDouble() ??
        (grossPay - totalDeductions + irregularAdjustment);

    final salaryType = payroll.salaryType ?? payroll.info?.salaryType ?? 'month';
    final isDaily = salaryType == 'day';
    double dailyRate = 0.0;
    double hourlyRate = 0.0;

    if (isDaily) {
      dailyRate = (payroll.rate as num?)?.toDouble() ?? 0.0;
      hourlyRate = dailyRate / 8;
    } else {
      double companyRate = 26.16666666666667;
      final companyMeta = payroll.info?.user.company.metadata;
      if (companyMeta is Map && companyMeta['setting'] is Map) {
        final setting = companyMeta['setting'] as Map;
        final r = (setting['rate'] as num?)?.toDouble();
        if (r != null && r > 0) companyRate = r;
      }
      dailyRate = (basicPay * 2) / companyRate;
      hourlyRate = dailyRate / 8;
    }

    double againstNetpay = 0.0;
    double againstGrosspay = 0.0;
    if (prevPayroll != null) {
      final prevNet = (prevPayroll.netPay as num?)?.toDouble() ?? 0.0;
      if (prevNet > 0) {
        againstNetpay = ((netPay - prevNet) / prevNet) * 100;
      }
      final prevGross = ((prevPayroll.basicPay as num?)?.toDouble() ?? 0.0) +
          ((prevPayroll.overtime as num?)?.toDouble() ?? 0.0) +
          ((prevPayroll.taxableAllowance as num?)?.toDouble() ?? 0.0) +
          ((prevPayroll.allowance as num?)?.toDouble() ?? 0.0) -
          ((prevPayroll.late as num?)?.toDouble() ?? 0.0);
      if (prevGross > 0) {
        againstGrosspay = ((grossPay - prevGross) / prevGross) * 100;
      }
    }

    return PayslipEntity(
      cutoff: cutoffLabel ?? 'N/A',
      cutoffId: cutoffId ?? payroll.cutOffId.toString(),
      netPay: netPay,
      totalGross: grossPay,
      totalDeductions: totalDeductions,
      irregularAdjustment: irregularAdjustment,
      againstNetpay: againstNetpay,
      againstGrosspay: againstGrosspay,
      againstDeduction: 0.0,
      againstIrregular: 0.0,
      payrollAgreement: isDaily ? 'Daily Basis' : 'Monthly Basis',
      dailyRate: dailyRate,
      hourlyRate: hourlyRate,
      basicPay: basicPay,
      compensation: overtime,
      allowanceTaxable: taxableAllowance,
      punctuality: late,
      contribution: contribution,
      totalTaxableIncome: totalTaxableIncome,
      tax: totalWht,
      afterTaxIncome: afterTaxIncome,
      allowanceNonTaxable: allowance,
      otherBenefit: separationPay,
      loanRepayment: loanRepayment,
      sss: sss,
      providentFund: providentFund,
      phic: phic,
      hdmf: hdmf,
      workDays: (payroll.workDays as num?)?.toDouble() ?? 0.0,
      leaveCount: (payroll.leaveCount as num?)?.toDouble() ?? 0.0,
      adjustment: adjustment,
      taxSettlement: taxSettlement,
      loanItems: loanItems,
      allowanceItems: effectiveAllowanceItems,
      totalAllowance: totalAllowance,
      overtimeHours: overtimeHours ?? const {},
      overtimeAmounts: overtimeAmounts ?? const {},
      overtimeAdjustment: overtimeAdjustment ?? 0.0,
    );
  }
}
