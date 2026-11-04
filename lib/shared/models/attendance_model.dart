enum AlertSeverity { low, medium, high }

class AttendanceAlert {
  final String id;
  final DateTime date;
  final String title;
  final String alertType;
  final String timeDetail;
  final AlertSeverity severity;
  final String recommendedAction;

  const AttendanceAlert({
    required this.id,
    required this.date,
    required this.title,
    required this.alertType,
    required this.timeDetail,
    required this.severity,
    required this.recommendedAction,
  });
}

class AttendanceSummary {
  final int presentDays;
  final int totalWorkDays;
  final int lateCount;
  final int lateMinutes;
  final double overtimeHours;
  final double leaveCreditsRemaining;
  final int absentCount;

  const AttendanceSummary({
    required this.presentDays,
    required this.totalWorkDays,
    required this.lateCount,
    required this.lateMinutes,
    required this.overtimeHours,
    required this.leaveCreditsRemaining,
    required this.absentCount,
  });
}

enum DtrStatus {
  normal,
  tardy,
  undertime,
  overtime,
  restDay,
  onLeave,
  missingPunch,
  holiday,
}

class DtrDayRecord {
  final DateTime date;
  final String dayOfWeek;
  final String shiftSchedule;
  final String? timeIn;
  final String? timeOut;
  final double regularHours;
  final double overtimeHours;
  final int lateMinutes;
  final int undertimeMinutes;
  final DtrStatus status;
  final String remarks;

  const DtrDayRecord({
    required this.date,
    required this.dayOfWeek,
    required this.shiftSchedule,
    this.timeIn,
    this.timeOut,
    required this.regularHours,
    required this.overtimeHours,
    required this.lateMinutes,
    required this.undertimeMinutes,
    required this.status,
    required this.remarks,
  });
}

class CutoffPeriod {
  final String id;
  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime payoutDate;

  const CutoffPeriod({
    required this.id,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.payoutDate,
  });
}
