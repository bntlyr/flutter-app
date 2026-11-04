import 'dart:math';
import 'package:flutter/material.dart';

enum CalendarViewMode {
  days,
  months,
  years,
}

/// Reusable Cut-off Calendar Widget
/// Hover/Drag: Semi-circle indicator follows the cursor on the current hovered date only (no teal).
/// Confirmed selection: Solid teal highlight covers the entire selected date range.
class CalendarCutOff extends StatefulWidget {
  final String selectedCutoff;
  final ValueChanged<String>? onCutoffSelected;
  final VoidCallback? onClose;
  final int initialYear;
  final int initialMonth;

  const CalendarCutOff({
    super.key,
    this.selectedCutoff = 'Oct-01-2026 – Oct-15-2026',
    this.onCutoffSelected,
    this.onClose,
    this.initialYear = 2026,
    this.initialMonth = 10,
  });

  @override
  State<CalendarCutOff> createState() => _CalendarCutOffState();
}

class _CalendarCutOffState extends State<CalendarCutOff> {
  late int _year;
  late int _month;
  CalendarViewMode _viewMode = CalendarViewMode.days;
  late int _yearPageStart;

  // Confirmed selected state (Shows teal highlight across entire range)
  int? _confirmedStart;
  int? _confirmedEnd;

  // Hover / Drag state (Semi-circle follows cursor on current hovered date only)
  bool _isSelecting = false;
  int? _selectStart;
  int? _candidateEnd;
  int? _hoveredDay;

