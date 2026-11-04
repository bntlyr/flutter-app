class PayslipEntity {
  final String cutoff;
  final double netPay;
  final double totalGross;
  final double totalDeductions;

  const PayslipEntity({
    required this.cutoff,
    required this.netPay,
    required this.totalGross,
    required this.totalDeductions,
  });
}
