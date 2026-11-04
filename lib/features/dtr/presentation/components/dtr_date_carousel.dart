import 'package:flutter/material.dart';
import 'dtr_sample_data.dart';

/// Horizontal Date Carousel for DTR:
/// - Left & right scroll chevrons
/// - Calendar-style date buttons: Weekday (red on Sunday, blue on Saturday), Month, Date
/// - Active teal indicator line below the selected day
class DtrDateCarousel extends StatefulWidget {
  final List<DtrMobileDayItem> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const DtrDateCarousel({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  State<DtrDateCarousel> createState() => _DtrDateCarouselState();
}

class _DtrDateCarouselState extends State<DtrDateCarousel> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    final target = (_scrollController.offset - 160).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final target = (_scrollController.offset + 160).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(DtrDateCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.days != widget.days) {
      _scrollToIndex(widget.selectedIndex);
    }
  }

  void _scrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = (index * 48.0 - 80.0).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getWeekdayLetter(DateTime d) {
    switch (d.weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'T';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF50B5A6);
    const sundayRed = Color(0xFFE53935);
    const saturdayBlue = Color(0xFF1E88E5);

    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Left chevron
          InkWell(
            onTap: _scrollLeft,
            borderRadius: BorderRadius.circular(4),
            child: const SizedBox(
              width: 30,
              height: double.infinity,
              child: Icon(
                Icons.chevron_left,
                size: 22,
                color: Color(0xFF64748B),
              ),
            ),
          ),

          // Scrollable Day Buttons
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.days.length,
              itemBuilder: (context, index) {
                final day = widget.days[index];
                final isSelected = index == widget.selectedIndex;
                final isSunday = day.date.weekday == DateTime.sunday;
                final isSaturday = day.date.weekday == DateTime.saturday;

                final dayColor = isSunday
                    ? sundayRed
                    : (isSaturday ? saturdayBlue : const Color(0xFF334155));

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onDaySelected(index),
                  child: Container(
                    width: 44,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? tealColor : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.2 : 0.8,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getWeekdayLetter(day.date),
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                            color: dayColor,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          const [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                          ][day.date.month - 1],
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.1,
                            color: dayColor.withAlpha(200),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          day.date.day.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                            color: dayColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: 2,
                          width: 20,
                          decoration: BoxDecoration(
                            color: isSelected ? tealColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Right chevron
          InkWell(
            onTap: _scrollRight,
            borderRadius: BorderRadius.circular(4),
            child: const SizedBox(
              width: 30,
              height: double.infinity,
              child: Icon(
                Icons.chevron_right,
                size: 22,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