  static const Color _highlightBg = Color(0xFFE2F4F4);
  static const Color _circleColor = Color(0xFF47A5A0);

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initialYear;
    _month = widget.initialMonth;
    _yearPageStart = 2016 + (((_year - 2016) / 24).floor() * 24);
    _parseCutoff(widget.selectedCutoff);
  }

  @override
  void didUpdateWidget(CalendarCutOff oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCutoff != widget.selectedCutoff) {
      _parseCutoff(widget.selectedCutoff);
    }
  }

  void _parseCutoff(String cutoff) {
    final match = RegExp(
      r'([A-Za-z]{3})[-/ ](\d{1,2})[-/ ](\d{4})\s*[-–—]\s*([A-Za-z]{3})[-/ ](\d{1,2})[-/ ](\d{4})',
    ).firstMatch(cutoff);

    if (match != null) {
      final startMonthStr = match.group(1)!;
      final startDayStr = match.group(2)!;
      final startYearStr = match.group(3)!;
      final endDayStr = match.group(5)!;

      final mIdx = _monthNames.indexWhere(
        (m) => m.toLowerCase() == startMonthStr.toLowerCase(),
      );
      if (mIdx != -1) _month = mIdx + 1;
      _confirmedStart = int.tryParse(startDayStr) ?? 1;
      _year = int.tryParse(startYearStr) ?? widget.initialYear;
      _confirmedEnd = int.tryParse(endDayStr) ?? 15;
    } else {
      _confirmedStart = 1;
      _confirmedEnd = 15;
    }
    _yearPageStart = 2016 + (((_year - 2016) / 24).floor() * 24);
    _viewMode = CalendarViewMode.days;
    _isSelecting = false;
    _selectStart = null;
    _candidateEnd = null;
    _hoveredDay = null;
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  void _prevNav() {
    setState(() {
      if (_viewMode == CalendarViewMode.years) {
        _yearPageStart -= 24;
      } else if (_viewMode == CalendarViewMode.months) {
        _year--;
        _clampRangeToMonth();
      } else {
        if (_month == 1) {
          _month = 12;
          _year--;
        } else {
          _month--;
        }
        _clampRangeToMonth();
      }
    });
  }

  void _nextNav() {
    setState(() {
      if (_viewMode == CalendarViewMode.years) {
        _yearPageStart += 24;
      } else if (_viewMode == CalendarViewMode.months) {
        _year++;
        _clampRangeToMonth();
      } else {
        if (_month == 12) {
          _month = 1;
          _year++;
        } else {
          _month++;
        }
        _clampRangeToMonth();
      }
    });
  }

  void _onYearTapped(int year) {
    setState(() {
      _year = year;
      _clampRangeToMonth();
      _viewMode = CalendarViewMode.months;
    });
  }

  void _onMonthTapped(int month) {
    setState(() {
      _month = month;
      _clampRangeToMonth();
      _viewMode = CalendarViewMode.days;
    });
  }

  void _clampRangeToMonth() {
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    if (_confirmedStart != null && _confirmedStart! > daysInMonth) {
      _confirmedStart = daysInMonth;
    }
    if (_confirmedEnd != null && _confirmedEnd! > daysInMonth) {
      _confirmedEnd = daysInMonth;
    }
  }

  void _onDayTapped(int day) {
    setState(() {
      if (!_isSelecting || _selectStart == null) {
        // First tap: start selection
        _isSelecting = true;
        _selectStart = day;
        _candidateEnd = null;
        _hoveredDay = day;
      } else {
        // Second tap: set candidate end date
        _candidateEnd = day;
        _hoveredDay = day;
      }
    });
  }

  void _onHover(int day) {
    setState(() {
      _hoveredDay = day;
      if (_isSelecting) {
        _candidateEnd = day;
      }
    });
  }

  void _handlePointerDown(Offset localPos, double gridWidth) {
    final day = _getDayFromPos(localPos, gridWidth);
    if (day != null) {
      if (!_isSelecting || _selectStart == null) {
        _onDayTapped(day);
      }
    }
  }

  void _handlePointerMove(Offset localPos, double gridWidth) {
    final day = _getDayFromPos(localPos, gridWidth);
    if (day != null && day != _hoveredDay) {
      _onHover(day);
    }
  }

  int? _getDayFromPos(Offset localPos, double gridWidth) {
    final firstDay = DateTime(_year, _month, 1);
    final startCol = firstDay.weekday % 7;
    final daysInMonth = DateTime(_year, _month + 1, 0).day;

    final double colWidth = gridWidth / 7;
    const double rowHeight = 36.0;

    final int col = (localPos.dx / colWidth).floor().clamp(0, 6);
    final int row = (localPos.dy / rowHeight).floor().clamp(0, 5);

    final int day = row * 7 + col - startCol + 1;
    if (day >= 1 && day <= daysInMonth) {
      return day;
    }
    return null;
  }

  void _applySelection() {
    final target = _candidateEnd ?? _hoveredDay ?? _confirmedEnd ?? _selectStart ?? 15;
    final start = min(_selectStart ?? _confirmedStart ?? 1, target);
    final end = max(_selectStart ?? _confirmedStart ?? 1, target);

    setState(() {
      _confirmedStart = start;
      _confirmedEnd = end;
      _isSelecting = false;
      _selectStart = null;
      _candidateEnd = null;
      _hoveredDay = null;
    });

    final mStr = _monthNames[_month - 1];
    final rangeText = '$mStr-${_twoDigits(start)}-$_year – $mStr-${_twoDigits(end)}-$_year';
    widget.onCutoffSelected?.call(rangeText);
  }

  void _cancelSelection() {
    setState(() {
      _isSelecting = false;
      _selectStart = null;
      _candidateEnd = null;
      _hoveredDay = null;
    });
    widget.onClose?.call();
  }

  Widget _buildTopNav() {
    if (_viewMode == CalendarViewMode.years) {
      final int endYear = _yearPageStart + 23;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _prevNav,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_left, color: Color(0xFF616161), size: 20),
            ),
          ),
          InkWell(
            onTap: () => setState(() => _viewMode = CalendarViewMode.days),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _circleColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_yearPageStart – $endYear',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_up, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _nextNav,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_right, color: Color(0xFF616161), size: 20),
            ),
          ),
        ],
      );
    } else if (_viewMode == CalendarViewMode.months) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _prevNav,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_left, color: Color(0xFF616161), size: 20),
            ),
          ),
          InkWell(
            onTap: () => setState(() => _viewMode = CalendarViewMode.years),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _circleColor, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_year',
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_up, color: Color(0xFF616161), size: 18),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _nextNav,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_right, color: Color(0xFF616161), size: 20),
            ),
          ),
        ],
      );
    } else {
      // Days mode
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _prevNav,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_left, color: Color(0xFF616161), size: 20),
            ),
          ),
          InkWell(
            onTap: () => setState(() {
              _yearPageStart = 2016 + (((_year - 2016) / 24).floor() * 24);
              _viewMode = CalendarViewMode.years;
            }),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _circleColor, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_year',
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF616161), size: 18),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _nextNav,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_right, color: Color(0xFF616161), size: 20),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildYearGrid() {
    final List<Widget> rows = [];
    for (int r = 0; r < 6; r++) {
      final List<Widget> cols = [];
      for (int c = 0; c < 4; c++) {
        final int year = _yearPageStart + (r * 4 + c);
        final bool isSelected = year == _year;

        Widget cellContent;
        if (isSelected) {
          cellContent = Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _circleColor, width: 1),
            ),
            child: Container(
              width: 48,
              height: 26,
              decoration: BoxDecoration(
                color: _circleColor,
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.center,
              child: Text(
                '$year',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        } else {
          cellContent = Container(
            height: 32,
            alignment: Alignment.center,
            child: Text(
              '$year',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF212121),
              ),
            ),
          );
        }

        cols.add(
          Expanded(
            child: InkWell(
              onTap: () => _onYearTapped(year),
              borderRadius: BorderRadius.circular(4),
              child: Center(child: cellContent),
            ),
          ),
        );
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: cols),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 12, thickness: 1, color: Color(0xFFEEEEEE)),
        ...rows,
      ],
    );
  }

  Widget _buildMonthGrid() {
    final List<Widget> rows = [];
    final List<String> monthsUpper = [
      'JAN', 'FEB', 'MAR', 'APR',
      'MAY', 'JUN', 'JUL', 'AUG',
      'SEP', 'OCT', 'NOV', 'DEC',
    ];

    for (int r = 0; r < 3; r++) {
      final List<Widget> cols = [];
      for (int c = 0; c < 4; c++) {
        final int mIndex = r * 4 + c;
        final int monthNum = mIndex + 1;
        final String mName = monthsUpper[mIndex];

        final bool isSelected = monthNum == _month;
        final bool isOctOutlined = !isSelected && monthNum == 10;

        Widget cellContent;
        if (isSelected) {
          cellContent = Container(
            width: 52,
            height: 28,
            decoration: BoxDecoration(
              color: _circleColor,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              mName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        } else if (isOctOutlined) {
          cellContent = Container(
            width: 52,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF757575), width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              mName,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF212121),
              ),
            ),
          );
        } else {
          cellContent = Container(
            width: 52,
            height: 28,
            alignment: Alignment.center,
            child: Text(
              mName,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF212121),
              ),
            ),
          );
        }

        cols.add(
          Expanded(
            child: InkWell(
              onTap: () => _onMonthTapped(monthNum),
              borderRadius: BorderRadius.circular(14),
              child: Center(child: cellContent),
            ),
          ),
        );
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: cols),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 12, thickness: 1, color: Color(0xFFEEEEEE)),
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 4, bottom: 8),
          child: Text(
            '$_year',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575),
            ),
          ),
        ),
        ...rows,
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 275,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopNav(),
            if (_viewMode == CalendarViewMode.years) ...[
              _buildYearGrid(),
            ] else if (_viewMode == CalendarViewMode.months) ...[
              _buildMonthGrid(),
            ] else ...[
              const SizedBox(height: 8),

              // Weekday Headers: Su Mo Tu We Th Fr Sa
              const Row(
                children: [
                  Expanded(child: Center(child: Text('Su', style: TextStyle(color: Color(0xFF757575), fontSize: 11)))),
                  Expanded(child: Center(child: Text('Mo', style: TextStyle(color: Color(0xFF757575), fontSize: 11)))),
                  Expanded(child: Center(child: Text('Tu', style: TextStyle(color: Color(0xFF757575), fontSize: 11)))),
                  Expanded(child: Center(child: Text('We', style: TextStyle(color: Color(0xFF757575), fontSize: 11)))),
                  Expanded(child: Center(child: Text('Th', style: TextStyle(color: Color(0xFF757575), fontSize: 11)))),
                  Expanded(child: Center(child: Text('Fr', style: TextStyle(color: Color(0xFF757575), fontSize: 11)))),
                  Expanded(child: Center(child: Text('Sa', style: TextStyle(color: Color(0xFF757575), fontSize: 11)))),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 4),

              // Drag/Hover-enabled Calendar Grid
              LayoutBuilder(
                builder: (ctx, constraints) {
                  return Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (e) => _handlePointerDown(e.localPosition, constraints.maxWidth),
                    onPointerMove: (e) => _handlePointerMove(e.localPosition, constraints.maxWidth),
                    child: Column(
                      children: _buildWeeks(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 6),

              // Bottom action bar: Range preview + Cancel & Apply
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isSelecting
                          ? '${_monthNames[_month - 1]} ${_selectStart ?? 1} – ${_candidateEnd ?? _hoveredDay ?? _selectStart ?? 15}'
                          : '${_monthNames[_month - 1]} ${_confirmedStart ?? 1} – ${_confirmedEnd ?? 15}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _isSelecting ? const Color(0xFF0F766E) : const Color(0xFF334155),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _cancelSelection,
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: _applySelection,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _circleColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWeeks() {
    final firstDay = DateTime(_year, _month, 1);
    final startCol = firstDay.weekday % 7;
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final monthAbbr = _monthNames[_month - 1].toUpperCase();

    // Confirmed state bounds (Shows teal highlight ONLY when not selecting)
    final int? solidStart = !_isSelecting ? _confirmedStart : null;
    final int? solidEnd = !_isSelecting ? _confirmedEnd : null;

    List<Widget> weekRows = [];
    int currentDay = 1;

    if (startCol == 0) {
      weekRows.add(
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              monthAbbr,
              style: const TextStyle(
                color: Color(0xFF616161),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    }

    for (int row = 0; currentDay <= daysInMonth; row++) {
      List<Widget> cells = [];

      if (row == 0 && startCol > 0) {
        cells.add(
          Expanded(
            flex: startCol,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  monthAbbr,
                  style: const TextStyle(
                    color: Color(0xFF616161),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
        for (int col = startCol; col < 7; col++) {
          if (currentDay <= daysInMonth) {
            final d = currentDay;
            cells.add(Expanded(flex: 1, child: _buildDayCell(d, solidStart, solidEnd)));
            currentDay++;
          }
        }
      } else {
        for (int col = 0; col < 7; col++) {
          if (currentDay <= daysInMonth) {
            final d = currentDay;
            cells.add(Expanded(flex: 1, child: _buildDayCell(d, solidStart, solidEnd)));
            currentDay++;
          } else {
            cells.add(const Expanded(flex: 1, child: SizedBox()));
          }
        }
      }

      weekRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SizedBox(height: 32, child: Row(children: cells)),
        ),
      );
    }

    return weekRows;
  }

  Widget _buildDayCell(int d, int? solidStart, int? solidEnd) {
    // 1. Confirmed solid teal flags (ONLY when !_isSelecting)
    final bool isSolidStart = !_isSelecting && d == solidStart;
    final bool isSolidEnd = !_isSelecting && d == solidEnd;
    final bool inSolidRange = !_isSelecting &&
        solidStart != null &&
        solidEnd != null &&
        d >= solidStart &&
        d <= solidEnd;

    // 2. Candidate hover / drag range (ONLY when _isSelecting && _selectStart != null)
    final int? activeTarget = _hoveredDay ?? _candidateEnd;
    final int? candStart = (_isSelecting && _selectStart != null && activeTarget != null)
        ? min(_selectStart!, activeTarget)
        : null;
    final int? candEnd = (_isSelecting && _selectStart != null && activeTarget != null)
        ? max(_selectStart!, activeTarget)
        : null;

    final bool inCandRange =
        candStart != null && candEnd != null && d >= candStart && d <= candEnd;
    final bool isCandStart = inCandRange && d == candStart;
    final bool isCandEnd = inCandRange && d == candEnd;

    // Solid teal ribbon background (ONLY when confirmed, NEVER while dragging or hovering)
    Widget? backgroundStrip;
    if (inSolidRange) {
      if (solidStart == solidEnd) {
        backgroundStrip = null;
      } else if (isSolidStart) {
        backgroundStrip = Row(
          children: [
            const Expanded(child: SizedBox()),
            Expanded(child: Container(color: _highlightBg)),
          ],
        );
      } else if (isSolidEnd) {
        backgroundStrip = Row(
          children: [
            Expanded(child: Container(color: _highlightBg)),
            const Expanded(child: SizedBox()),
          ],
        );
      } else {
        backgroundStrip = Container(color: _highlightBg);
      }
    }

    // Dashed ribbon painter (Hover / drag range preview connecting start to target)
    Widget? dashedStrip;
    if (inCandRange && candStart != candEnd) {
      final bool startIsAnchor = _selectStart == candStart;
      if (isCandStart) {
        dashedStrip = Positioned.fill(
          child: CustomPaint(
            painter: DashedRibbonPainter(
              hasLineRight: true,
              isLeftCap: !startIsAnchor,
            ),
          ),
        );
      } else if (isCandEnd) {
        dashedStrip = Positioned.fill(
          child: CustomPaint(
            painter: DashedRibbonPainter(
              hasLineLeft: true,
              isRightCap: startIsAnchor,
            ),
          ),
        );
      } else {
        // Intermediate day: continuous dashed lines across cell width
        dashedStrip = Positioned.fill(
          child: CustomPaint(
            painter: DashedRibbonPainter(
              hasLineLeft: true,
              hasLineRight: true,
            ),
          ),
        );
      }
    }

    // Foreground styling
    Widget foreground;

    if (isSolidStart || isSolidEnd) {
      // Confirmed range endpoint: Solid teal circle with white bold text
      foreground = Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: _circleColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$d',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    } else if (_isSelecting && d == _selectStart) {
      // Selection anchor date: Solid teal circle
      foreground = Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: _circleColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$d',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    } else if (_isSelecting && activeTarget != null && d == activeTarget && d != _selectStart) {
      // Candidate target under cursor: semi-circle cap with faint circle tint
      foreground = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _circleColor.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$d',
          style: const TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    } else if (!_isSelecting && d == _hoveredDay) {
      // Hovering date before selection starts: faint circular tint
      foreground = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _circleColor.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$d',
          style: const TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    } else if (d == 30 && !inSolidRange) {
      // Day 30 ring outline
      foreground = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF757575), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          '$d',
          style: const TextStyle(fontSize: 12, color: Color(0xFF212121)),
        ),
      );
    } else {
      foreground = Text(
        '$d',
        style: const TextStyle(fontSize: 12, color: Color(0xFF212121)),
      );
    }

    return MouseRegion(
      onEnter: (_) => _onHover(d),
      onExit: (_) => setState(() {
        if (_hoveredDay == d) _hoveredDay = null;
      }),
      child: InkWell(
        onTap: () => _onDayTapped(d),
        borderRadius: BorderRadius.circular(14),
        hoverColor: Colors.transparent,
        child: SizedBox(
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (backgroundStrip != null) Positioned.fill(child: backgroundStrip),
              ?dashedStrip,
              foreground,
            ],
          ),
        ),
      ),
    );
  }
}

/// Dashed ribbon painter connecting start date to hovered target date with semi-circle cap
class DashedRibbonPainter extends CustomPainter {
  final bool hasLineLeft;
  final bool hasLineRight;
  final bool isLeftCap;
  final bool isRightCap;
  final Color color;

  DashedRibbonPainter({
    this.hasLineLeft = false,
    this.hasLineRight = false,
    this.isLeftCap = false,
    this.isRightCap = false,
    this.color = const Color(0xFF616161),
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 14.0;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double topY = centerY - radius;
    final double bottomY = centerY + radius;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final Path path = Path();

    if (isRightCap) {
      if (hasLineLeft) {
        path.moveTo(0, topY);
        path.lineTo(centerX, topY);
      } else {
        path.moveTo(centerX, topY);
      }
      path.arcTo(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        -pi / 2,
        pi,
        false,
      );
      if (hasLineLeft) {
        path.lineTo(0, bottomY);
      }
    } else if (isLeftCap) {
      if (hasLineRight) {
        path.moveTo(size.width, topY);
        path.lineTo(centerX, topY);
      } else {
        path.moveTo(centerX, topY);
      }
      path.arcTo(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        -pi / 2,
        -pi,
        false,
      );
      if (hasLineRight) {
        path.lineTo(size.width, bottomY);
      }
    } else {
      final double startX = hasLineLeft ? 0 : centerX;
      final double endX = hasLineRight ? size.width : centerX;
      if (startX != endX) {
        path.moveTo(startX, topY);
        path.lineTo(endX, topY);
        path.moveTo(startX, bottomY);
        path.lineTo(endX, bottomY);
      }
    }

    const double dashWidth = 3.0;
    const double dashSpace = 2.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = min(dashWidth, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRibbonPainter oldDelegate) {
    return oldDelegate.hasLineLeft != hasLineLeft ||
        oldDelegate.hasLineRight != hasLineRight ||
        oldDelegate.isLeftCap != isLeftCap ||
        oldDelegate.isRightCap != isRightCap ||
        oldDelegate.color != color;
  }
}
