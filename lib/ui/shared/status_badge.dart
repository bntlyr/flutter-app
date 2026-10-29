import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/request_model.dart';

class StatusBadge extends StatelessWidget {
  final RequestStatus status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final (Color color, Color bg) = switch (status) {
      RequestStatus.approved => (
          AppColors.primary,
          AppColors.primary.withAlpha(30),
        ),
      RequestStatus.pending => (
          const Color(0xFFD97706), // warm amber
          const Color(0xFFFEF3C7),
        ),
      RequestStatus.rejected => (
          AppColors.error,
          AppColors.error.withAlpha(25),
        ),
      RequestStatus.cancelled => (
          AppColors.grayLight,
          Colors.black12,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(120), width: 1),
      ),
      child: Text(
        customLabel ?? status.label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
