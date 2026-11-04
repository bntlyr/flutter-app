/// DTR Domain Entity representation.
class DtrDayEntity {
  final DateTime date;
  final String? timeIn;
  final String? timeOut;
  final bool isAbsent;
  final double? lateHours;
  final double? undertimeHours;

  const DtrDayEntity({
    required this.date,
    this.timeIn,
    this.timeOut,
    this.isAbsent = false,
    this.lateHours,
    this.undertimeHours,
  });
}

class DtrCutoffEntity {
  final String cutoffLabel;
  final int totalApprovedRequests;
  final double totalAbsent;
  final double totalLateHrs;
  final double totalUndertimeHrs;
  final double totalAllowance;
  final List<DtrDayEntity> days;

  const DtrCutoffEntity({
    required this.cutoffLabel,
    required this.totalApprovedRequests,
    required this.totalAbsent,
    required this.totalLateHrs,
    required this.totalUndertimeHrs,
    required this.totalAllowance,
    required this.days,
  });
}
