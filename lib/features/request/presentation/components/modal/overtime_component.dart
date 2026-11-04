import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class OvertimeComponent extends StatelessWidget {
  final DateTime? overtimeDate;
  final ValueChanged<DateTime> onDateChanged;
  final String? dateError;

  const OvertimeComponent({
    super.key,
    required this.overtimeDate,
    required this.onDateChanged,
    this.dateError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRequestSectionHeader('Overtime'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildRequestDateField(
                context: context,
                label: 'Date applied in',
                value: overtimeDate,
                errorText: dateError,
                onSelected: onDateChanged,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }
}
