import 'package:flutter/material.dart';
import 'dtr_sample_data.dart';

/// Collapsible Summary Card for DTR matching web-app mobile style:
/// - Approved Requests, Absent, Late, Undertime, Allowance
/// - Expandable section for Compensations (Day) and Compensations (Night)
class DtrSummaryCard extends StatefulWidget {
  final DtrCutoffData cutoffData;

  const DtrSummaryCard({
    super.key,
    required this.cutoffData,
  });

  @override
  State<DtrSummaryCard> createState() => _DtrSummaryCardState();
}

class _DtrSummaryCardState extends State<DtrSummaryCard> {
  bool _isExpanded = false;

  Widget _buildDottedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 3.0;
          const dashSpace = 3.0;
          final dashCount =
              (constraints.maxWidth / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFD1D5DB)),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  String _formatNumber(double val, {int decimals = 3}) {
    if (val == val.roundToDouble() && decimals == 0) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(decimals);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.cutoffData;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          const Center(
            child: Text(
              'Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Core rows
          _buildSummaryRow(
              'Approved Requests', '${data.totalApprovedRequests}'),
          _buildDottedDivider(),
          _buildSummaryRow('Absent',
              data.totalAbsent == 0 ? '0' : _formatNumber(data.totalAbsent, decimals: data.totalAbsent % 1 == 0 ? 0 : 4)),
          _buildDottedDivider(),
          _buildSummaryRow('Late', _formatNumber(data.totalLateHrs, decimals: 3)),
          _buildDottedDivider(),
          _buildSummaryRow(
              'Undertime', _formatNumber(data.totalUndertimeHrs, decimals: 3)),
          _buildDottedDivider(),
          _buildSummaryRow(
              'Allowance', '₱${data.totalAllowance.toStringAsFixed(2)}'),
          _buildDottedDivider(),

          // Expanded Compensations
          if (_isExpanded) ...[
            if (data.compensationsDay.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 6),
                child: Text(
                  'Compensations (Day)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              ...data.compensationsDay.entries.map((e) {
                return _buildSummaryRow(
                    e.key, _formatNumber(e.value, decimals: 3));
              }),
            ],
            if (data.compensationsNight.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 6),
                child: Text(
                  'Compensations (Night)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              ...data.compensationsNight.entries.map((e) {
                return _buildSummaryRow(
                    e.key, _formatNumber(e.value, decimals: 3));
              }),
            ],
            const SizedBox(height: 4),
          ],

          // Expand / Collapse Arrow
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              child: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: const Color(0xFF64748B),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
