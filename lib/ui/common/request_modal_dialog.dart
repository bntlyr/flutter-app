import 'package:flutter/material.dart';

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

/// Unified Request Modal Dialog for all request types:
/// - Leave
/// - Timelogs Correction
/// - Allowance
/// - Overtime
/// - Dayoff Work (General & Offset)
/// - Reshift
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

  // Options
  final List<LeaveTypeOption> leaveTypes;
  final List<String> allowanceOptions;

  const RequestModalDialog({
    super.key,
    this.title = 'Request Form',
    this.initialTypeOfRequest,
    this.requestTypes = const [
      'Leave',
      'Timelogs Correction',
      'Allowance',
      'Overtime',
      'Dayoff Work',
      'Reshift',
    ],
    this.onTypeChanged,
    this.filingDate,
    this.content,
    this.onCancel,
    this.onSubmitRequest,
    this.isSubmitEnabled = false,
    this.leaveTypes = const [
      LeaveTypeOption(code: 'sl', label: 'Sick', credits: 6.0),
      LeaveTypeOption(code: 'vl', label: 'Vacation', credits: 6.0),
      LeaveTypeOption(code: 'pml', label: 'Paternity/Maternity', credits: 7.0),
      LeaveTypeOption(code: 'brl', label: 'Bereavement', credits: 3.0),
      LeaveTypeOption(code: 'spl', label: 'Solo Parent', credits: 0.0),
      LeaveTypeOption(code: 'leaveWithoutPay', label: 'Leave Without Pay', credits: 999.0),
    ],
    this.allowanceOptions = const [
      'Perfect Attendance',
    ],
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String title = 'Request Form',
    String? initialTypeOfRequest,
    List<String> requestTypes = const [
      'Leave',
      'Timelogs Correction',
      'Allowance',
      'Overtime',
      'Dayoff Work',
      'Reshift',
    ],
    ValueChanged<String?>? onTypeChanged,
    String? filingDate,
    Widget? content,
    VoidCallback? onCancel,
    ValueChanged<Map<String, dynamic>>? onSubmitRequest,
    bool isSubmitEnabled = false,
    List<LeaveTypeOption>? leaveTypes,
    List<String>? allowanceOptions,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
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
        leaveTypes: leaveTypes ?? const [
          LeaveTypeOption(code: 'sl', label: 'Sick', credits: 6.0),
          LeaveTypeOption(code: 'vl', label: 'Vacation', credits: 6.0),
          LeaveTypeOption(code: 'pml', label: 'Paternity/Maternity', credits: 7.0),
          LeaveTypeOption(code: 'brl', label: 'Bereavement', credits: 3.0),
          LeaveTypeOption(code: 'spl', label: 'Solo Parent', credits: 0.0),
          LeaveTypeOption(code: 'leaveWithoutPay', label: 'Leave Without Pay', credits: 999.0),
        ],
        allowanceOptions: allowanceOptions ?? const [
          'Perfect Attendance',
        ],
      ),
    );
  }

  @override
  State<RequestModalDialog> createState() => _RequestModalDialogState();
}

class _RequestModalDialogState extends State<RequestModalDialog> {
  String? _selectedRequestType;
  late String _filingDate;

  // Reason controller (Shared across all forms)
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
  String _typeOfDayoffWork = 'General'; // 'General' or 'Offset'
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

  // LayerLinks for dropdowns & anchored popups
  final LayerLink _requestTypeLayerLink = LayerLink();
  final LayerLink _leaveTypeLayerLink = LayerLink();
  final LayerLink _dayoffTypeLayerLink = LayerLink();

  // LayerLinks for Date Pickers
  final LayerLink _leaveFromLayerLink = LayerLink();
  final LayerLink _leaveToLayerLink = LayerLink();
  final LayerLink _timelogDateLayerLink = LayerLink();
  final LayerLink _allowanceDateLayerLink = LayerLink();
  final LayerLink _overtimeDateLayerLink = LayerLink();
  final LayerLink _dayoffGeneralDateLayerLink = LayerLink();
  final LayerLink _offsetFromLayerLink = LayerLink();
  final LayerLink _offsetToLayerLink = LayerLink();
  final LayerLink _reshiftDateLayerLink = LayerLink();

