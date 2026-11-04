import 'package:flutter/material.dart';

/// Attendance Summary 3-column stats card matching web-app reference (Image 2):
/// Bal. Leave (Days), Total Late Time (Mins), Total Overtime (Mins).
class PortalAttendanceSummaryCard extends StatelessWidget {
  final double balanceLeaveDays;
  final int totalLateMins;
  final int totalOvertimeMins;

  const PortalAttendanceSummaryCard({
    super.key,
    this.balanceLeaveDays = 23.1,
    this.totalLateMins = 0,
    this.totalOvertimeMins = 0,
  });

  static const Color headerTeal = Color(0xFF50B5A6);
  static const Color borderColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    final leaveStr = balanceLeaveDays.toStringAsFixed(1);
    final lateStr = totalLateMins.toString().padLeft(4, '0');
    final otStr = totalOvertimeMins.toString().padLeft(4, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header & Live Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Attendance Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: headerTeal,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.sync, size: 13, color: Color(0xFF9E9E9E)),
                SizedBox(width: 4),
                Text(
                  'Live data for this payroll period',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 2. Summary Table Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                height: 34,
                color: headerTeal,
                child: Row(
                  children: [
                    _buildHeaderCell('Bal. Leave'),
                    _buildHeaderDivider(),
                    _buildHeaderCell('Total Late Time', hasSyncIcon: true),
                    _buildHeaderDivider(),
                    _buildHeaderCell('Total Overtime', hasSyncIcon: true),
                  ],
                ),
              ),

              // Stat Row
              SizedBox(
                height: 76,
                child: Row(
                  children: [
                    _buildStatCell(value: leaveStr, unit: 'Days'),
                    _buildBodyDivider(),
                    _buildStatCell(value: lateStr, unit: 'Mins'),
                    _buildBodyDivider(),
                    _buildStatCell(value: otStr, unit: 'Mins'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String label, {bool hasSyncIcon = false}) {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasSyncIcon) ...[
              const SizedBox(width: 4),
              const Icon(Icons.sync, size: 12, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDivider() {
    return Container(
      width: 1,
      height: 20,
      color: Colors.white24,
    );
  }

  Widget _buildBodyDivider() {
    return Container(
      width: 1,
      height: 56,
      color: borderColor,
    );
  }

  Widget _buildStatCell({required String value, required String unit}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: headerTeal,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF757575),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
