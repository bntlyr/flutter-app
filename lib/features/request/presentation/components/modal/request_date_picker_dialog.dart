import 'package:flutter/material.dart';
import 'request_modal_common.dart';

void showResponsiveDatePicker({
  required BuildContext context,
  required DateTime? initialDate,
  required ValueChanged<DateTime> onSelected,
}) {
  final overlay = Overlay.of(context);
  final now = DateTime.now();
  int currentYear = initialDate?.year ?? now.year;
  int currentMonth = initialDate?.month ?? now.month;
  DateTime? selectedDate = initialDate;

  OverlayEntry? entry;

  void close() {
    entry?.remove();
    entry = null;
  }

  entry = OverlayEntry(
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setOverlayState) {
          final mediaQuery = MediaQuery.of(context);
          final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
          final daysInMonth =
              DateUtils.getDaysInMonth(currentYear, currentMonth);
          final startWeekday = firstDayOfMonth.weekday % 7;
          final pickerWidth =
              (mediaQuery.size.width * 0.88).clamp(280.0, 340.0);
          final monthName = kMonthNames[currentMonth - 1];

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: close,
                  child: Container(color: Colors.black38),
                ),
              ),
              Center(
                child: Material(
                  elevation: 12,
                  shadowColor: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    width: pickerWidth,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                setOverlayState(() {
                                  currentYear--;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.keyboard_double_arrow_left,
                                    size: 20, color: Color(0xFF616161)),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                setOverlayState(() {
                                  if (currentMonth == 1) {
                                    currentMonth = 12;
                                    currentYear--;
                                  } else {
                                    currentMonth--;
                                  }
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.chevron_left,
                                    size: 22, color: Color(0xFF424242)),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2F4F4)
                                        .withValues(alpha: 0.6),
                                    border: Border.all(
                                        color: kRequestHeaderTeal, width: 1.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '$monthName $currentYear',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                setOverlayState(() {
                                  if (currentMonth == 12) {
                                    currentMonth = 1;
                                    currentYear++;
                                  } else {
                                    currentMonth++;
                                  }
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.chevron_right,
                                    size: 22, color: Color(0xFF424242)),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                setOverlayState(() {
                                  currentYear++;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.keyboard_double_arrow_right,
                                    size: 20, color: Color(0xFF616161)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            WeekdayCell('Su'),
                            WeekdayCell('Mo'),
                            WeekdayCell('Tu'),
                            WeekdayCell('We'),
                            WeekdayCell('Th'),
                            WeekdayCell('Fr'),
                            WeekdayCell('Sa'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: startWeekday + daysInMonth,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            if (index < startWeekday) {
                              return const SizedBox.shrink();
                            }
                            final day = index - startWeekday + 1;
                            final date =
                                DateTime(currentYear, currentMonth, day);
                            final isSelected = selectedDate != null &&
                                selectedDate.year == currentYear &&
                                selectedDate.month == currentMonth &&
                                selectedDate.day == day;
                            final isToday = now.year == currentYear &&
                                now.month == currentMonth &&
                                now.day == day;

                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                onSelected(date);
                                close();
                              },
                              child: Center(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: isSelected
                                      ? const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kRequestHeaderTeal,
                                        )
                                      : isToday
                                          ? BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: kRequestHeaderTeal,
                                                  width: 1.4),
                                            )
                                          : null,
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.white
                                          : isToday
                                              ? kRequestHeaderTeal
                                              : const Color(0xFF212121),
                                      fontWeight: isSelected || isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: close,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                onSelected(
                                    DateTime(now.year, now.month, now.day));
                                close();
                              },
                              child: const Text(
                                'Today',
                                style: TextStyle(
                                  color: kRequestHeaderTeal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
  overlay.insert(entry!);
}

class WeekdayCell extends StatelessWidget {
  final String text;
  const WeekdayCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF757575),
        ),
      ),
    );
  }
}