  OverlayEntry? _activeOverlayEntry;

  static const Color _headerTeal = Color(0xFF47A5A0);
  static const Color _inputFill = Color(0xFFE2F4F4);
  static const Color _infoColor = Color(0xFFB74D4D);

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedRequestType = widget.initialTypeOfRequest;
    if (widget.filingDate != null && widget.filingDate!.isNotEmpty) {
      _filingDate = widget.filingDate!;
    } else {
      final now = DateTime.now();
      _filingDate = '${_monthNames[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
    }
    _selectedAllowance = null;
  }

  @override
  void dispose() {
    _closeAnyOverlay();
    _reasonController.dispose();
    super.dispose();
  }

  void _closeAnyOverlay() {
    _activeOverlayEntry?.remove();
    _activeOverlayEntry = null;
  }

  void _toggleRequestTypeDropdown() {
    if (_activeOverlayEntry != null) {
      _closeAnyOverlay();
    } else {
      _showRequestTypeDropdown();
    }
  }

  void _showRequestTypeDropdown() {
    _closeAnyOverlay();
    final overlay = Overlay.of(context);
    _activeOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeAnyOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _requestTypeLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 2),
              child: Material(
                elevation: 4,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
                child: Container(
                  width: 175,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Empty option
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRequestType = null;
                            _reasonController.clear();
                            _reasonError = null;
                          });
                          widget.onTypeChanged?.call(null);
                          _closeAnyOverlay();
                        },
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          child: const Text('', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      ...widget.requestTypes.map((type) {
                        final isSelected = _selectedRequestType == type;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedRequestType = type;
                              _reasonError = null;
                            });
                            widget.onTypeChanged?.call(type);
                            _closeAnyOverlay();
                          },
                          child: Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            color: isSelected ? const Color(0xFFEEEEEE) : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    type,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: const Color(0xFF212121),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check, color: _headerTeal, size: 16),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_activeOverlayEntry!);
  }

  void _showLeaveTypeDropdown() {
    _closeAnyOverlay();
    final overlay = Overlay.of(context);
    _activeOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeAnyOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _leaveTypeLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 2),
              child: Material(
                elevation: 4,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
                child: Container(
                  width: 175,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Empty option: tapping clears selected leave type
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedLeaveType = null;
                            _leaveFromDate = null;
                            _leaveToDate = null;
                            _leaveTypeError = null;
                            _leaveDateError = null;
                          });
                          _closeAnyOverlay();
                        },
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          child: const Text('', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      ...widget.leaveTypes.map((lt) {
                        final bool disabled = lt.isDisabled;
                        final bool isSelected = _selectedLeaveType == lt.label;
                        return InkWell(
                          onTap: disabled
                              ? null
                              : () {
                                  setState(() {
                                    _selectedLeaveType = lt.label;
                                    _leaveTypeError = null;
                                  });
                                  _closeAnyOverlay();
                                },
                          child: Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            color: isSelected ? const Color(0xFFEEEEEE) : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    lt.label,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: disabled
                                          ? const Color(0xFFBDBDBD)
                                          : const Color(0xFF212121),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check, color: _headerTeal, size: 16),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_activeOverlayEntry!);
  }

  void _showDayoffTypeDropdown() {
    _closeAnyOverlay();
    final overlay = Overlay.of(context);
    const options = ['General', 'Offset'];

    _activeOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeAnyOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _dayoffTypeLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 2),
              child: Material(
                elevation: 4,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
                child: Container(
                  width: 175,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: options.map((opt) {
                      final isSelected = _typeOfDayoffWork == opt;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _typeOfDayoffWork = opt;
                            _dayoffGeneralDateError = null;
                            _offsetFromDateError = null;
                            _offsetToDateError = null;
                          });
                          _closeAnyOverlay();
                        },
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          color: isSelected ? const Color(0xFFEEEEEE) : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                opt,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check, color: _headerTeal, size: 16),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_activeOverlayEntry!);
  }

  String _formatDate(DateTime dt) {
    return '${_monthNames[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
  }

  String _formatTime(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  /// Opens anchored month calendar popover directly underneath the clicked date input.
  void _openAnchoredDatePicker({
    required LayerLink link,
    required DateTime? initialDate,
    required ValueChanged<DateTime> onSelected,
    bool alignRight = false,
  }) {
    _closeAnyOverlay();
    final overlay = Overlay.of(context);
    final now = DateTime.now();
    int currentYear = initialDate?.year ?? now.year;
    int currentMonth = initialDate?.month ?? now.month;
    DateTime? selectedDate = initialDate;

    _activeOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setOverlayState) {
            final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
            final daysInMonth = DateUtils.getDaysInMonth(currentYear, currentMonth);
            final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _closeAnyOverlay,
                    child: Container(color: Colors.transparent),
                  ),
                ),
                CompositedTransformFollower(
                  link: link,
                  showWhenUnlinked: false,
                  targetAnchor: alignRight ? Alignment.bottomRight : Alignment.bottomLeft,
                  followerAnchor: alignRight ? Alignment.topRight : Alignment.topLeft,
                  offset: const Offset(0, 4),
                  child: Material(
                    elevation: 8,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header: < [ 2026 v ] >
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
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
                                  child: Icon(Icons.chevron_left, size: 20, color: Color(0xFF616161)),
                                ),
                              ),
                              Container(
                                height: 26,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: _headerTeal, width: 1.2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$currentYear',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_drop_down, size: 16, color: _headerTeal),
                                  ],
                                ),
                              ),
                              InkWell(
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
                                  child: Icon(Icons.chevron_right, size: 20, color: Color(0xFF616161)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Days of Week Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              _WeekdayCell('Su'),
                              _WeekdayCell('Mo'),
                              _WeekdayCell('Tu'),
                              _WeekdayCell('We'),
                              _WeekdayCell('Th'),
                              _WeekdayCell('Fr'),
                              _WeekdayCell('Sa'),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Days Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: startWeekday + daysInMonth,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              if (index < startWeekday) {
                                return const SizedBox.shrink();
                              }
                              final day = index - startWeekday + 1;
                              final date = DateTime(currentYear, currentMonth, day);
                              final isSelected = selectedDate != null &&
                                  selectedDate.year == currentYear &&
                                  selectedDate.month == currentMonth &&
                                  selectedDate.day == day;

                              return InkWell(
                                onTap: () {
                                  onSelected(date);
                                  _closeAnyOverlay();
                                },
                                child: Center(
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: isSelected
                                        ? BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: _headerTeal, width: 1.5),
                                          )
                                        : null,
                                    child: Text(
                                      '$day',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected ? _headerTeal : const Color(0xFF212121),
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
    overlay.insert(_activeOverlayEntry!);
  }

  Future<void> _pickTime({
    required TimeOfDay? current,
    required ValueChanged<TimeOfDay> onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (ctx, child) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(
                primary: _headerTeal,
                onPrimary: Colors.white,
                onSurface: Color(0xFF212121),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  void _computeReshiftTotal() {
    if (_workStart == null || _breakStart == null || _breakEnd == null || _workEnd == null) {
      setState(() {
        _totalHours = null;
        _reshiftFormatError = null;
      });
      return;
    }

    final ws = _workStart!.hour * 60 + _workStart!.minute;
    final bs = _breakStart!.hour * 60 + _breakStart!.minute;
    final be = _breakEnd!.hour * 60 + _breakEnd!.minute;
    final we = _workEnd!.hour * 60 + _workEnd!.minute;

    // Sequence format validation: workStart < breakStart < breakEnd < workEnd
    if (bs <= ws || be <= bs || we <= be) {
      setState(() {
        _totalHours = null;
        _reshiftFormatError = 'Incorrect schedule format';
      });
      return;
    }

    final duration1 = bs - ws;
    final duration2 = we - be;
    final totalMin = duration1 + duration2;
    final total = totalMin / 60.0;

    setState(() {
      _totalHours = double.parse(total.toStringAsFixed(2));
      _reshiftFormatError = null;
      _reshiftTimeError = null;
    });
  }

  void _switchHalfDay(bool? val) {
    setState(() {
      _isHalfDay = val ?? false;
      _isFullDay = !_isHalfDay;
      if (_isHalfDay) {
        _leaveToDate = null;
      }
    });
  }

  void _switchFullDay(bool? val) {
    setState(() {
      _isFullDay = val ?? true;
      _isHalfDay = !_isFullDay;
    });
  }

  void _validateAndSubmit() {
    bool hasError = false;

    setState(() {
      _reasonError = null;
      _leaveTypeError = null;
      _leaveDateError = null;
      _timelogDateError = null;
      _timelogTimeError = null;
      _allowanceDateError = null;
      _allowanceOptionError = null;
      _overtimeDateError = null;
      _dayoffGeneralDateError = null;
      _offsetFromDateError = null;
      _offsetToDateError = null;
      _reshiftDateError = null;
      _reshiftTimeError = null;
      _reshiftFormatError = null;
    });

    if (_selectedRequestType == null) {
      return;
    }

    // 1. Reason Validation (Shared)
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() => _reasonError = 'Please state your reason');
      hasError = true;
    } else if (reason.length < 7) {
      setState(() => _reasonError = 'Reason must be minimum of 7 characters');
      hasError = true;
    }

    // 2. Type-specific validations
    switch (_selectedRequestType) {
      case 'Leave':
        if (_selectedLeaveType == null || _selectedLeaveType!.isEmpty) {
          setState(() => _leaveTypeError = 'Type of leave is required');
          hasError = true;
        }
        if (_leaveFromDate == null) {
          setState(() => _leaveDateError = 'Please select a date');
          hasError = true;
        } else if (_isFullDay && _leaveToDate == null) {
          setState(() => _leaveDateError = 'Please select end date');
          hasError = true;
        }
        break;

      case 'Timelogs Correction':
        if (_timelogDate == null) {
          setState(() => _timelogDateError = 'Date Required');
          hasError = true;
        }
        if (_timeIn == null && _timeOut == null) {
          setState(() => _timelogTimeError = 'Either Time-In, Time-Out, or both are required.');
          hasError = true;
        }
        break;

      case 'Allowance':
        if (_allowanceDate == null) {
          setState(() => _allowanceDateError = 'Date Required');
          hasError = true;
        }
        if (_selectedAllowance == null || _selectedAllowance!.isEmpty) {
          setState(() => _allowanceOptionError = 'Please select an allowance');
          hasError = true;
        }
        break;

      case 'Overtime':
        if (_overtimeDate == null) {
          setState(() => _overtimeDateError = 'Date Required');
          hasError = true;
        }
        break;

      case 'Dayoff Work':
        if (_typeOfDayoffWork == 'General') {
          if (_dayoffGeneralDate == null) {
            setState(() => _dayoffGeneralDateError = 'Date Required');
            hasError = true;
          }
        } else if (_typeOfDayoffWork == 'Offset') {
          if (_offsetFromDate == null) {
            setState(() => _offsetFromDateError = 'Offset From Required');
            hasError = true;
          }
          if (_offsetToDate == null) {
            setState(() => _offsetToDateError = 'Offset To Required');
            hasError = true;
          }
        }
        break;

      case 'Reshift':
        if (_reshiftDate == null) {
          setState(() => _reshiftDateError = 'Date Required');
          hasError = true;
        }
        if (_workStart == null || _breakStart == null || _breakEnd == null || _workEnd == null) {
          setState(() => _reshiftTimeError = 'Please enter missing information.');
          hasError = true;
        } else {
          _computeReshiftTotal();
          if (_reshiftFormatError != null) {
            hasError = true;
          }
        }
        break;
    }

    if (hasError) return;

    final data = <String, dynamic>{
      'typeOfRequest': _selectedRequestType,
      'dateOfFiling': _filingDate,
      'reason': reason,
      if (_selectedRequestType == 'Leave') ...{
        'typeOfLeave': _selectedLeaveType,
        'isHalfDay': _isHalfDay,
        'isFullDay': _isFullDay,
        'fromDate': _leaveFromDate != null ? _formatDate(_leaveFromDate!) : null,
        'toDate': _leaveToDate != null ? _formatDate(_leaveToDate!) : null,
      },
      if (_selectedRequestType == 'Timelogs Correction') ...{
        'dateApplied': _timelogDate != null ? _formatDate(_timelogDate!) : null,
        'timeIn': _timeIn != null ? _formatTime(_timeIn!) : null,
        'timeOut': _timeOut != null ? _formatTime(_timeOut!) : null,
      },
      if (_selectedRequestType == 'Allowance') ...{
        'dateApplied': _allowanceDate != null ? _formatDate(_allowanceDate!) : null,
        'allowance': _selectedAllowance,
      },
      if (_selectedRequestType == 'Overtime') ...{
        'dateApplied': _overtimeDate != null ? _formatDate(_overtimeDate!) : null,
      },
      if (_selectedRequestType == 'Dayoff Work') ...{
        'typeOfDayoffWork': _typeOfDayoffWork,
        if (_typeOfDayoffWork == 'General')
          'dateApplied': _dayoffGeneralDate != null ? _formatDate(_dayoffGeneralDate!) : null,
        if (_typeOfDayoffWork == 'Offset') ...{
          'offsetFrom': _offsetFromDate != null ? _formatDate(_offsetFromDate!) : null,
          'offsetTo': _offsetToDate != null ? _formatDate(_offsetToDate!) : null,
        },
      },
      if (_selectedRequestType == 'Reshift') ...{
        'dateApplied': _reshiftDate != null ? _formatDate(_reshiftDate!) : null,
        'workStart': _workStart != null ? _formatTime(_workStart!) : null,
        'breakStart': _breakStart != null ? _formatTime(_breakStart!) : null,
        'breakEnd': _breakEnd != null ? _formatTime(_breakEnd!) : null,
        'workEnd': _workEnd != null ? _formatTime(_workEnd!) : null,
        'totalHours': _totalHours,
      },
    };

    widget.onSubmitRequest?.call(data);
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardOpen = mediaQuery.viewInsets.bottom > 0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: isKeyboardOpen ? mediaQuery.size.height * 0.9 : 680,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Solid Header Bar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: _headerTeal,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            // 2. Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Row: Type of Request & Date of Filing
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Type of Request
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Type of Request',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF616161),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              CompositedTransformTarget(
                                link: _requestTypeLayerLink,
                                child: InkWell(
                                  key: const Key('request_type_dropdown_trigger'),
                                  onTap: _toggleRequestTypeDropdown,
                                  child: Container(
                                    height: 36,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: const BoxDecoration(
                                      color: _inputFill,
                                      border: Border(
                                        bottom: BorderSide(color: _headerTeal, width: 1.5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _selectedRequestType ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF212121),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          color: _headerTeal,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Right: Date of Filing
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date of Filing',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF616161),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.centerLeft,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border(
                                    bottom: BorderSide(color: _headerTeal, width: 1.5),
                                  ),
                                ),
                                child: Text(
                                  _filingDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Request Form Content
                    if (_selectedRequestType == 'Leave') ...[
                      const SizedBox(height: 18),
                      _buildLeaveSection(),
                    ] else if (_selectedRequestType == 'Timelogs Correction') ...[
                      const SizedBox(height: 18),
                      _buildTimelogsCorrectionSection(),
                    ] else if (_selectedRequestType == 'Allowance') ...[
                      const SizedBox(height: 18),
                      _buildAllowanceSection(),
                    ] else if (_selectedRequestType == 'Overtime') ...[
                      const SizedBox(height: 18),
                      _buildOvertimeSection(),
                    ] else if (_selectedRequestType == 'Dayoff Work') ...[
                      const SizedBox(height: 18),
                      _buildDayoffWorkSection(),
                    ] else if (_selectedRequestType == 'Reshift') ...[
                      const SizedBox(height: 18),
                      _buildReshiftSection(),
                    ] else if (widget.content != null) ...[
                      const SizedBox(height: 16),
                      widget.content!,
                    ] else ...[
                      const SizedBox(height: 160),
                    ],

                    // Shared Reason Section
                    if (_selectedRequestType != null) ...[
                      const SizedBox(height: 16),
                      _buildReasonSection(),
                    ],
                  ],
                ),
              ),
            ),

            // 3. Footer: [ Cancel ]   [ Submit ]
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: OutlinedButton(
                        onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _headerTeal, width: 1.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: _headerTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        onPressed: _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: _headerTeal,
                          disabledBackgroundColor: const Color(0xFFF5F5F5),
                          disabledForegroundColor: const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Subheader Component ---
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3.5,
          height: 16,
          decoration: BoxDecoration(
            color: _headerTeal,
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

  // --- Date Input Helper ---
  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required LayerLink link,
    required ValueChanged<DateTime> onSelected,
    String? errorText,
    bool alignRight = false,
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
        CompositedTransformTarget(
          link: link,
          child: InkWell(
            onTap: () {
              _openAnchoredDatePicker(
                link: link,
                initialDate: value,
                onSelected: onSelected,
                alignRight: alignRight,
              );
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: _inputFill,
                border: Border(
                  bottom: BorderSide(
                    color: errorText != null ? const Color(0xFFD32F2F) : _headerTeal,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      value != null ? _formatDate(value) : '',
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

  // --- Time Input Helper ---
  Widget _buildTimeField({
    required String label,
    required TimeOfDay? value,
    required ValueChanged<TimeOfDay> onSelected,
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
          onTap: () => _pickTime(current: value, onSelected: onSelected),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: _inputFill,
              border: Border(
                bottom: BorderSide(
                  color: errorText != null ? const Color(0xFFD32F2F) : _headerTeal,
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value != null ? _formatTime(value) : '',
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

  // ==========================================
  // Form Sections
  // ==========================================

  // 1. Leave Section
  Widget _buildLeaveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Leave'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type of Leave',
                    style: TextStyle(fontSize: 11, color: Color(0xFF616161), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  CompositedTransformTarget(
                    link: _leaveTypeLayerLink,
                    child: InkWell(
                      key: const Key('leave_type_dropdown_trigger'),
                      onTap: _showLeaveTypeDropdown,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          color: _inputFill,
                          border: Border(bottom: BorderSide(color: _headerTeal, width: 1.5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedLeaveType ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF212121), fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: _headerTeal, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_leaveTypeError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(_leaveTypeError!, style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _switchHalfDay(!_isHalfDay),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: _isHalfDay,
                              activeColor: _headerTeal,
                              side: const BorderSide(color: Color(0xFF757575), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              onChanged: _switchHalfDay,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Half Day', style: TextStyle(fontSize: 11, color: Color(0xFF212121))),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _switchFullDay(!_isFullDay),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: _isFullDay,
                              activeColor: _headerTeal,
                              side: const BorderSide(color: Color(0xFF757575), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              onChanged: _switchFullDay,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Full Day', style: TextStyle(fontSize: 11, color: Color(0xFF212121))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDateField(
                label: _isHalfDay ? 'Date applied in:' : 'From:',
                value: _leaveFromDate,
                link: _leaveFromLayerLink,
                onSelected: (date) {
                  setState(() {
                    _leaveFromDate = date;
                    if (_leaveToDate != null && _leaveToDate!.isBefore(_leaveFromDate!)) {
                      _leaveToDate = _leaveFromDate;
                    }
                    _leaveDateError = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _isFullDay
                  ? _buildDateField(
                      label: 'To:',
                      value: _leaveToDate,
                      link: _leaveToLayerLink,
                      alignRight: true,
                      onSelected: (date) {
                        setState(() {
                          _leaveToDate = date;
                          _leaveDateError = null;
                        });
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        if (_leaveDateError != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(_leaveDateError!, style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10)),
          ),
      ],
    );
  }

  // 2. Timelogs Correction Section
  Widget _buildTimelogsCorrectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Timelogs Correction'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Date applied in',
                value: _timelogDate,
                link: _timelogDateLayerLink,
                errorText: _timelogDateError,
                onSelected: (date) {
                  setState(() {
                    _timelogDate = date;
                    _timelogDateError = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info, color: _infoColor, size: 22),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Either Time-In, Time-Out, or both are required.',
                        style: TextStyle(
                          color: _infoColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTimeField(
                label: 'Time-In',
                value: _timeIn,
                errorText: _timelogTimeError,
                onSelected: (t) {
                  setState(() {
                    _timeIn = t;
                    _timelogTimeError = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTimeField(
                label: 'Time-Out',
                value: _timeOut,
                errorText: _timelogTimeError,
                onSelected: (t) {
                  setState(() {
                    _timeOut = t;
                    _timelogTimeError = null;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Allowance Section
  Widget _buildAllowanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Allowance'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Date applied in',
                value: _allowanceDate,
                link: _allowanceDateLayerLink,
                errorText: _allowanceDateError,
                onSelected: (date) {
                  setState(() {
                    _allowanceDate = date;
                    _allowanceDateError = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: widget.allowanceOptions.map((opt) {
            final isSelected = _selectedAllowance == opt;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedAllowance = opt;
                  _allowanceOptionError = null;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? _headerTeal : const Color(0xFF757575),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(2.5),
                    child: isSelected
                        ? Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: _headerTeal,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    opt,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (_allowanceOptionError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _allowanceOptionError!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
            ),
          ),
      ],
    );
  }

  // 4. Overtime Section
  Widget _buildOvertimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Overtime'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Date applied in',
                value: _overtimeDate,
                link: _overtimeDateLayerLink,
                errorText: _overtimeDateError,
                onSelected: (date) {
                  setState(() {
                    _overtimeDate = date;
                    _overtimeDateError = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  // 5. Dayoff Work Section
  Widget _buildDayoffWorkSection() {
    final bool isGeneral = _typeOfDayoffWork == 'General';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Dayoff Work Detail'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Type of Dayoff dropdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type of Dayoff ...',
                    style: TextStyle(fontSize: 11, color: Color(0xFF616161), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  CompositedTransformTarget(
                    link: _dayoffTypeLayerLink,
                    child: InkWell(
                      key: const Key('dayoff_type_dropdown_trigger'),
                      onTap: _showDayoffTypeDropdown,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          color: _inputFill,
                          border: Border(bottom: BorderSide(color: _headerTeal, width: 1.5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _typeOfDayoffWork,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF212121), fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: _headerTeal, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Right: Notice callout
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info, color: _infoColor, size: 22),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isGeneral
                            ? 'This offday work will be compensated at the additional rate'
                            : 'This offday work will be compensated at normal rate',
                        style: const TextStyle(
                          color: _infoColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Subfields: Date applied in (General) OR From/To (Offset)
        if (isGeneral)
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Date applied in',
                  value: _dayoffGeneralDate,
                  link: _dayoffGeneralDateLayerLink,
                  errorText: _dayoffGeneralDateError,
                  onSelected: (date) {
                    setState(() {
                      _dayoffGeneralDate = date;
                      _dayoffGeneralDateError = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(child: SizedBox.shrink()),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'From',
                  value: _offsetFromDate,
                  link: _offsetFromLayerLink,
                  errorText: _offsetFromDateError,
                  onSelected: (date) {
                    setState(() {
                      _offsetFromDate = date;
                      _offsetFromDateError = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildDateField(
                  label: 'To',
                  value: _offsetToDate,
                  link: _offsetToLayerLink,
                  alignRight: true,
                  errorText: _offsetToDateError,
                  onSelected: (date) {
                    setState(() {
                      _offsetToDate = date;
                      _offsetToDateError = null;
                    });
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  // 6. Reshift Section
  Widget _buildReshiftSection() {
    String totalDisplay = '';
    if (_totalHours != null && _reshiftFormatError == null) {
      if (_totalHours == _totalHours!.roundToDouble()) {
        totalDisplay = '${_totalHours!.toInt()} Hours';
      } else {
        totalDisplay = '${_totalHours!.toStringAsFixed(2)} Hours';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Reshift'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Date applied in',
                value: _reshiftDate,
                link: _reshiftDateLayerLink,
                errorText: _reshiftDateError,
                onSelected: (date) {
                  setState(() {
                    _reshiftDate = date;
                    _reshiftDateError = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
        const SizedBox(height: 14),

        // 2-Column Shift breakdown table matching mobile reference
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: Column(
            children: [
              _buildReshiftTableRow(
                label: 'Work Start',
                value: _workStart != null ? _formatTime(_workStart!) : '',
                onTap: () => _pickTime(
                  current: _workStart,
                  onSelected: (t) {
                    setState(() => _workStart = t);
                    _computeReshiftTotal();
                  },
                ),
              ),
              _buildReshiftTableRow(
                label: 'Work Break Start',
                value: _breakStart != null ? _formatTime(_breakStart!) : '',
                onTap: () => _pickTime(
                  current: _breakStart,
                  onSelected: (t) {
                    setState(() => _breakStart = t);
                    _computeReshiftTotal();
                  },
                ),
              ),
              _buildReshiftTableRow(
                label: 'Work Break End',
                value: _breakEnd != null ? _formatTime(_breakEnd!) : '',
                onTap: () => _pickTime(
                  current: _breakEnd,
                  onSelected: (t) {
                    setState(() => _breakEnd = t);
                    _computeReshiftTotal();
                  },
                ),
              ),
              _buildReshiftTableRow(
                label: 'Work End',
                value: _workEnd != null ? _formatTime(_workEnd!) : '',
                onTap: () => _pickTime(
                  current: _workEnd,
                  onSelected: (t) {
                    setState(() => _workEnd = t);
                    _computeReshiftTotal();
                  },
                ),
              ),
              _buildReshiftTableRow(
                label: 'Total',
                value: totalDisplay,
                isLast: true,
              ),
            ],
          ),
        ),
        if (_reshiftFormatError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _reshiftFormatError!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
            ),
          ),
        if (_reshiftTimeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _reshiftTimeError!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
            ),
          ),
      ],
    );
  }

  Widget _buildReshiftTableRow({
    required String label,
    required String value,
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        children: [
          // Left dark label cell
          Expanded(
            flex: 5,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              color: const Color(0xFF2C2C2C),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Right white value cell
          Expanded(
            flex: 7,
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 38,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Shared Reason Section ---
  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Reason of request',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF616161),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_reasonError != null)
              Text(
                '*$_reasonError',
                style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: _inputFill,
            border: Border(
              bottom: BorderSide(
                color: _reasonError != null ? const Color(0xFFD32F2F) : _headerTeal,
                width: 1.5,
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: TextField(
                  controller: _reasonController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF212121)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                  ),
                  onChanged: (_) {
                    if (_reasonError != null) {
                      setState(() => _reasonError = null);
                    }
                  },
                ),
              ),
              const Positioned(
                right: 2,
                bottom: 2,
                child: IgnorePointer(
                  child: CustomPaint(
                    size: Size(12, 12),
                    painter: _TextareaGripperPainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekdayCell extends StatelessWidget {
  final String text;
  const _WeekdayCell(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF757575),
        ),
      ),
    );
  }
}

class _TextareaGripperPainter extends CustomPainter {
  const _TextareaGripperPainter();

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
