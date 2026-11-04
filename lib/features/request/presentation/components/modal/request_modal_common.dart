import 'package:flutter/material.dart';
import 'request_date_picker_dialog.dart';

export 'request_date_picker_dialog.dart'
    show showResponsiveDatePicker, WeekdayCell;

const Color kRequestHeaderTeal = Color(0xFF47A5A0);
const Color kRequestInputFill = Color(0xFFE2F4F4);
const Color kRequestInfoColor = Color(0xFFB74D4D);

const List<String> kMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Represents a leave type item with available credit count.
class LeaveTypeOption {
  final String code;
  final String label;
  final double credits;

  const LeaveTypeOption({
    required this.code,
    required this.label,
    required this.credits,
  });

  bool get isDisabled => credits <= 0.0;
}

const List<LeaveTypeOption> kDefaultLeaveTypes = [
  LeaveTypeOption(code: 'sl', label: 'Sick', credits: 6.0),
  LeaveTypeOption(code: 'vl', label: 'Vacation', credits: 6.0),
  LeaveTypeOption(code: 'pml', label: 'Paternity/Maternity', credits: 7.0),
  LeaveTypeOption(code: 'brl', label: 'Bereavement', credits: 3.0),
  LeaveTypeOption(code: 'spl', label: 'Solo Parent', credits: 0.0),
  LeaveTypeOption(
      code: 'leaveWithoutPay', label: 'Leave Without Pay', credits: 999.0),
];

const List<String> kDefaultRequestTypes = [
  'Leave',
  'Timelogs Correction',
  'Allowance',
  'Overtime',
  'Dayoff Work',
  'Reshift',
];

const List<String> kDefaultAllowanceOptions = [
  'Perfect Attendance',
];

String formatRequestDate(DateTime d) {
  final month = kMonthNames[d.month - 1];
  final day = d.day.toString().padLeft(2, '0');
  return '$month $day, ${d.year}';
}

String formatRequestTime(TimeOfDay t) {
  return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

Widget buildRequestSectionHeader(String title) {
  return Row(
    children: [
      Container(
        width: 3.5,
        height: 16,
        decoration: BoxDecoration(
          color: kRequestHeaderTeal,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212121),
        ),
      ),
    ],
  );
}

Widget buildRequestDateField({
  required BuildContext context,
  required String label,
  required DateTime? value,
  required ValueChanged<DateTime> onSelected,
  String? errorText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF616161),
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 4),
      InkWell(
        onTap: () {
          showResponsiveDatePicker(
            context: context,
            initialDate: value,
            onSelected: onSelected,
          );
        },
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: kRequestInputFill,
            border: Border(
              bottom: BorderSide(
                color: errorText != null
                    ? const Color(0xFFD32F2F)
                    : kRequestHeaderTeal,
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value != null ? formatRequestDate(value) : '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Color(0xFF757575),
              ),
            ],
          ),
        ),
      ),
      if (errorText != null)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            errorText,
            style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
          ),
        ),
    ],
  );
}

Widget buildRequestTimeField({
  required BuildContext context,
  required String label,
  required TimeOfDay? value,
  required ValueChanged<TimeOfDay> onSelected,
  String? errorText,
  bool use24HourFormat = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF616161),
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 4),
      InkWell(
        onTap: () => pickTimeOfDay(
          context: context,
          current: value,
          onSelected: onSelected,
          use24HourFormat: use24HourFormat,
        ),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: kRequestInputFill,
            border: Border(
              bottom: BorderSide(
                color: errorText != null
                    ? const Color(0xFFD32F2F)
                    : kRequestHeaderTeal,
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value != null ? formatRequestTime(value) : '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.watch_later_outlined,
                size: 16,
                color: Color(0xFF757575),
              ),
            ],
          ),
        ),
      ),
      if (errorText != null)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            errorText,
            style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
          ),
        ),
    ],
  );
}

Future<void> pickTimeOfDay({
  required BuildContext context,
  required TimeOfDay? current,
  required ValueChanged<TimeOfDay> onSelected,
  bool use24HourFormat = false,
}) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: current ?? const TimeOfDay(hour: 8, minute: 0),
    builder: (ctx, child) {
      final themed = Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kRequestHeaderTeal,
            onPrimary: Colors.white,
            onSurface: Color(0xFF212121),
          ),
        ),
        child: child!,
      );
      if (use24HourFormat) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
          child: themed,
        );
      }
      return themed;
    },
  );
  if (picked != null) {
    onSelected(picked);
  }
}

class TextareaGripperPainter extends CustomPainter {
  const TextareaGripperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(
      Offset(size.width - 2, size.height - 8),
      Offset(size.width - 8, size.height - 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 2, size.height - 4),
      Offset(size.width - 4, size.height - 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
