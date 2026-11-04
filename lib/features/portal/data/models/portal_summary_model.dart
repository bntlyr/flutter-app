import '../../domain/entities/portal_summary_entity.dart';

class PortalSummaryModel extends PortalSummaryEntity {
  const PortalSummaryModel({
    required super.employeeName,
    required super.date,
    super.timeIn,
    super.timeOut,
    super.basicPay,
    super.netPay,
  });

  factory PortalSummaryModel.fromJson(Map<String, dynamic> json) {
    return PortalSummaryModel(
      employeeName: json['employeeName'] as String? ?? '',
      date: json['date'] as String? ?? '',
      timeIn: json['timeIn'] as String?,
      timeOut: json['timeOut'] as String?,
      basicPay: (json['basicPay'] as num?)?.toDouble() ?? 0.0,
      netPay: (json['netPay'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeName': employeeName,
      'date': date,
      'timeIn': timeIn,
      'timeOut': timeOut,
      'basicPay': basicPay,
      'netPay': netPay,
    };
  }
}
