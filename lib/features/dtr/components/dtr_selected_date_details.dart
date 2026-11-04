import 'package:flutter/material.dart';
import 'dtr_sample_data.dart';

/// Details cards for the currently selected day in DTR:
/// - Date header card (In / Out or Absent)
/// - Approved Requests card (green badge)
/// - Punctuality card (orange badge)
/// - Day Rate Compensations card (teal badge)
/// - Night Rate Compensations card (indigo badge)
/// - Allowances card (brown/wine badge)
class DtrSelectedDateDetails extends StatelessWidget {
  final DtrMobileDayItem day;

  const DtrSelectedDateDetails({
    super.key,
    required this.day,
  });

  Widget _buildSectionCard({
    required Color indicatorColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF334155),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const fullMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthName = fullMonths[day.date.month - 1];
    final dayStr = day.date.day.toString().padLeft(2, '0');
    final formattedDate = '$monthName $dayStr, ${day.date.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Date Header Card
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Column(
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              if (day.isAbsent)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 16,
                      color: Color(0xFFE53935),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Absent',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'In: ${day.timeIn ?? '--'}   Out: ${day.timeOut ?? '--'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
            ],
          ),
        ),

        // 2. Approved Requests Card
        if (day.approvedRequests.isNotEmpty)
          _buildSectionCard(
            indicatorColor: const Color(0xFF8BC34A),
            title: 'Approved Requests',
            children: day.approvedRequests.map((req) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  req.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF334155),
                  ),
                ),
              );
            }).toList(),
          ),

        // 3. Punctuality Card
        if ((day.lateHours != null && day.lateHours! > 0) ||
            (day.undertimeHours != null && day.undertimeHours! > 0))
          _buildSectionCard(
            indicatorColor: const Color(0xFFFF6D00),
            title: 'Punctuality',
            children: [
              if (day.lateHours != null && day.lateHours! > 0)
                _buildRow('Late', day.lateHours!.toStringAsFixed(3)),
              if (day.undertimeHours != null && day.undertimeHours! > 0)
                _buildRow('Undertime', day.undertimeHours!.toStringAsFixed(3)),
            ],
          ),

        // 4. Day Rate Compensations Card
        if (day.dayRateCompensations.isNotEmpty)
          _buildSectionCard(
            indicatorColor: const Color(0xFF5C9FB0),
            title: 'Day Rate Compensations',
            children: day.dayRateCompensations.map((item) {
              return _buildRow(item.name, item.hours.toStringAsFixed(3));
            }).toList(),
          ),

        // 5. Night Rate Compensations Card
        if (day.nightRateCompensations.isNotEmpty)
          _buildSectionCard(
            indicatorColor: const Color(0xFF3F51B5),
            title: 'Night Rate Compensations',
            children: day.nightRateCompensations.map((item) {
              return _buildRow(item.name, item.hours.toStringAsFixed(3));
            }).toList(),
          ),

        // 6. Allowances Card
        if (day.allowances.isNotEmpty)
          _buildSectionCard(
            indicatorColor: const Color(0xFFA05252),
            title: 'Allowances',
            children: day.allowances.map((item) {
              return _buildRow(item.name, '₱${item.amount.toStringAsFixed(2)}');
            }).toList(),
          ),
      ],
    );
  }
}
