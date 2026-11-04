class PortalSummaryEntity {
  final String employeeName;
  final String date;
  final String? timeIn;
  final String? timeOut;
  final double basicPay;
  final double netPay;

  const PortalSummaryEntity({
    required this.employeeName,
    required this.date,
    this.timeIn,
    this.timeOut,
    this.basicPay = 0.0,
    this.netPay = 0.0,
  });
}
