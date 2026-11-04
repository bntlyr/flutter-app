import '../../domain/entities/attendance.dart';

/// Data transfer model for Attendance with serialization.
class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.approvedRequests,
    required super.absent,
    required super.lateHrs,
    required super.undertimeHrs,
    required super.allowance,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      approvedRequests: json['approvedRequests'] as int? ?? 0,
      absent: (json['absent'] as num?)?.toDouble() ?? 0.0,
      lateHrs: (json['lateHrs'] as num?)?.toDouble() ?? 0.0,
      undertimeHrs: (json['undertimeHrs'] as num?)?.toDouble() ?? 0.0,
      allowance: (json['allowance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'approvedRequests': approvedRequests,
      'absent': absent,
      'lateHrs': lateHrs,
      'undertimeHrs': undertimeHrs,
      'allowance': allowance,
    };
  }
}
