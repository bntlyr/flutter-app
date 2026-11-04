import 'package:flutter/material.dart';

const Color kRequestViewHeaderTeal = Color(0xFF47A5A0);
const Color kRequestViewDividerColor = Color(0xFFEEEEEE);

/// Represents the approval status of a user request
enum RequestApprovalStatus {
  approved,
  preApproved,
  pending,
  rejected;

  static RequestApprovalStatus fromString(String status) {
    final lower = status.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
    if (lower.contains('pre')) return RequestApprovalStatus.preApproved;
    if (lower.contains('app')) return RequestApprovalStatus.approved;
    if (lower.contains('rej')) return RequestApprovalStatus.rejected;
    return RequestApprovalStatus.pending;
  }

  String get label {
    switch (this) {
      case RequestApprovalStatus.approved:
        return 'Approved';
      case RequestApprovalStatus.preApproved:
        return 'Pre-Approved';
      case RequestApprovalStatus.pending:
        return 'Pending';
      case RequestApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case RequestApprovalStatus.approved:
        return const Color(0xFF7FBFFF); // Soft Blue
      case RequestApprovalStatus.preApproved:
        return const Color(0xFF70D1A1); // Soft Green
      case RequestApprovalStatus.pending:
        return const Color(0xFFFAAB36); // Amber / Orange
      case RequestApprovalStatus.rejected:
        return const Color(0xFFFF7F7F); // Soft Coral / Red
    }
  }

  IconData get icon {
    switch (this) {
      case RequestApprovalStatus.approved:
      case RequestApprovalStatus.preApproved:
        return Icons.check;
      case RequestApprovalStatus.pending:
        return Icons.access_time;
      case RequestApprovalStatus.rejected:
        return Icons.close;
    }
  }
}

Widget buildRequestViewDataRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 140,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF616161),
          ),
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF212121),
            height: 1.3,
          ),
        ),
      ),
    ],
  );
}
