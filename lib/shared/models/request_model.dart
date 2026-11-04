import 'package:flutter/material.dart';

enum RequestType {
  leave,
  timelogsCorrection,
  allowance,
  overtime,
  dayOffWork,
  reshift,
}

extension RequestTypeExtension on RequestType {
  String get label {
    switch (this) {
      case RequestType.leave:
        return 'Leave';
      case RequestType.timelogsCorrection:
        return 'Timelog Correction';
      case RequestType.allowance:
        return 'Allowance';
      case RequestType.overtime:
        return 'Overtime';
      case RequestType.dayOffWork:
        return 'Day Off Work';
      case RequestType.reshift:
        return 'Reshift';
    }
  }

  IconData get icon {
    switch (this) {
      case RequestType.leave:
        return Icons.beach_access_outlined;
      case RequestType.timelogsCorrection:
        return Icons.edit_calendar_outlined;
      case RequestType.allowance:
        return Icons.monetization_on_outlined;
      case RequestType.overtime:
        return Icons.more_time_outlined;
      case RequestType.dayOffWork:
        return Icons.work_history_outlined;
      case RequestType.reshift:
        return Icons.published_with_changes_outlined;
    }
  }
}

enum RequestStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

extension RequestStatusExtension on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.pending:
        return 'PENDING';
      case RequestStatus.approved:
        return 'APPROVED';
      case RequestStatus.rejected:
        return 'REJECTED';
      case RequestStatus.cancelled:
        return 'CANCELLED';
    }
  }
}

class UserRequest {
  final String id;
  final RequestType type;
  final DateTime filingDate;
  final String title;
  final String description;
  final RequestStatus status;
  final String approver;
  final DateTime? reviewedDate;
  final Map<String, dynamic> metadata;

  const UserRequest({
    required this.id,
    required this.type,
    required this.filingDate,
    required this.title,
    required this.description,
    required this.status,
    required this.approver,
    this.reviewedDate,
    this.metadata = const {},
  });

  UserRequest copyWith({
    String? id,
    RequestType? type,
    DateTime? filingDate,
    String? title,
    String? description,
    RequestStatus? status,
    String? approver,
    DateTime? reviewedDate,
    Map<String, dynamic>? metadata,
  }) {
    return UserRequest(
      id: id ?? this.id,
      type: type ?? this.type,
      filingDate: filingDate ?? this.filingDate,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      approver: approver ?? this.approver,
      reviewedDate: reviewedDate ?? this.reviewedDate,
      metadata: metadata ?? this.metadata,
    );
  }
}
