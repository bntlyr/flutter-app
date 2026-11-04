import '../../domain/entities/personal_schedule_entity.dart';
import '../graphql/__generated__/schedule.graphql.dart';

export '../../domain/entities/personal_schedule_entity.dart';

class PersonalScheduleMapper {
  static const _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static List<ShiftDayData> fromQuery({
    required Query$Schedule data,
    required DateTime targetMonth,
  }) {
    final firstDayOfMonth = DateTime(targetMonth.year, targetMonth.month, 1);
    final lastDayOfMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0);

    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday is 0
    final startDate = firstDayOfMonth.subtract(Duration(days: startWeekday));

    // Resolve active cutoff from data.cutOffs, awaitingCutOff, or current half-month
    final now = DateTime.now();
    DateTime? activeStart;
    DateTime? activeEnd;

    for (final c in data.cutOffs) {
      if (c == null) continue;
      final s = _parseDate(c.timeStart);
      final e = _parseDate(c.timeEnd);
      if (s != null && e != null) {
        final startDay = DateTime(s.year, s.month, s.day);
        final endDay = DateTime(e.year, e.month, e.day, 23, 59, 59);
        if (!now.isBefore(startDay) && !now.isAfter(endDay)) {
          activeStart = startDay;
          activeEnd = endDay;
          break;
        }
      }
    }

    if (activeStart == null && data.awaitingCutOff != null) {
      final s = _parseDate(data.awaitingCutOff!.timeStart);
      final e = _parseDate(data.awaitingCutOff!.timeEnd);
      if (s != null && e != null) {
        activeStart = DateTime(s.year, s.month, s.day);
        activeEnd = DateTime(e.year, e.month, e.day, 23, 59, 59);
      }
    }

    // Default active cutoff: current half-month (1-15 or 16-end)
    if (activeStart == null || activeEnd == null) {
      if (now.day <= 15) {
        activeStart = DateTime(now.year, now.month, 1);
        activeEnd = DateTime(now.year, now.month, 15, 23, 59, 59);
      } else {
        final lastDay = DateTime(now.year, now.month + 1, 0).day;
        activeStart = DateTime(now.year, now.month, 16);
        activeEnd = DateTime(now.year, now.month, lastDay, 23, 59, 59);
      }
    }

    // Daily map by dateStr and YYYY-MM-DD
    final dailyMap = <String, Query$Schedule$dailies>{};
    for (final d in data.dailies) {
      if (d.dateStr != null && d.dateStr!.isNotEmpty) {
        dailyMap[d.dateStr!] = d;
      }
    }

    // Weekly schedule template
    final template = data.schedule;

    final days = <ShiftDayData>[];
    var currentDay = startDate;

