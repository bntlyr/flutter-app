import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class ReshiftCalculationResult {
  final double? totalHours;
  final String? formatError;

  const ReshiftCalculationResult({this.totalHours, this.formatError});
}

ReshiftCalculationResult calculateReshiftTotal({
  required TimeOfDay? workStart,
  required TimeOfDay? breakStart,
  required TimeOfDay? breakEnd,
  required TimeOfDay? workEnd,
}) {
  if (workStart == null ||
      breakStart == null ||
      breakEnd == null ||
      workEnd == null) {
    return const ReshiftCalculationResult();
  }

  final ws = workStart.hour * 60 + workStart.minute;
  final bs = breakStart.hour * 60 + breakStart.minute;
  final be = breakEnd.hour * 60 + breakEnd.minute;
  final we = workEnd.hour * 60 + workEnd.minute;

  if (bs <= ws || be <= bs || we <= be) {
    return const ReshiftCalculationResult(
        formatError: 'Incorrect schedule format');
  }

  final duration1 = bs - ws;
  final duration2 = we - be;
  final totalMin = duration1 + duration2;
  final total = totalMin / 60.0;
  return ReshiftCalculationResult(
      totalHours: double.parse(total.toStringAsFixed(2)));
}

class ReshiftComponent extends StatelessWidget {
  final DateTime? reshiftDate;
  final ValueChanged<DateTime> onDateChanged;
  final String? dateError;
  final TimeOfDay? workStart;
  final TimeOfDay? breakStart;
  final TimeOfDay? breakEnd;
  final TimeOfDay? workEnd;
  final ValueChanged<TimeOfDay> onWorkStartChanged;
  final ValueChanged<TimeOfDay> onBreakStartChanged;
  final ValueChanged<TimeOfDay> onBreakEndChanged;
  final ValueChanged<TimeOfDay> onWorkEndChanged;
  final double? totalHours;
  final String? timeError;
  final String? formatError;

  const ReshiftComponent({
    super.key,
    required this.reshiftDate,
    required this.onDateChanged,
    this.dateError,
    required this.workStart,
    required this.breakStart,
    required this.breakEnd,
    required this.workEnd,
    required this.onWorkStartChanged,
    required this.onBreakStartChanged,
    required this.onBreakEndChanged,
    required this.onWorkEndChanged,
    required this.totalHours,
    this.timeError,
    this.formatError,
  });

  Widget _buildReshiftTableRow({
    required BuildContext context,
    required String label,
    required String value,
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isLast ? const Color(0xFFF9F9F9) : Colors.white,
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                color: isLast
                    ? const Color(0xFF212121)
                    : const Color(0xFF616161),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    color: isLast
                        ? kRequestHeaderTeal
                        : const Color(0xFF212121),
                  ),
                ),
                if (!isLast) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.watch_later_outlined,
                    size: 16,
                    color: Color(0xFF757575),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String totalDisplay = '';
    if (totalHours != null && formatError == null) {
      if (totalHours == totalHours!.roundToDouble()) {
        totalDisplay = '${totalHours!.toInt()} Hours';
      } else {
        totalDisplay = '${totalHours!.toStringAsFixed(2)} Hours';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRequestSectionHeader('Reshift'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildRequestDateField(
                context: context,
                label: 'Date applied in',
                value: reshiftDate,
                errorText: dateError,
                onSelected: onDateChanged,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: Column(
            children: [
              _buildReshiftTableRow(
                context: context,
                label: 'Work Start',
                value: workStart != null ? formatRequestTime(workStart!) : '',
                onTap: () => pickTimeOfDay(
                  context: context,
                  current: workStart,
                  onSelected: onWorkStartChanged,
                  use24HourFormat: true,
                ),
              ),
              _buildReshiftTableRow(
                context: context,
                label: 'Work Break Start',
                value: breakStart != null ? formatRequestTime(breakStart!) : '',
                onTap: () => pickTimeOfDay(
                  context: context,
                  current: breakStart,
                  onSelected: onBreakStartChanged,
                  use24HourFormat: true,
                ),
              ),
              _buildReshiftTableRow(
                context: context,
                label: 'Work Break End',
                value: breakEnd != null ? formatRequestTime(breakEnd!) : '',
                onTap: () => pickTimeOfDay(
                  context: context,
                  current: breakEnd,
                  onSelected: onBreakEndChanged,
                  use24HourFormat: true,
                ),
              ),
              _buildReshiftTableRow(
                context: context,
                label: 'Work End',
                value: workEnd != null ? formatRequestTime(workEnd!) : '',
                onTap: () => pickTimeOfDay(
                  context: context,
                  current: workEnd,
                  onSelected: onWorkEndChanged,
                  use24HourFormat: true,
                ),
              ),
              _buildReshiftTableRow(
                context: context,
                label: 'Total',
                value: totalDisplay,
                isLast: true,
              ),
            ],
          ),
        ),
        if (formatError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              formatError!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
            ),
          ),
        if (timeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              timeError!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
            ),
          ),
      ],
    );
  }
}
