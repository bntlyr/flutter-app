import 'package:flutter/material.dart';
import 'package:flutter_app/shared/models/attendance_model.dart';

const Color kAlertHeaderTeal = Color(0xFF50B5A6);
const Color kAlertStripeLight = Color(0xFFF4FAF9);
const Color kAlertBorderColor = Color(0xFFE0E0E0);

const List<String> _kShortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Attendance Alert section matching web-app reference (Image 1 & 2):
/// Italic teal title, update timestamp subtitle, 4-column alert table,
/// and pagination controls.
class PortalAttendanceAlertCard extends StatefulWidget {
  final List<AttendanceAlert> alerts;
  final DateTime? latestUpdate;

  const PortalAttendanceAlertCard({
    super.key,
    required this.alerts,
    this.latestUpdate,
  });

  @override
  State<PortalAttendanceAlertCard> createState() =>
      _PortalAttendanceAlertCardState();
}

class _PortalAttendanceAlertCardState extends State<PortalAttendanceAlertCard> {
  int _currentPage = 0;
  static const int _pageSize = 5;

  String _formatLatestUpdate(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return 'The latest update was at $hh:$mm on $month/$day/${d.year}';
  }

  String _formatAlertDate(DateTime d) {
    final m = _kShortMonths[d.month - 1];
    final day = d.day.toString().padLeft(2, '0');
    return '$m $day, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final updateTimestampStr =
        _formatLatestUpdate(widget.latestUpdate ?? DateTime.now());
    final totalItems = widget.alerts.length;
    final totalPages = (totalItems / _pageSize).ceil().clamp(1, 999);
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalItems);
    final displayedAlerts = totalItems > 0
        ? widget.alerts.sublist(startIndex, endIndex)
        : <AttendanceAlert>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Title & Update Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Attendance Alert',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: kAlertHeaderTeal,
              ),
            ),
            Flexible(
              child: Text(
                updateTimestampStr,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 2. Table Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kAlertBorderColor, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                height: 34,
                color: kAlertHeaderTeal,
                child: Row(
                  children: const [
                    _AlertHeaderCell(label: 'Date', flex: 3),
                    _AlertHeaderCell(label: 'Alert Type', flex: 3),
                    _AlertHeaderCell(label: 'Possible Missing Form', flex: 4),
                    _AlertHeaderCell(label: 'Action', flex: 2),
                  ],
                ),
              ),

              // Data Rows / Empty Placeholder Rows
              if (displayedAlerts.isEmpty)
                for (int i = 0; i < 5; i++)
                  _buildEmptyRow(isStripe: i % 2 == 1)
              else ...[
                for (int i = 0; i < displayedAlerts.length; i++)
                  _buildDataRow(displayedAlerts[i], isStripe: i % 2 == 1),
                for (int i = displayedAlerts.length; i < 5; i++)
                  _buildEmptyRow(isStripe: i % 2 == 1),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 3. Paginator
        _buildPaginator(
          totalItems: totalItems > 0 ? totalItems : 5,
          startIndex: startIndex + 1,
          endIndex: totalItems > 0 ? endIndex : 5,
          totalPages: totalPages,
        ),
      ],
    );
  }

  Widget _buildEmptyRow({required bool isStripe}) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isStripe ? kAlertStripeLight : Colors.white,
        border: const Border(
          bottom: BorderSide(color: kAlertBorderColor, width: 0.8),
        ),
      ),
      child: Row(
        children: const [
          _AlertDataCell(text: '', flex: 3),
          _AlertDataCell(text: '', flex: 3),
          _AlertDataCell(text: '', flex: 4),
          _AlertDataCell(text: '', flex: 2),
        ],
      ),
    );
  }

  Widget _buildDataRow(AttendanceAlert alert, {required bool isStripe}) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isStripe ? kAlertStripeLight : Colors.white,
        border: const Border(
          bottom: BorderSide(color: kAlertBorderColor, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          _AlertDataCell(text: _formatAlertDate(alert.date), flex: 3),
          _AlertDataCell(text: alert.alertType, flex: 3),
          _AlertDataCell(
            text: alert.recommendedAction.isNotEmpty
                ? alert.recommendedAction
                : '--',
            flex: 4,
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_circle_outline,
                  size: 16,
                  color: kAlertHeaderTeal,
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Color(0xFFD32F2F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginator({
    required int totalItems,
    required int startIndex,
    required int endIndex,
    required int totalPages,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageButton(
          icon: Icons.first_page,
          enabled: _currentPage > 0,
          onTap: () => setState(() => _currentPage = 0),
        ),
        const SizedBox(width: 6),
        _PageButton(
          icon: Icons.chevron_left,
          enabled: _currentPage > 0,
          onTap: () => setState(() => _currentPage--),
        ),
        const SizedBox(width: 14),
        Text(
          '$startIndex – $endIndex of $totalItems',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF424242),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 14),
        _PageButton(
          icon: Icons.chevron_right,
          enabled: _currentPage < totalPages - 1,
          onTap: () => setState(() => _currentPage++),
        ),
        const SizedBox(width: 6),
        _PageButton(
          icon: Icons.last_page,
          enabled: _currentPage < totalPages - 1,
          onTap: () => setState(() => _currentPage = totalPages - 1),
        ),
      ],
    );
  }
}

class _AlertHeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const _AlertHeaderCell({required this.label, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AlertDataCell extends StatelessWidget {
  final String text;
  final int flex;

  const _AlertDataCell({required this.text, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: enabled ? const Color(0xFF9E9E9E) : const Color(0xFFE0E0E0),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? const Color(0xFF424242) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
