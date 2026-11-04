import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class TimelogsCorrectionComponent extends StatelessWidget {
  final DateTime? timelogDate;
  final ValueChanged<DateTime> onDateChanged;
  final String? dateError;
  final TimeOfDay? timeIn;
  final TimeOfDay? timeOut;
  final ValueChanged<TimeOfDay> onTimeInChanged;
  final ValueChanged<TimeOfDay> onTimeOutChanged;
  final String? timeError;

  const TimelogsCorrectionComponent({
    super.key,
    required this.timelogDate,
    required this.onDateChanged,
    this.dateError,
    required this.timeIn,
    required this.timeOut,
    required this.onTimeInChanged,
    required this.onTimeOutChanged,
    this.timeError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRequestSectionHeader('Timelogs Correction'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildRequestDateField(
                context: context,
                label: 'Date applied in',
                value: timelogDate,
                errorText: dateError,
                onSelected: onDateChanged,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info, color: kRequestInfoColor, size: 22),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Either Time-In, Time-Out, or both are required.',
                        style: TextStyle(
                          color: kRequestInfoColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildRequestTimeField(
                context: context,
                label: 'Time-In',
                value: timeIn,
                errorText: timeError,
                onSelected: onTimeInChanged,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: buildRequestTimeField(
                context: context,
                label: 'Time-Out',
                value: timeOut,
                errorText: timeError,
                onSelected: onTimeOutChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
