import 'package:flutter/material.dart';
import 'request_view_common.dart';

/// Status badge showing status circle icon and label (Pic 2).
class RequestViewStatusBadge extends StatelessWidget {
  final RequestApprovalStatus status;

  const RequestViewStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status Circle Badge
        Center(
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status.color,
            ),
            child: Center(
              child: Icon(
                status.icon,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Status Text
        Center(
          child: Text(
            status.label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: status.color,
            ),
          ),
        ),
      ],
    );
  }
}
