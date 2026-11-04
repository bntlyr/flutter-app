import 'package:flutter/material.dart';

import 'reason_component.dart';
import 'request_form_content.dart';
import 'request_modal_actions.dart';
import 'request_modal_common.dart';
import 'request_modal_validator.dart';
import 'request_type_and_filing_date.dart';
import 'reshift_component.dart';

export 'request_modal_common.dart' show LeaveTypeOption;

/// Unified Request Modal Dialog assembling subcomponents from request-modal/.
class RequestModalDialog extends StatefulWidget {
  final String title;
  final String? initialTypeOfRequest;
  final List<String> requestTypes;
  final ValueChanged<String?>? onTypeChanged;
  final String? filingDate;
  final Widget? content;
  final VoidCallback? onCancel;
  final ValueChanged<Map<String, dynamic>>? onSubmitRequest;
  final bool isSubmitEnabled;
  final List<LeaveTypeOption> leaveTypes;
  final List<String> allowanceOptions;

  const RequestModalDialog({
    super.key,
    this.title = 'Request Form',
    this.initialTypeOfRequest,
    this.requestTypes = kDefaultRequestTypes,
    this.onTypeChanged,
    this.filingDate,
    this.content,
    this.onCancel,
    this.onSubmitRequest,
    this.isSubmitEnabled = false,
    this.leaveTypes = kDefaultLeaveTypes,
    this.allowanceOptions = kDefaultAllowanceOptions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String title = 'Request Form',
    String? initialTypeOfRequest,
    List<String> requestTypes = kDefaultRequestTypes,
    ValueChanged<String?>? onTypeChanged,
    String? filingDate,
    Widget? content,
    VoidCallback? onCancel,
    ValueChanged<Map<String, dynamic>>? onSubmitRequest,
    bool isSubmitEnabled = false,
    List<LeaveTypeOption>? leaveTypes,
    List<String>? allowanceOptions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isDismissible: true,
      enableDrag: true,
      builder: (ctx) => RequestModalDialog(
        title: title,
        initialTypeOfRequest: initialTypeOfRequest,
        requestTypes: requestTypes,
        onTypeChanged: onTypeChanged,
        filingDate: filingDate,
        content: content,
        onCancel: onCancel ?? () => Navigator.of(ctx).pop(),
        onSubmitRequest: onSubmitRequest,
        isSubmitEnabled: isSubmitEnabled,
        leaveTypes: leaveTypes ?? kDefaultLeaveTypes,
        allowanceOptions: allowanceOptions ?? kDefaultAllowanceOptions,
      ),
    );
  }

  @override
  State<RequestModalDialog> createState() => _RequestModalDialogState();
}

class _RequestModalDialogState extends State<RequestModalDialog> {
  String? _selectedRequestType;
  late String _filingDate;

  // Shared Reason
  final TextEditingController _reasonController = TextEditingController();
  String? _reasonError;

  // 1. Leave State
  String? _selectedLeaveType;
  bool _isHalfDay = false;
  bool _isFullDay = true;
  DateTime? _leaveFromDate;
  DateTime? _leaveToDate;
  String? _leaveTypeError;
  String? _leaveDateError;

  // 2. Timelogs Correction State
  DateTime? _timelogDate;
  TimeOfDay? _timeIn;
  TimeOfDay? _timeOut;
  String? _timelogDateError;
  String? _timelogTimeError;

  // 3. Allowance State
  DateTime? _allowanceDate;
  String? _selectedAllowance;
  String? _allowanceDateError;
  String? _allowanceOptionError;

  // 4. Overtime State
  DateTime? _overtimeDate;
  String? _overtimeDateError;

  // 5. Dayoff Work State
  String _typeOfDayoffWork = 'General';
  DateTime? _dayoffGeneralDate;
  DateTime? _offsetFromDate;
  DateTime? _offsetToDate;
  String? _dayoffGeneralDateError;
  String? _offsetFromDateError;
  String? _offsetToDateError;

  // 6. Reshift State
  DateTime? _reshiftDate;
  TimeOfDay? _workStart;
  TimeOfDay? _breakStart;
  TimeOfDay? _breakEnd;
  TimeOfDay? _workEnd;
  double? _totalHours;
  String? _reshiftDateError;
  String? _reshiftTimeError;
  String? _reshiftFormatError;