    for (int i = 0; i < 42; i++) {
      final isCurrentMonth = currentDay.month == targetMonth.month;
      final weekday = currentDay.weekday % 7;
      final dayMidday = DateTime(currentDay.year, currentDay.month, currentDay.day, 12);

      // Check if holiday
      final isHoliday = data.holidays.any((h) {
        final hDate = _parseDate(h.holidayDate);
        if (hDate == null) return false;
        return hDate.year == currentDay.year &&
            hDate.month == currentDay.month &&
            hDate.day == currentDay.day;
      });

      // Check if approved leave
      Query$Schedule$requests? leaveReq;
      for (final r in data.requests) {
        final effectiveUserId = data.me?.id;
        if (effectiveUserId != null && r.regId != null && r.regId != effectiveUserId) {
          continue;
        }
        if (r.typeOfRequest != null && r.typeOfRequest != 'Leave') {
          continue;
        }
        if (r.finalApproved == true && r.leaveFrom != null) {
          final from = _parseDate(r.leaveFrom);
          if (from == null) continue;
          final to = _parseDate(r.leaveTo) ?? from;
          final startLeave = DateTime(from.year, from.month, from.day);
          final endLeave = DateTime(to.year, to.month, to.day, 23, 59, 59);
          if (!dayMidday.isBefore(startLeave) && !dayMidday.isAfter(endLeave)) {
            leaveReq = r;
            break;
          }
        }
      }

      // Check shift configuration
      bool hasShift = false;
      String workStart = '08:00';
      String workEnd = '17:00';
      double totalHours = 8.0;

      final dateKeyMmm =
          '${_monthAbbr[currentDay.month - 1]}-${currentDay.day.toString().padLeft(2, '0')}-${currentDay.year}';
      final dateKeyIso =
          '${currentDay.year}-${currentDay.month.toString().padLeft(2, '0')}-${currentDay.day.toString().padLeft(2, '0')}';

      if (dailyMap.containsKey(dateKeyMmm) || dailyMap.containsKey(dateKeyIso)) {
        final d = dailyMap[dateKeyMmm] ?? dailyMap[dateKeyIso]!;
        hasShift = (d.type ?? true) && !isHoliday;
        workStart = d.workStart ?? '08:00';
        workEnd = d.workEnd ?? '17:00';
        totalHours = d.total?.toDouble() ?? 8.0;
      } else if (template != null) {
        final (tHasShift, tStart, tEnd, tTotal) = _getTemplateShift(template, weekday);
        hasShift = tHasShift && !isHoliday;
        workStart = tStart;
        workEnd = tEnd;
        totalHours = tTotal;
      } else {
        final isWeekend = (weekday == 0 || weekday == 6);
        hasShift = !isWeekend && !isHoliday;
      }

      // Cutoff containment check
      final inActiveCutoff =
          !dayMidday.isBefore(activeStart) && !dayMidday.isAfter(activeEnd);

      ShiftClassification classification;
      String title;
      String timeRange;

      if (!hasShift) {
        classification = ShiftClassification.restDay;
        title = isHoliday ? 'Holiday' : 'Rest Day';
        timeRange = 'No Shift Scheduled';
      } else if (inActiveCutoff) {
        if (leaveReq != null) {
          final isHalf = leaveReq.leaveTo == null;
          classification =
              isHalf ? ShiftClassification.leaveHalf : ShiftClassification.leaveFull;
          title = isHalf ? 'Leave For Half Day' : 'Leave For Full Day';
          timeRange = isHalf ? '[ 0.5 day ]' : '[ 1.0 day ]';
        } else if (_isNightShift(workStart, workEnd)) {
          classification = ShiftClassification.night;
          title = 'Night Shift';
          timeRange =
              '$workStart – $workEnd [ ${totalHours.toStringAsFixed(1)} hrs. ]';
        } else {
          classification = ShiftClassification.regular;
          title = 'Regular Shift';
          timeRange =
              '$workStart – $workEnd [ ${totalHours.toStringAsFixed(1)} hrs. ]';
        }
      } else {
        classification = ShiftClassification.otherCutOffs;
        title = 'Other Cut-offs';
        timeRange =
            '$workStart – $workEnd [ ${totalHours.toStringAsFixed(1)} hrs. ]';
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
      if (currentDay.isAfter(lastDayOfMonth) && days.length >= 35) {
        break;
      }
    }

    return days;
  }

  static (bool, String, String, double) _getTemplateShift(
    Query$Schedule$schedule template,
    int weekday,
  ) {
    switch (weekday) {
      case 0:
        return (
          template.sunType,
          template.sunWorkStart ?? '08:00',
          template.sunWorkEnd ?? '17:00',
          template.sunTotal?.toDouble() ?? 8.0,
        );
      case 1:
        return (
          template.monType,
          template.monWorkStart ?? '08:00',
          template.monWorkEnd ?? '17:00',
          template.monTotal?.toDouble() ?? 8.0,
        );
      case 2:
        return (
          template.tueType,
          template.tueWorkStart ?? '08:00',
          template.tueWorkEnd ?? '17:00',
          template.tueTotal?.toDouble() ?? 8.0,
        );
      case 3:
        return (
          template.wedType,
          template.wedWorkStart ?? '08:00',
          template.wedWorkEnd ?? '17:00',
          template.wedTotal?.toDouble() ?? 8.0,
        );
      case 4:
        return (
          template.thuType,
          template.thuWorkStart ?? '08:00',
          template.thuWorkEnd ?? '17:00',
          template.thuTotal?.toDouble() ?? 8.0,
        );
      case 5:
        return (
          template.friType,
          template.friWorkStart ?? '08:00',
          template.friWorkEnd ?? '17:00',
          template.friTotal?.toDouble() ?? 8.0,
        );
      case 6:
        return (
          template.satType,
          template.satWorkStart ?? '08:00',
          template.satWorkEnd ?? '17:00',
          template.satTotal?.toDouble() ?? 8.0,
        );
      default:
        return (false, '08:00', '17:00', 8.0);
    }
  }

  static bool _isNightShift(String workStart, String workEnd) {
    final startHour = int.tryParse(workStart.split(':').first) ?? 8;
    final endHour = int.tryParse(workEnd.split(':').first) ?? 17;
    return startHour >= 22 || startHour < 6 || (startHour >= 18 && endHour < 12);
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      final asInt = int.tryParse(value);
      if (asInt != null) return DateTime.fromMillisecondsSinceEpoch(asInt);
      return DateTime.tryParse(value);
    }
    return null;
  }
}
