import '../../domain/entities/dtr_entity.dart';

class DtrDayModel extends DtrDayEntity {
  const DtrDayModel({
    required super.date,
    super.timeIn,
    super.timeOut,
    super.isAbsent,
    super.lateHours,
    super.undertimeHours,
  });

  factory DtrDayModel.fromJson(Map<String, dynamic> json) {
    return DtrDayModel(
      date: DateTime.parse(json['date'] as String),
      timeIn: json['timeIn'] as String?,
      timeOut: json['timeOut'] as String?,
      isAbsent: json['isAbsent'] as bool? ?? false,
      lateHours: (json['lateHours'] as num?)?.toDouble(),
      undertimeHours: (json['undertimeHours'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'timeIn': timeIn,
      'timeOut': timeOut,
      'isAbsent': isAbsent,
      'lateHours': lateHours,
      'undertimeHours': undertimeHours,
    };
  }
}

class DtrCutoffModel extends DtrCutoffEntity {
  const DtrCutoffModel({
    required super.cutoffLabel,
    required super.totalApprovedRequests,
    required super.totalAbsent,
    required super.totalLateHrs,
    required super.totalUndertimeHrs,
    required super.totalAllowance,
    required super.days,
  });

  factory DtrCutoffModel.fromJson(Map<String, dynamic> json) {
    final rawDays = json['days'] as List<dynamic>? ?? [];
    return DtrCutoffModel(
      cutoffLabel: json['cutoffLabel'] as String? ?? '',
      totalApprovedRequests: json['totalApprovedRequests'] as int? ?? 0,
      totalAbsent: (json['totalAbsent'] as num?)?.toDouble() ?? 0.0,
      totalLateHrs: (json['totalLateHrs'] as num?)?.toDouble() ?? 0.0,
      totalUndertimeHrs: (json['totalUndertimeHrs'] as num?)?.toDouble() ?? 0.0,
      totalAllowance: (json['totalAllowance'] as num?)?.toDouble() ?? 0.0,
      days: rawDays
          .map((d) => DtrDayModel.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
