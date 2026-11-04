import 'package:flutter/material.dart';

/// Side-by-side action buttons for Time-In Now and Time-Out Now matching web-app reference.
class PortalActionButtons extends StatelessWidget {
  final VoidCallback? onTimeIn;
  final VoidCallback? onTimeOut;
  final bool isTimeInDisabled;
  final bool isTimeOutDisabled;

  const PortalActionButtons({
    super.key,
    this.onTimeIn,
    this.onTimeOut,
    this.isTimeInDisabled = false,
    this.isTimeOutDisabled = false,
  });

  static const Color cardBackground = Color(0xFFEBEBEB);
  static const Color inColor = Color(0xFF4A74B2);
  static const Color outColor = Color(0xFFD65A4F);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Time-In Now Button
        Expanded(
          child: InkWell(
            key: const Key('portal_time_in_button'),
            onTap: isTimeInDisabled ? null : onTimeIn,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 135,
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login,
                    size: 52,
                    color: isTimeInDisabled ? inColor.withValues(alpha: 0.5) : inColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Time-In Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isTimeInDisabled ? inColor.withValues(alpha: 0.5) : inColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 2. Time-Out Now Button
        Expanded(
          child: InkWell(
            key: const Key('portal_time_out_button'),
            onTap: isTimeOutDisabled ? null : onTimeOut,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 135,
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    size: 52,
                    color: isTimeOutDisabled ? outColor.withValues(alpha: 0.5) : outColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Time-Out Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isTimeOutDisabled ? outColor.withValues(alpha: 0.5) : outColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
