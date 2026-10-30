import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum ShiftClassification {
  regular,
  night,
  leaveFull,
  leaveHalf,
  otherCutOffs,
  restDay,
}

class ShiftDayData {
  final DateTime date;
  final bool isCurrentMonth;
  final ShiftClassification classification;
  final String title;
  final String timeRange;

  const ShiftDayData({
    required this.date,
    required this.isCurrentMonth,
    required this.classification,
    required this.title,
    required this.timeRange,
  });
}

class PersonalScheduleScreen extends StatefulWidget {
  const PersonalScheduleScreen({super.key});

  @override
  State<PersonalScheduleScreen> createState() => _PersonalScheduleScreenState();
}

class _PersonalScheduleScreenState extends State<PersonalScheduleScreen> {
  late DateTime _targetMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Default to October 2026 and select October 27 matching Image 1
    _targetMonth = DateTime(2026, 10, 1);
    _selectedDate = DateTime(2026, 10, 27);
  }

  void _prevMonth() {
    setState(() {
      _targetMonth = DateTime(_targetMonth.year, _targetMonth.month - 1, 1);
      _selectedDate = DateTime(_targetMonth.year, _targetMonth.month, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _targetMonth = DateTime(_targetMonth.year, _targetMonth.month + 1, 1);
      _selectedDate = DateTime(_targetMonth.year, _targetMonth.month, 1);
    });
  }

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const List<String> _weekdays = [
    'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  ];

  // Helper colors matching web scss
  Color _getShiftBgColor(ShiftClassification classification) {
    switch (classification) {
      case ShiftClassification.regular:
        return const Color(0xFFDDEFEE);
      case ShiftClassification.night:
        return const Color(0xFFCFD8E7);
      case ShiftClassification.leaveFull:
      case ShiftClassification.leaveHalf:
        return const Color(0xFFE7CFCF);
      case ShiftClassification.otherCutOffs:
        return const Color(0xFFF1F3F4);
      case ShiftClassification.restDay:
        return Colors.transparent;
    }
  }

  Color _getShiftAccentColor(ShiftClassification classification) {
    switch (classification) {
      case ShiftClassification.regular:
        return AppColors.primary; // #55AAAA
      case ShiftClassification.night:
        return const Color(0xFF5677AA);
      case ShiftClassification.leaveFull:
      case ShiftClassification.leaveHalf:
        return const Color(0xFFAA5555);
      case ShiftClassification.otherCutOffs:
        return const Color(0xFFB7B7B7);
      case ShiftClassification.restDay:
        return const Color(0xFF9E9E9E);
    }
  }

  // Generate calendar days for October 2026 matching screenshots
  List<List<ShiftDayData>> _generateMonthDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    // Days before first day to fill Sun-start grid
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday is 0
    final startDate = firstDayOfMonth.subtract(Duration(days: startWeekday));

    final weeks = <List<ShiftDayData>>[];
    var currentDay = startDate;

    for (int w = 0; w < 5; w++) {
      final week = <ShiftDayData>[];
      for (int d = 0; d < 7; d++) {
        final isCurrentMonth = currentDay.month == month.month;
        final weekday = currentDay.weekday % 7;

        ShiftClassification classification;
        String title;
        String timeRange;

        // Active cut-off is October 16 to October 31, 2026
        final isActiveCutoff = currentDay.year == 2026 &&
            currentDay.month == 10 &&
            currentDay.day >= 16 &&
            currentDay.day <= 31;

        if (weekday == 0 || weekday == 6) {
          // Weekend is Rest Day
          classification = ShiftClassification.restDay;
          title = 'Rest Day';
          timeRange = 'No Shift Scheduled';
        } else if (isActiveCutoff) {
          // 16 - 30 active cut-off (no change)
          if (currentDay.day == 21) {
            classification = ShiftClassification.night;
            title = 'Night Shift';
            timeRange = '19:00 – 04:00 [ 8.0 hrs. ]';
          } else if (currentDay.day == 29) {
            classification = ShiftClassification.leaveFull;
            title = 'Leave For Full Day';
            timeRange = '—';
          } else if (currentDay.day == 30) {
            classification = ShiftClassification.leaveHalf;
            title = 'Leave For Half Day';
            // Removed () text per user prompt: "last pic remove the () text"
            timeRange = '[ 4.8 hrs. ]';
          } else {
            classification = ShiftClassification.regular;
            title = 'Regular Shift';
            timeRange = '08:00 – 18:00 [ 9.5 hrs. ]';
          }
        } else {
          // 15 backwards and November 1 onwards (future dates): other cut-offs with same color
          classification = ShiftClassification.otherCutOffs;
          title = 'Other Cut-offs';
          timeRange = '08:00 – 17:00 [ 8.0 hrs. ]';
        }

        week.add(
          ShiftDayData(
            date: currentDay,
            isCurrentMonth: isCurrentMonth,
            classification: classification,
            title: title,
            timeRange: timeRange,
          ),
        );
        currentDay = currentDay.add(const Duration(days: 1));
      }
      weeks.add(week);
      if (currentDay.isAfter(lastDayOfMonth) && weeks.length >= 5) {
        break;
      }
    }
    return weeks;
  }

  ShiftDayData _getSelectedDayData(List<List<ShiftDayData>> weeks) {
    if (_selectedDate != null) {
      for (final week in weeks) {
        for (final day in week) {
          if (day.date.year == _selectedDate!.year &&
              day.date.month == _selectedDate!.month &&
              day.date.day == _selectedDate!.day) {
            return day;
          }
        }
      }
    }
    return weeks.first.first;
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _monthNames[_targetMonth.month - 1];
    final monthYearStr = '$monthName ${_targetMonth.year}';
    final weeks = _generateMonthDays(_targetMonth);
    final selectedDayData = _getSelectedDayData(weeks);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(102),
        child: Column(
          children: [
            // 1. Top dark app bar matching Image 1
            AppBar(
              backgroundColor: AppColors.gray,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'PayrollNeo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Personal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  tooltip: 'Notifications',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
                  tooltip: 'Profile',
                  onPressed: () {},
                ),
                const SizedBox(width: 4),
              ],
            ),

            // 2. Teal sub-header bar directly below matching Image 2
            Container(
              height: 46,
              color: AppColors.primary,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    'Work Schedule',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Month Header with Nav Arrows: < October 2026 >
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF64748B)),
                  onPressed: _prevMonth,
                ),
                Text(
                  monthYearStr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFF64748B)),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Weekday Names
            Row(
              children: _weekdays.map((day) {
                return Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            const Divider(color: Color(0xFFECEFF1), height: 1),
            const SizedBox(height: 6),

            // 3. Calendar Grid
            Column(
              children: weeks.map((week) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.5),
                  child: Row(
                    children: week.map((day) {
                      final isSelected = _selectedDate != null &&
                          _selectedDate!.year == day.date.year &&
                          _selectedDate!.month == day.date.month &&
                          _selectedDate!.day == day.date.day;

                      final hasShift = day.classification != ShiftClassification.restDay;
                      final bgColor = _getShiftBgColor(day.classification);
                      final accentColor = _getShiftAccentColor(day.classification);

                      return Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = day.date;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: hasShift ? accentColor : const Color(0xFF64748B),
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '${day.date.day}',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: day.isCurrentMonth
                                        ? const Color(0xFF334155)
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // 4. Legend matching images
            _buildLegend(),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFFE2E8F0), height: 1),
            const SizedBox(height: 14),

            // 5. Work Shift Schedule Header
            const Row(
              children: [
                Icon(Icons.info, size: 18, color: Color(0xFF1E293B)),
                SizedBox(width: 6),
                Text(
                  'Work Shift Schedule',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 6. Selected Shift Card matching images
            _buildShiftCard(selectedDayData),
          ],
        ),
      ),
    );
  }

  // Legend row matching web/screenshots
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildLegendItem(const Color(0xFFDDEFEE), 'Regular'),
        const SizedBox(width: 8),
        _buildLegendItem(const Color(0xFFCFD8E7), 'Night'),
        const SizedBox(width: 8),
        _buildLegendItem(const Color(0xFFE7CFCF), 'Leave'),
        const SizedBox(width: 8),
        _buildLegendItem(const Color(0xFFF1F3F4), 'Other cut-offs'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  // Shift card matching screenshots 1-4
  Widget _buildShiftCard(ShiftDayData day) {
    final accentColor = _getShiftAccentColor(day.classification);
    final bgColor = _getShiftBgColor(day.classification);
    final monthName = _monthNames[day.date.month - 1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor == Colors.transparent ? const Color(0xFFF8FAFC) : bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Left: Year & Date
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${day.date.year}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$monthName ${day.date.day}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 2.5,
            height: 42,
            color: const Color(0xFFCBD5E1),
          ),

          // Right: Shift title and time range
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    day.timeRange,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
