enum ShiftClassification {
  regular,
  night,
  leaveFull,
  leaveHalf,
  otherCutOffs,
  restDay,
}

class ShiftDayData {
  final DateTime date;
  final bool isCurrentMonth;
  final ShiftClassification classification;
  final String title;
  final String timeRange;

  const ShiftDayData({
    required this.date,
    required this.isCurrentMonth,
    required this.classification,
    required this.title,
    required this.timeRange,
  });
}
