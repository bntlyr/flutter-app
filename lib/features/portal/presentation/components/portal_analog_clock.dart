import 'dart:math';
import 'package:flutter/material.dart';

const List<String> _kWeekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _kMonthNames = [
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

/// Clock Card matching web-app reference:
/// Teal container containing a live analog clock on the left,
/// with the full date and large digital time on the right.
class PortalAnalogClockCard extends StatelessWidget {
  final DateTime currentTime;

  const PortalAnalogClockCard({
    super.key,
    required this.currentTime,
  });

  static const Color tealBackground = Color(0xFF50B5A6);

  String _formatDate(DateTime d) {
    final weekday = _kWeekdayNames[d.weekday - 1];
    final month = _kMonthNames[d.month - 1];
    final day = d.day.toString().padLeft(2, '0');
    return '$weekday $month $day, ${d.year}';
  }

  String _formatTime(DateTime d) {
    final hour = d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    final minStr = d.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minStr $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(currentTime);
    final timeStr = _formatTime(currentTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: tealBackground,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Analog Clock Face
          SizedBox(
            width: 106,
            height: 106,
            child: CustomPaint(
              painter: _AnalogClockPainter(currentTime),
            ),
          ),
          const SizedBox(width: 14),

          // 2. Date & Big Digital Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final DateTime time;

  _AnalogClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Dial background
    final dialBgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 1, dialBgPaint);

    // Dial border
    final dialBorderPaint = Paint()
      ..color = const Color(0xFF262626)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawCircle(center, radius - 1, dialBorderPaint);

    // Ticks around perimeter
    final tickPaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 60; i++) {
      final angle = i * (2 * pi / 60);
      final isHourTick = i % 5 == 0;
      final tickLength = isHourTick ? 4.5 : 2.5;
      tickPaint.strokeWidth = isHourTick ? 1.5 : 0.8;

      final startR = radius - 1 - tickLength;
      final endR = radius - 1;

      final p1 = Offset(
        center.dx + startR * sin(angle),
        center.dy - startR * cos(angle),
      );
      final p2 = Offset(
        center.dx + endR * sin(angle),
        center.dy - endR * cos(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Numbers: 12, 3, 6, 9
    _drawNumber(canvas, '12', center, Offset(0, -radius * 0.68));
    _drawNumber(canvas, '3', center, Offset(radius * 0.68, 0));
    _drawNumber(canvas, '6', center, Offset(0, radius * 0.68));
    _drawNumber(canvas, '9', center, Offset(-radius * 0.68, 0));

    // Hour Hand
    final hourAngle =
        (time.hour % 12 + time.minute / 60.0) * (2 * pi / 12);
    final hourHandPaint = Paint()
      ..color = const Color(0xFF212121)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    final hourLen = radius * 0.52;
    canvas.drawLine(
      center,
      Offset(
        center.dx + hourLen * sin(hourAngle),
        center.dy - hourLen * cos(hourAngle),
      ),
      hourHandPaint,
    );

    // Minute Hand
    final minAngle =
        (time.minute + time.second / 60.0) * (2 * pi / 60);
    final minHandPaint = Paint()
      ..color = const Color(0xFF212121)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final minLen = radius * 0.74;
    canvas.drawLine(
      center,
      Offset(
        center.dx + minLen * sin(minAngle),
        center.dy - minLen * cos(minAngle),
      ),
      minHandPaint,
    );

    // Second Hand (Red)
    final secAngle = time.second * (2 * pi / 60);
    final secHandPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    final secLen = radius * 0.82;
    canvas.drawLine(
      center,
      Offset(
        center.dx + secLen * sin(secAngle),
        center.dy - secLen * cos(secAngle),
      ),
      secHandPaint,
    );

    // Center pivot dot (Red)
    final pivotPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3.0, pivotPaint);
  }

  void _drawNumber(Canvas canvas, String text, Offset center, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF212121),
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final pos = Offset(
      center.dx + offset.dx - (textPainter.width / 2),
      center.dy + offset.dy - (textPainter.height / 2),
    );
    textPainter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _AnalogClockPainter oldDelegate) {
    return oldDelegate.time.second != time.second ||
        oldDelegate.time.minute != time.minute ||
        oldDelegate.time.hour != time.hour;
  }
}
