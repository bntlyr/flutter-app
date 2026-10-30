import 'dart:math';
import 'package:flutter/material.dart';

enum CalendarDateViewMode {
  days,
  months,
  years,
}

/// Reusable Date Range Calendar Widget
/// Default data is EMPTY.
/// Supports Year view (2016-2039), Month view (JAN-DEC), and Day view.
/// Hover/Drag: Dashed ribbon with semi-circle cap connects start date to hovered date.
/// Confirmed selection: Solid teal highlight covers confirmed range after Apply.
class CalendarDate extends StatefulWidget {
  final String? selectedDateRange;
  final ValueChanged<String>? onDateRangeSelected;
  final VoidCallback? onClose;
  final int initialYear;
  final int initialMonth;

  const CalendarDate({
    super.key,
    this.selectedDateRange,
    this.onDateRangeSelected,
    this.onClose,
    this.initialYear = 2026,
    this.initialMonth = 10,
  });

  @override
  State<CalendarDate> createState() => _CalendarDateState();
}

class _CalendarDateState extends State<CalendarDate> {
  late int _year;
  late int _month;
  CalendarDateViewMode _viewMode = CalendarDateViewMode.days;
  late int _yearPageStart;

  // Confirmed selected state (default is EMPTY / null)
  int? _confirmedStart;
  int? _confirmedEnd;