  @override
  void initState() {
    super.initState();
    _selectedRequestType = widget.initialTypeOfRequest;
    _filingDate = widget.filingDate ?? formatRequestDate(DateTime.now());
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _switchHalfDay(bool val) {
    setState(() {
      _isHalfDay = val;
      _isFullDay = !_isHalfDay;
      if (_isHalfDay) {
        _leaveToDate = null;
      }
    });
  }

  void _switchFullDay(bool val) {
    setState(() {
      _isFullDay = val;
      _isHalfDay = !_isFullDay;
    });
  }

  void _computeReshiftTotal() {
    final calc = calculateReshiftTotal(
      workStart: _workStart,
      breakStart: _breakStart,
      breakEnd: _breakEnd,
      workEnd: _workEnd,
    );
    setState(() {
      _totalHours = calc.totalHours;
      _reshiftFormatError = calc.formatError;
      if (calc.formatError == null) {
        _reshiftTimeError = null;
      }
    });
  }

  void _validateAndSubmit() {
    final result = validateAndBuildRequestPayload(
      selectedRequestType: _selectedRequestType,
      filingDate: _filingDate,
      reasonText: _reasonController.text,
      selectedLeaveType: _selectedLeaveType,
      isHalfDay: _isHalfDay,
      isFullDay: _isFullDay,
      leaveFromDate: _leaveFromDate,
      leaveToDate: _leaveToDate,
      timelogDate: _timelogDate,
      timeIn: _timeIn,
      timeOut: _timeOut,
      allowanceDate: _allowanceDate,
      selectedAllowance: _selectedAllowance,
      overtimeDate: _overtimeDate,
      typeOfDayoffWork: _typeOfDayoffWork,
      dayoffGeneralDate: _dayoffGeneralDate,
      offsetFromDate: _offsetFromDate,
      offsetToDate: _offsetToDate,
      reshiftDate: _reshiftDate,
      workStart: _workStart,
      breakStart: _breakStart,
      breakEnd: _breakEnd,
      workEnd: _workEnd,
      totalHours: _totalHours,
      reshiftFormatError: _reshiftFormatError,
    );

    setState(() {
      _reasonError = result.reasonError;
      _leaveTypeError = result.leaveTypeError;
      _leaveDateError = result.leaveDateError;
      _timelogDateError = result.timelogDateError;
      _timelogTimeError = result.timelogTimeError;
      _allowanceDateError = result.allowanceDateError;
      _allowanceOptionError = result.allowanceOptionError;
      _overtimeDateError = result.overtimeDateError;
      _dayoffGeneralDateError = result.dayoffGeneralDateError;
      _offsetFromDateError = result.offsetFromDateError;
      _offsetToDateError = result.offsetToDateError;
      _reshiftDateError = result.reshiftDateError;
      _reshiftTimeError = result.reshiftTimeError;
      if (result.reshiftFormatError != null) {
        _reshiftFormatError = result.reshiftFormatError;
      }
    });

    if (result.hasError || result.data == null) {
      return;
    }

    widget.onSubmitRequest?.call(result.data!);
    Navigator.of(context).pop(result.data!);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final isKeyboardOpen = bottomInset > 0;
    final sheetHeight = isKeyboardOpen
        ? mediaQuery.size.height * 0.92
        : (mediaQuery.size.height * 0.85).clamp(520.0, 750.0);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: sheetHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              alignment: Alignment.center,
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: kRequestHeaderTeal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  InkWell(
                    key: const Key('request_modal_close_button'),
                    onTap: () {
                      if (widget.onCancel != null) {
                        widget.onCancel!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RequestTypeAndFilingDate(
                      selectedRequestType: _selectedRequestType,
                      requestTypes: widget.requestTypes,
                      onTypeChanged: (type) {
                        setState(() {
                          _selectedRequestType = type;
                          _reasonError = null;
                        });
                        widget.onTypeChanged?.call(type);
                      },
                      filingDate: _filingDate,
                    ),
                    RequestFormContent(
                      selectedRequestType: _selectedRequestType,
                      customContent: widget.content,
                      leaveTypes: widget.leaveTypes,
                      selectedLeaveType: _selectedLeaveType,
                      onLeaveTypeChanged: (type) {
                        setState(() {
                          _selectedLeaveType = type;
                          _leaveTypeError = null;
                        });
                      },
                      isHalfDay: _isHalfDay,
                      isFullDay: _isFullDay,
                      onHalfDayChanged: _switchHalfDay,
                      onFullDayChanged: _switchFullDay,
                      leaveFromDate: _leaveFromDate,
                      leaveToDate: _leaveToDate,
                      onLeaveFromDateChanged: (d) {
                        setState(() {
                          _leaveFromDate = d;
                          if (_leaveToDate != null &&
                              _leaveToDate!.isBefore(_leaveFromDate!)) {
                            _leaveToDate = _leaveFromDate;
                          }
                          _leaveDateError = null;
                        });
                      },
                      onLeaveToDateChanged: (d) {
                        setState(() {
                          _leaveToDate = d;
                          _leaveDateError = null;
                        });
                      },
                      leaveTypeError: _leaveTypeError,
                      leaveDateError: _leaveDateError,
                      timelogDate: _timelogDate,
                      onTimelogDateChanged: (d) {
                        setState(() {
                          _timelogDate = d;
                          _timelogDateError = null;
                        });
                      },
                      timelogDateError: _timelogDateError,
                      timeIn: _timeIn,
                      timeOut: _timeOut,
                      onTimeInChanged: (t) {
                        setState(() {
                          _timeIn = t;
                          _timelogTimeError = null;
                        });
                      },
                      onTimeOutChanged: (t) {
                        setState(() {
                          _timeOut = t;
                          _timelogTimeError = null;
                        });
                      },
                      timelogTimeError: _timelogTimeError,
                      allowanceOptions: widget.allowanceOptions,
                      selectedAllowance: _selectedAllowance,
                      onAllowanceChanged: (opt) {
                        setState(() {
                          _selectedAllowance = opt;
                          _allowanceOptionError = null;
                        });
                      },
                      allowanceDate: _allowanceDate,
                      onAllowanceDateChanged: (d) {
                        setState(() {
                          _allowanceDate = d;
                          _allowanceDateError = null;
                        });
                      },
                      allowanceDateError: _allowanceDateError,
                      allowanceOptionError: _allowanceOptionError,
                      overtimeDate: _overtimeDate,
                      onOvertimeDateChanged: (d) {
                        setState(() {
                          _overtimeDate = d;
                          _overtimeDateError = null;
                        });
                      },
                      overtimeDateError: _overtimeDateError,
                      typeOfDayoffWork: _typeOfDayoffWork,
                      onDayoffTypeChanged: (type) {
                        setState(() => _typeOfDayoffWork = type);
                      },
                      dayoffGeneralDate: _dayoffGeneralDate,
                      onDayoffGeneralDateChanged: (d) {
                        setState(() {
                          _dayoffGeneralDate = d;
                          _dayoffGeneralDateError = null;
                        });
                      },
                      dayoffGeneralDateError: _dayoffGeneralDateError,
                      offsetFromDate: _offsetFromDate,
                      offsetToDate: _offsetToDate,
                      onOffsetFromDateChanged: (d) {
                        setState(() {
                          _offsetFromDate = d;
                          _offsetFromDateError = null;
                        });
                      },
                      onOffsetToDateChanged: (d) {
                        setState(() {
                          _offsetToDate = d;
                          _offsetToDateError = null;
                        });
                      },
                      offsetFromDateError: _offsetFromDateError,
                      offsetToDateError: _offsetToDateError,
                      reshiftDate: _reshiftDate,
                      onReshiftDateChanged: (d) {
                        setState(() {
                          _reshiftDate = d;
                          _reshiftDateError = null;
                        });
                      },
                      reshiftDateError: _reshiftDateError,
                      workStart: _workStart,
                      breakStart: _breakStart,
                      breakEnd: _breakEnd,
                      workEnd: _workEnd,
                      onWorkStartChanged: (t) {
                        setState(() => _workStart = t);
                        _computeReshiftTotal();
                      },
                      onBreakStartChanged: (t) {
                        setState(() => _breakStart = t);
                        _computeReshiftTotal();
                      },
                      onBreakEndChanged: (t) {
                        setState(() => _breakEnd = t);
                        _computeReshiftTotal();
                      },
                      onWorkEndChanged: (t) {
                        setState(() => _workEnd = t);
                        _computeReshiftTotal();
                      },
                      totalHours: _totalHours,
                      reshiftTimeError: _reshiftTimeError,
                      reshiftFormatError: _reshiftFormatError,
                    ),
                    if (_selectedRequestType != null) ...[
                      const SizedBox(height: 16),
                      ReasonComponent(
                        controller: _reasonController,
                        errorText: _reasonError,
                        onChanged: (_) {
                          if (_reasonError != null) {
                            setState(() => _reasonError = null);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            RequestModalActions(
              onCancel: widget.onCancel ?? () => Navigator.of(context).pop(),
              onSubmit: _validateAndSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
