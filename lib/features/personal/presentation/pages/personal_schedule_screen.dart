import 'package:flutter/material.dart';
import 'package:flutter_app/components/loaders/app_loading_indicator.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import '../../domain/entities/personal_schedule_entity.dart';
import '../viewmodels/personal_schedule_viewmodel.dart';

class PersonalScheduleScreen extends StatefulWidget {
  final String? userId;
  final PersonalScheduleViewModel? viewModel;

  const PersonalScheduleScreen({
    super.key,
    this.userId,
    this.viewModel,
  });

  @override
  State<PersonalScheduleScreen> createState() => _PersonalScheduleScreenState();
}

class _PersonalScheduleScreenState extends State<PersonalScheduleScreen> {
  late final PersonalScheduleViewModel _viewModel;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const List<String> _weekdays = [
    'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? PersonalScheduleViewModel();
    final uid = widget.userId ?? 'me';
    _viewModel.loadSchedule(userId: uid);
  }

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
        return AppColors.primary;
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

  List<List<ShiftDayData>> _groupWeeks(List<ShiftDayData> days) {
    final weeks = <List<ShiftDayData>>[];
    for (int i = 0; i < days.length; i += 7) {
      final end = (i + 7 < days.length) ? i + 7 : days.length;
      weeks.add(days.sublist(i, end));
    }
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final uid = widget.userId ?? 'me';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(102),
        child: Column(
          children: [
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
                ],
              ),
            ),
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
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.days.isEmpty) {
            return const Center(
              child: AppLoadingIndicator(message: 'Loading schedule...'),
            );
          }

          final monthName = _monthNames[_viewModel.targetMonth.month - 1];
          final monthYearStr = '$monthName ${_viewModel.targetMonth.year}';
          final weeks = _groupWeeks(_viewModel.days);
          final selectedDay = _viewModel.selectedDayData;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF64748B)),
                      onPressed: () => _viewModel.prevMonth(userId: uid),
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
                      onPressed: () => _viewModel.nextMonth(userId: uid),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                Column(
                  children: weeks.map((week) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.5),
                      child: Row(
                        children: week.map((day) {
                          final isSelected = _viewModel.selectedDate != null &&
                              _viewModel.selectedDate!.year == day.date.year &&
                              _viewModel.selectedDate!.month == day.date.month &&
                              _viewModel.selectedDate!.day == day.date.day;

                          final hasShift = day.classification != ShiftClassification.restDay;
                          final bgColor = _getShiftBgColor(day.classification);
                          final accentColor = _getShiftAccentColor(day.classification);

                          return Expanded(
                            child: Center(
                              child: GestureDetector(
                                onTap: () => _viewModel.selectDate(day.date),
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
                _buildLegend(),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: 14),
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
                if (selectedDay != null) _buildShiftCard(selectedDay),
              ],
            ),
          );
        },
      ),
    );
  }

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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF475569)),
        ),
      ],
    );
  }

  Widget _buildShiftCard(ShiftDayData day) {
    final accentColor = _getShiftAccentColor(day.classification);
    final bgColor = _getShiftBgColor(day.classification);
    final monthName = _monthNames[day.date.month - 1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor == Colors.transparent ? const Color(0xFFF8FAFC) : bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor, width: 2),
      ),
      child: Row(
        children: [
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
          Container(
            width: 2.5,
            height: 42,
            color: const Color(0xFFCBD5E1),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.title,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
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
