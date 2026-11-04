import 'package:flutter/foundation.dart';
import '../../domain/entities/personal_schedule_entity.dart';
import '../../domain/usecases/get_personal_schedule.dart';
import '../../data/repositories/personal_repository_impl.dart';

/// ViewModel managing state for the Personal Schedule calendar screen.
class PersonalScheduleViewModel extends ChangeNotifier {
  final GetPersonalScheduleUseCase getScheduleUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  DateTime _targetMonth;
  DateTime? _selectedDate;
  List<ShiftDayData> _days = const [];

  PersonalScheduleViewModel({
    GetPersonalScheduleUseCase? getScheduleUseCase,
    DateTime? initialMonth,
  })  : getScheduleUseCase = getScheduleUseCase ??
            GetPersonalScheduleUseCase(PersonalRepositoryImpl()),
        _targetMonth = initialMonth ?? DateTime.now(),
        _selectedDate = initialMonth ?? DateTime.now();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime get targetMonth => _targetMonth;
  DateTime? get selectedDate => _selectedDate;
  List<ShiftDayData> get days => _days;

  ShiftDayData? get selectedDayData {
    if (_selectedDate == null || _days.isEmpty) return null;
    try {
      return _days.firstWhere(
        (d) =>
            d.date.year == _selectedDate!.year &&
            d.date.month == _selectedDate!.month &&
            d.date.day == _selectedDate!.day,
      );
    } catch (_) {
      return _days.first;
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> loadSchedule({required String userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _days = await getScheduleUseCase.execute(
        userId: userId,
        month: _targetMonth,
      );
      _errorMessage = null;
    } catch (e) {
      if (_days.isEmpty) {
        _days = _generateDefaultDays(_targetMonth);
      }
      _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ShiftDayData> _generateDefaultDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final startWeekday = firstDayOfMonth.weekday % 7;
    final startDate = firstDayOfMonth.subtract(Duration(days: startWeekday));

    final now = DateTime.now();
    final activeStart = now.day <= 15
        ? DateTime(now.year, now.month, 1)
        : DateTime(now.year, now.month, 16);
    final activeEnd = now.day <= 15
        ? DateTime(now.year, now.month, 15, 23, 59, 59)
        : DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final days = <ShiftDayData>[];
    var currentDay = startDate;
    for (int i = 0; i < 42; i++) {
      final isCurrentMonth = currentDay.month == month.month;
      final weekday = currentDay.weekday % 7;
      final isWeekend = weekday == 0 || weekday == 6;

      final dayMidday = DateTime(currentDay.year, currentDay.month, currentDay.day, 12);
      final inActiveCutoff =
          !dayMidday.isBefore(activeStart) && !dayMidday.isAfter(activeEnd);

      ShiftClassification classification;
      String title;
      String timeRange;

      if (isWeekend) {
        classification = ShiftClassification.restDay;
        title = 'Rest Day';
        timeRange = 'No Shift Scheduled';
      } else if (inActiveCutoff) {
        classification = ShiftClassification.regular;
        title = 'Regular Shift';
        timeRange = '08:00 – 17:00 [ 8.0 hrs. ]';
      } else {
        classification = ShiftClassification.otherCutOffs;
        title = 'Other Cut-offs';
        timeRange = '08:00 – 17:00 [ 8.0 hrs. ]';
      }

      days.add(
        ShiftDayData(
          date: currentDay,
          isCurrentMonth: isCurrentMonth,
          classification: classification,
          title: title,
          timeRange: timeRange,
        ),
      );
      currentDay = currentDay.add(const Duration(days: 1));
      if (currentDay.isAfter(lastDayOfMonth) && days.length >= 35) break;
    }
    return days;
  }

  Future<void> nextMonth({required String userId}) {
    _targetMonth = DateTime(_targetMonth.year, _targetMonth.month + 1, 1);
    _selectedDate = DateTime(_targetMonth.year, _targetMonth.month, 1);
    return loadSchedule(userId: userId);
  }

  Future<void> prevMonth({required String userId}) {
    _targetMonth = DateTime(_targetMonth.year, _targetMonth.month - 1, 1);
    _selectedDate = DateTime(_targetMonth.year, _targetMonth.month, 1);
    return loadSchedule(userId: userId);
  }
}
