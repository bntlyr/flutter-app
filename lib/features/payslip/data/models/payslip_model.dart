import '../../domain/entities/payslip_entity.dart';

class PayslipModel extends PayslipEntity {
  const PayslipModel({
    required super.cutoff,
    required super.netPay,
    required super.totalGross,
    required super.totalDeductions,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      cutoff: json['cutoff'] as String? ?? '',
      netPay: (json['netPay'] as num?)?.toDouble() ?? 0.0,
      totalGross: (json['totalGross'] as num?)?.toDouble() ?? 0.0,
      totalDeductions: (json['totalDeductions'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cutoff': cutoff,
      'netPay': netPay,
      'totalGross': totalGross,
      'totalDeductions': totalDeductions,
    };
  }
}
