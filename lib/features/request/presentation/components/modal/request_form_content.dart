import 'package:flutter/material.dart';

import 'allowance_component.dart';
import 'dayoff_work_component.dart';
import 'leave_component.dart';
import 'overtime_component.dart';
import 'request_modal_common.dart';
import 'reshift_component.dart';
import 'timelogs_correction_component.dart';

class RequestFormContent extends StatelessWidget {
  final String? selectedRequestType;
  final Widget? customContent;

  // Leave props
  final List<LeaveTypeOption> leaveTypes;
  final String? selectedLeaveType;
  final ValueChanged<String?> onLeaveTypeChanged;
  final bool isHalfDay;
  final bool isFullDay;
  final ValueChanged<bool> onHalfDayChanged;
  final ValueChanged<bool> onFullDayChanged;
  final DateTime? leaveFromDate;
  final DateTime? leaveToDate;
  final ValueChanged<DateTime> onLeaveFromDateChanged;
  final ValueChanged<DateTime> onLeaveToDateChanged;
  final String? leaveTypeError;
  final String? leaveDateError;

  // Timelogs props
  final DateTime? timelogDate;
  final ValueChanged<DateTime> onTimelogDateChanged;
  final String? timelogDateError;
  final TimeOfDay? timeIn;
  final TimeOfDay? timeOut;
  final ValueChanged<TimeOfDay> onTimeInChanged;
  final ValueChanged<TimeOfDay> onTimeOutChanged;
  final String? timelogTimeError;

  // Allowance props
  final List<String> allowanceOptions;
  final String? selectedAllowance;
  final ValueChanged<String> onAllowanceChanged;
  final DateTime? allowanceDate;
  final ValueChanged<DateTime> onAllowanceDateChanged;
  final String? allowanceDateError;
  final String? allowanceOptionError;

  // Overtime props
  final DateTime? overtimeDate;
  final ValueChanged<DateTime> onOvertimeDateChanged;
  final String? overtimeDateError;

  // Dayoff Work props
  final String typeOfDayoffWork;
  final ValueChanged<String> onDayoffTypeChanged;
  final DateTime? dayoffGeneralDate;
  final ValueChanged<DateTime> onDayoffGeneralDateChanged;
  final String? dayoffGeneralDateError;
  final DateTime? offsetFromDate;
  final DateTime? offsetToDate;
  final ValueChanged<DateTime> onOffsetFromDateChanged;
  final ValueChanged<DateTime> onOffsetToDateChanged;
  final String? offsetFromDateError;
  final String? offsetToDateError;

  // Reshift props
  final DateTime? reshiftDate;
  final ValueChanged<DateTime> onReshiftDateChanged;
  final String? reshiftDateError;
  final TimeOfDay? workStart;
  final TimeOfDay? breakStart;
  final TimeOfDay? breakEnd;
  final TimeOfDay? workEnd;
  final ValueChanged<TimeOfDay> onWorkStartChanged;
  final ValueChanged<TimeOfDay> onBreakStartChanged;
  final ValueChanged<TimeOfDay> onBreakEndChanged;
  final ValueChanged<TimeOfDay> onWorkEndChanged;
  final double? totalHours;
  final String? reshiftTimeError;
  final String? reshiftFormatError;

