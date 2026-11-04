import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class RequestValidationResult {
  final bool hasError;
  final String? reasonError;
  final String? leaveTypeError;
  final String? leaveDateError;
  final String? timelogDateError;
  final String? timelogTimeError;
  final String? allowanceDateError;
  final String? allowanceOptionError;
  final String? overtimeDateError;
  final String? dayoffGeneralDateError;
  final String? offsetFromDateError;
  final String? offsetToDateError;
  final String? reshiftDateError;
  final String? reshiftTimeError;
  final String? reshiftFormatError;
  final Map<String, dynamic>? data;

  const RequestValidationResult({
    required this.hasError,
    this.reasonError,
    this.leaveTypeError,
    this.leaveDateError,
    this.timelogDateError,
    this.timelogTimeError,
    this.allowanceDateError,
    this.allowanceOptionError,
    this.overtimeDateError,
    this.dayoffGeneralDateError,
    this.offsetFromDateError,
    this.offsetToDateError,
    this.reshiftDateError,
    this.reshiftTimeError,
    this.reshiftFormatError,
    this.data,
  });
}

RequestValidationResult validateAndBuildRequestPayload({
  required String? selectedRequestType,
  required String filingDate,
  required String reasonText,
  // Leave
  String? selectedLeaveType,
  bool isHalfDay = false,
  bool isFullDay = true,
  DateTime? leaveFromDate,
  DateTime? leaveToDate,
  // Timelogs
  DateTime? timelogDate,
  TimeOfDay? timeIn,
  TimeOfDay? timeOut,
  // Allowance
  DateTime? allowanceDate,
  String? selectedAllowance,
  // Overtime
  DateTime? overtimeDate,
  // Dayoff Work
  String typeOfDayoffWork = 'General',
  DateTime? dayoffGeneralDate,
  DateTime? offsetFromDate,
  DateTime? offsetToDate,
  // Reshift
  DateTime? reshiftDate,
  TimeOfDay? workStart,
  TimeOfDay? breakStart,
  TimeOfDay? breakEnd,
  TimeOfDay? workEnd,
  double? totalHours,
  String? reshiftFormatError,
}) {
  if (selectedRequestType == null) {
    return const RequestValidationResult(hasError: true);
  }

  bool hasError = false;
  String? reasonError;
  String? leaveTypeError;
  String? leaveDateError;
  String? timelogDateError;
  String? timelogTimeError;
  String? allowanceDateError;
  String? allowanceOptionError;
  String? overtimeDateError;
  String? dayoffGeneralDateError;
  String? offsetFromDateError;
  String? offsetToDateError;
  String? reshiftDateError;
  String? reshiftTimeError;

  final reason = reasonText.trim();
  if (reason.isEmpty) {
    reasonError = 'Please state your reason';
    hasError = true;
  } else if (reason.length < 7) {
    reasonError = 'Reason must be minimum of 7 characters';
    hasError = true;
  }

  switch (selectedRequestType) {
    case 'Leave':
      if (selectedLeaveType == null || selectedLeaveType.isEmpty) {
        leaveTypeError = 'Type of leave is required';
        hasError = true;
      }
      if (leaveFromDate == null) {
        leaveDateError = 'Please select a date';
        hasError = true;
      } else if (isFullDay && leaveToDate == null) {
        leaveDateError = 'Please select end date';
        hasError = true;
      }
      break;

    case 'Timelogs Correction':
      if (timelogDate == null) {
        timelogDateError = 'Date Required';
        hasError = true;
      }
      if (timeIn == null && timeOut == null) {
        timelogTimeError = 'Either Time-In, Time-Out, or both are required.';
        hasError = true;
      }
      break;

    case 'Allowance':
      if (allowanceDate == null) {
        allowanceDateError = 'Date Required';
        hasError = true;
      }
      if (selectedAllowance == null || selectedAllowance.isEmpty) {
        allowanceOptionError = 'Please select an allowance';
        hasError = true;
      }
      break;

    case 'Overtime':
      if (overtimeDate == null) {
        overtimeDateError = 'Date Required';
        hasError = true;
      }
      break;

    case 'Dayoff Work':
      if (typeOfDayoffWork == 'General') {
        if (dayoffGeneralDate == null) {
          dayoffGeneralDateError = 'Date Required';
          hasError = true;
        }
      } else if (typeOfDayoffWork == 'Offset') {
        if (offsetFromDate == null) {
          offsetFromDateError = 'Offset From Required';
          hasError = true;
        }
        if (offsetToDate == null) {
          offsetToDateError = 'Offset To Required';
          hasError = true;
        }
      }
      break;

    case 'Reshift':
      if (reshiftDate == null) {
        reshiftDateError = 'Date Required';
        hasError = true;
      }
      if (workStart == null ||
          breakStart == null ||
          breakEnd == null ||
          workEnd == null) {
        reshiftTimeError = 'Please enter missing information.';
        hasError = true;
      } else if (reshiftFormatError != null) {
        hasError = true;
      }
      break;
  }

  if (hasError) {
    return RequestValidationResult(
      hasError: true,
      reasonError: reasonError,
      leaveTypeError: leaveTypeError,
      leaveDateError: leaveDateError,
      timelogDateError: timelogDateError,
      timelogTimeError: timelogTimeError,
      allowanceDateError: allowanceDateError,
      allowanceOptionError: allowanceOptionError,
      overtimeDateError: overtimeDateError,
      dayoffGeneralDateError: dayoffGeneralDateError,
      offsetFromDateError: offsetFromDateError,
      offsetToDateError: offsetToDateError,
      reshiftDateError: reshiftDateError,
      reshiftTimeError: reshiftTimeError,
      reshiftFormatError: reshiftFormatError,
    );
  }

  final data = <String, dynamic>{
    'typeOfRequest': selectedRequestType,
    'dateOfFiling': filingDate,
    'reason': reason,
    if (selectedRequestType == 'Leave') ...{
      'typeOfLeave': selectedLeaveType,
      'isHalfDay': isHalfDay,
      'isFullDay': isFullDay,
      'fromDate':
          leaveFromDate != null ? formatRequestDate(leaveFromDate) : null,
      'toDate': leaveToDate != null ? formatRequestDate(leaveToDate) : null,
    },
    if (selectedRequestType == 'Timelogs Correction') ...{
      'dateApplied':
          timelogDate != null ? formatRequestDate(timelogDate) : null,
      'timeIn': timeIn != null ? formatRequestTime(timeIn) : null,
      'timeOut': timeOut != null ? formatRequestTime(timeOut) : null,
    },
    if (selectedRequestType == 'Allowance') ...{
      'dateApplied':
          allowanceDate != null ? formatRequestDate(allowanceDate) : null,
      'allowance': selectedAllowance,
    },
    if (selectedRequestType == 'Overtime') ...{
      'dateApplied':
          overtimeDate != null ? formatRequestDate(overtimeDate) : null,
    },
    if (selectedRequestType == 'Dayoff Work') ...{
      'typeOfDayoffWork': typeOfDayoffWork,
      if (typeOfDayoffWork == 'General')
        'dateApplied': dayoffGeneralDate != null
            ? formatRequestDate(dayoffGeneralDate)
            : null,
      if (typeOfDayoffWork == 'Offset') ...{
        'offsetFrom':
            offsetFromDate != null ? formatRequestDate(offsetFromDate) : null,
        'offsetTo':
            offsetToDate != null ? formatRequestDate(offsetToDate) : null,
      },
    },
    if (selectedRequestType == 'Reshift') ...{
      'dateApplied':
          reshiftDate != null ? formatRequestDate(reshiftDate) : null,
      'workStart': workStart != null ? formatRequestTime(workStart) : null,
      'breakStart': breakStart != null ? formatRequestTime(breakStart) : null,
      'breakEnd': breakEnd != null ? formatRequestTime(breakEnd) : null,
      'workEnd': workEnd != null ? formatRequestTime(workEnd) : null,
      'totalHours': totalHours,
    },
  };

  return RequestValidationResult(
    hasError: false,
    data: data,
  );
}