  // Hover / Drag state
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
    _parseDateRange(widget.selectedDateRange);
  }

  @override
  void didUpdateWidget(CalendarDate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDateRange != widget.selectedDateRange) {
      _parseDateRange(widget.selectedDateRange);
    }
  }

  void _parseDateRange(String? dateRange) {
    if (dateRange != null && dateRange.trim().isNotEmpty) {
      final match = RegExp(
        r'([A-Za-z]{3,9})[-/ ]+(\d{1,2})[-/ ,]+(\d{4})\s*[-–—/]\s*([A-Za-z]{3,9})?[-/ ]*(\d{1,2})[-/ ,]+(\d{4})',
      ).firstMatch(dateRange);

      if (match != null) {
        final startMonthStr = match.group(1)!;
        final startDayStr = match.group(2)!;
        final startYearStr = match.group(3)!;
        final endDayStr = match.group(5)!;

        final mIdx = _monthNames.indexWhere(
          (m) => startMonthStr.toLowerCase().startsWith(m.toLowerCase()),
        );
        if (mIdx != -1) _month = mIdx + 1;
        _confirmedStart = int.tryParse(startDayStr);
        _year = int.tryParse(startYearStr) ?? widget.initialYear;
        _confirmedEnd = int.tryParse(endDayStr);
      } else {
        _confirmedStart = null;
        _confirmedEnd = null;
      }
    } else {
      // Default is empty
      _confirmedStart = null;
      _confirmedEnd = null;
    }

    _yearPageStart = 2016 + (((_year - 2016) / 24).floor() * 24);
    _viewMode = CalendarDateViewMode.days;
    _isSelecting = false;
    _selectStart = null;
    _candidateEnd = null;
    _hoveredDay = null;
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  void _prevNav() {
    setState(() {
      if (_viewMode == CalendarDateViewMode.years) {
        _yearPageStart -= 24;
      } else if (_viewMode == CalendarDateViewMode.months) {
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
      if (_viewMode == CalendarDateViewMode.years) {
        _yearPageStart += 24;
      } else if (_viewMode == CalendarDateViewMode.months) {
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
      _viewMode = CalendarDateViewMode.months;
    });
  }

  void _onMonthTapped(int month) {
    setState(() {
      _month = month;
      _clampRangeToMonth();
      _viewMode = CalendarDateViewMode.days;
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
        _isSelecting = true;
        _selectStart = day;
        _candidateEnd = null;
        _hoveredDay = day;
      } else {
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
    if (_selectStart == null && _confirmedStart == null) {
      widget.onClose?.call();
      return;
    }

    final target = _candidateEnd ?? _hoveredDay ?? _confirmedEnd ?? _selectStart;
    final start = min(_selectStart ?? _confirmedStart ?? 1, target ?? _selectStart ?? 1);
    final end = max(_selectStart ?? _confirmedStart ?? 1, target ?? _selectStart ?? 1);

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
    widget.onDateRangeSelected?.call(rangeText);
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
    if (_viewMode == CalendarDateViewMode.years) {
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
            onTap: () => setState(() => _viewMode = CalendarDateViewMode.days),
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
    } else if (_viewMode == CalendarDateViewMode.months) {
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
            onTap: () => setState(() => _viewMode = CalendarDateViewMode.years),
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
              _viewMode = CalendarDateViewMode.years;
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

  List<Widget> _buildWeeks() {
    final firstDay = DateTime(_year, _month, 1);
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final startCol = firstDay.weekday % 7;

    final solidStart = _confirmedStart;
    final solidEnd = _confirmedEnd;

    final List<Widget> weekRows = [];
    int currentDay = 1;

    for (int row = 0; row < 6; row++) {
      if (currentDay > daysInMonth) break;

      final List<Widget> cells = [];
      for (int col = 0; col < 7; col++) {
        if (row == 0 && col < startCol) {
          if (col == 0) {
            cells.add(
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    _monthNames[_month - 1].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
              ),
            );
          } else {
            cells.add(const Expanded(flex: 1, child: SizedBox()));
          }
        } else {
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
    final bool isSolidStart = !_isSelecting && solidStart != null && d == solidStart;
    final bool isSolidEnd = !_isSelecting && solidEnd != null && d == solidEnd;
    final bool inSolidRange = !_isSelecting &&
        solidStart != null &&
        solidEnd != null &&
        d >= solidStart &&
        d <= solidEnd;

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

    Widget? dashedStrip;
    if (inCandRange && candStart != candEnd) {
      final bool startIsAnchor = _selectStart == candStart;
      if (isCandStart) {
        dashedStrip = Positioned.fill(
          child: CustomPaint(
            painter: DateRibbonPainter(
              hasLineRight: true,
              isLeftCap: !startIsAnchor,
            ),
          ),
        );
      } else if (isCandEnd) {
        dashedStrip = Positioned.fill(
          child: CustomPaint(
            painter: DateRibbonPainter(
              hasLineLeft: true,
              isRightCap: startIsAnchor,
            ),
          ),
        );
      } else {
        dashedStrip = Positioned.fill(
          child: CustomPaint(
            painter: DateRibbonPainter(
              hasLineLeft: true,
              hasLineRight: true,
            ),
          ),
        );
      }
    }

    Widget foreground;

    if (isSolidStart || isSolidEnd) {
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
            if (_viewMode == CalendarDateViewMode.years) ...[
              _buildYearGrid(),
            ] else if (_viewMode == CalendarDateViewMode.months) ...[
              _buildMonthGrid(),
            ] else ...[
              const SizedBox(height: 8),
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

              // Bottom action bar
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isSelecting
                          ? '${_monthNames[_month - 1]} ${_selectStart ?? 1} – ${_candidateEnd ?? _hoveredDay ?? _selectStart ?? 15}'
                          : (_confirmedStart != null && _confirmedEnd != null
                              ? '${_monthNames[_month - 1]} $_confirmedStart – $_confirmedEnd'
                              : 'Select date range'),
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
}

/// Dashed ribbon painter connecting start date to hovered date with semi-circle cap
class DateRibbonPainter extends CustomPainter {
  final bool hasLineLeft;
  final bool hasLineRight;
  final bool isLeftCap;
  final bool isRightCap;
  final Color color;

  DateRibbonPainter({
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
  bool shouldRepaint(covariant DateRibbonPainter oldDelegate) {
    return oldDelegate.hasLineLeft != hasLineLeft ||
        oldDelegate.hasLineRight != hasLineRight ||
        oldDelegate.isLeftCap != isLeftCap ||
        oldDelegate.isRightCap != isRightCap ||
        oldDelegate.color != color;
  }
}