  const RequestFormContent({
    super.key,
    required this.selectedRequestType,
    this.customContent,
    required this.leaveTypes,
    required this.selectedLeaveType,
    required this.onLeaveTypeChanged,
    required this.isHalfDay,
    required this.isFullDay,
    required this.onHalfDayChanged,
    required this.onFullDayChanged,
    required this.leaveFromDate,
    required this.leaveToDate,
    required this.onLeaveFromDateChanged,
    required this.onLeaveToDateChanged,
    this.leaveTypeError,
    this.leaveDateError,
    required this.timelogDate,
    required this.onTimelogDateChanged,
    this.timelogDateError,
    required this.timeIn,
    required this.timeOut,
    required this.onTimeInChanged,
    required this.onTimeOutChanged,
    this.timelogTimeError,
    required this.allowanceOptions,
    required this.selectedAllowance,
    required this.onAllowanceChanged,
    required this.allowanceDate,
    required this.onAllowanceDateChanged,
    this.allowanceDateError,
    this.allowanceOptionError,
    required this.overtimeDate,
    required this.onOvertimeDateChanged,
    this.overtimeDateError,
    required this.typeOfDayoffWork,
    required this.onDayoffTypeChanged,
    required this.dayoffGeneralDate,
    required this.onDayoffGeneralDateChanged,
    this.dayoffGeneralDateError,
    required this.offsetFromDate,
    required this.offsetToDate,
    required this.onOffsetFromDateChanged,
    required this.onOffsetToDateChanged,
    this.offsetFromDateError,
    this.offsetToDateError,
    required this.reshiftDate,
    required this.onReshiftDateChanged,
    this.reshiftDateError,
    required this.workStart,
    required this.breakStart,
    required this.breakEnd,
    required this.workEnd,
    required this.onWorkStartChanged,
    required this.onBreakStartChanged,
    required this.onBreakEndChanged,
    required this.onWorkEndChanged,
    required this.totalHours,
    this.reshiftTimeError,
    this.reshiftFormatError,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedRequestType) {
      case 'Leave':
        return Column(
          children: [
            const SizedBox(height: 18),
            LeaveComponent(
              leaveTypes: leaveTypes,
              selectedLeaveType: selectedLeaveType,
              onLeaveTypeChanged: onLeaveTypeChanged,
              isHalfDay: isHalfDay,
              isFullDay: isFullDay,
              onHalfDayChanged: onHalfDayChanged,
              onFullDayChanged: onFullDayChanged,
              fromDate: leaveFromDate,
              toDate: leaveToDate,
              onFromDateChanged: onLeaveFromDateChanged,
              onToDateChanged: onLeaveToDateChanged,
              leaveTypeError: leaveTypeError,
              leaveDateError: leaveDateError,
            ),
          ],
        );

      case 'Timelogs Correction':
        return Column(
          children: [
            const SizedBox(height: 18),
            TimelogsCorrectionComponent(
              timelogDate: timelogDate,
              onDateChanged: onTimelogDateChanged,
              dateError: timelogDateError,
              timeIn: timeIn,
              timeOut: timeOut,
              onTimeInChanged: onTimeInChanged,
              onTimeOutChanged: onTimeOutChanged,
              timeError: timelogTimeError,
            ),
          ],
        );

      case 'Allowance':
        return Column(
          children: [
            const SizedBox(height: 18),
            AllowanceComponent(
              allowanceOptions: allowanceOptions,
              selectedAllowance: selectedAllowance,
              onAllowanceChanged: onAllowanceChanged,
              allowanceDate: allowanceDate,
              onDateChanged: onAllowanceDateChanged,
              dateError: allowanceDateError,
              optionError: allowanceOptionError,
            ),
          ],
        );

      case 'Overtime':
        return Column(
          children: [
            const SizedBox(height: 18),
            OvertimeComponent(
              overtimeDate: overtimeDate,
              onDateChanged: onOvertimeDateChanged,
              dateError: overtimeDateError,
            ),
          ],
        );

      case 'Dayoff Work':
        return Column(
          children: [
            const SizedBox(height: 18),
            DayoffWorkComponent(
              typeOfDayoffWork: typeOfDayoffWork,
              onTypeChanged: onDayoffTypeChanged,
              generalDate: dayoffGeneralDate,
              onGeneralDateChanged: onDayoffGeneralDateChanged,
              generalDateError: dayoffGeneralDateError,
              offsetFromDate: offsetFromDate,
              offsetToDate: offsetToDate,
              onOffsetFromDateChanged: onOffsetFromDateChanged,
              onOffsetToDateChanged: onOffsetToDateChanged,
              offsetFromDateError: offsetFromDateError,
              offsetToDateError: offsetToDateError,
            ),
          ],
        );

      case 'Reshift':
        return Column(
          children: [
            const SizedBox(height: 18),
            ReshiftComponent(
              reshiftDate: reshiftDate,
              onDateChanged: onReshiftDateChanged,
              dateError: reshiftDateError,
              workStart: workStart,
              breakStart: breakStart,
              breakEnd: breakEnd,
              workEnd: workEnd,
              onWorkStartChanged: onWorkStartChanged,
              onBreakStartChanged: onBreakStartChanged,
              onBreakEndChanged: onBreakEndChanged,
              onWorkEndChanged: onWorkEndChanged,
              totalHours: totalHours,
              timeError: reshiftTimeError,
              formatError: reshiftFormatError,
            ),
          ],
        );

      default:
        if (customContent != null) {
          return Column(
            children: [
              const SizedBox(height: 16),
              customContent!,
            ],
          );
        }
        return const SizedBox(height: 160);
    }
  }
}
