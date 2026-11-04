/// Domain entity for Dashboard attendance summary.
class Attendance {
  final int approvedRequests;
  final double absent;
  final double lateHrs;
  final double undertimeHrs;
  final double allowance;

  const Attendance({
    required this.approvedRequests,
    required this.absent,
    required this.lateHrs,
    required this.undertimeHrs,
    required this.allowance,
  });
}
