import 'package:flutter/material.dart';
import 'components/dtr_cutoff_header.dart';
import 'components/dtr_date_carousel.dart';
import 'components/dtr_sample_data.dart';
import 'components/dtr_selected_date_details.dart';
import 'components/dtr_summary_card.dart';

/// Mobile DTR (Daily Time Records) Screen matching web-app mobile attendance:
/// - Refresh logs button
/// - Cut-off calendar selector
/// - Collapsible Cutoff Summary card with full Day & Night compensations
/// - Horizontal Date Carousel (weekdays, months, numbers, active underline)
/// - Selected date card and dynamic details (Approved Requests, Punctuality,
///   Day Rate Compensations, Night Rate Compensations, Allowances)
class DtrScreen extends StatefulWidget {
  final Function(int targetIndex)? onNavigateToTab;
  final String? initialCutoff;

  const DtrScreen({
    super.key,
    this.onNavigateToTab,
    this.initialCutoff,
  });

  /// Computes the active payroll cut-off dynamically based on date.
  /// 1st to 15th: 1st half of month
  /// 16th to end: 2nd half of month
  static String getDefaultCutoff([DateTime? date]) {
    final now = date ?? DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthStr = months[now.month - 1];
    final year = now.year;
    if (now.day <= 15) {
      return '$monthStr-01-$year – $monthStr-15-$year';
    } else {
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      return '$monthStr-16-$year – $monthStr-$lastDay-$year';
    }
  }

  @override
  State<DtrScreen> createState() => _DtrScreenState();
}

class _DtrScreenState extends State<DtrScreen> {
  late String _cutoffText;
  late DtrCutoffData _cutoffData;
  int _selectedDayIndex = 0;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _cutoffText = widget.initialCutoff ?? DtrScreen.getDefaultCutoff();
    _cutoffData = DtrSampleData.getCutoff(_cutoffText);
    final now = DateTime.now();
    final foundIndex = _cutoffData.days.indexWhere(
      (d) =>
          d.date.year == now.year &&
          d.date.month == now.month &&
          d.date.day == now.day,
    );
    _selectedDayIndex = foundIndex >= 0 ? foundIndex : 0;
  }

  void _onCutoffChanged(String newCutoff) {
    setState(() {
      _cutoffText = newCutoff;
      _cutoffData = DtrSampleData.getCutoff(newCutoff);
      _selectedDayIndex = 0;
    });
  }

  Future<void> _handleRefreshLogs() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('DTR logs updated.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = (_selectedDayIndex >= 0 &&
            _selectedDayIndex < _cutoffData.days.length)
        ? _cutoffData.days[_selectedDayIndex]
        : _cutoffData.days.first;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Cut-off Header & Refresh Logs
            DtrCutoffHeader(
              cutoffText: _cutoffText,
              onCutoffChanged: _onCutoffChanged,
              onRefreshLogs: _handleRefreshLogs,
              isRefreshing: _isRefreshing,
            ),
            const SizedBox(height: 12),

            // 2. Collapsible Summary Card
            DtrSummaryCard(cutoffData: _cutoffData),
            const SizedBox(height: 12),

            // 3. Horizontal Date Carousel
            DtrDateCarousel(
              days: _cutoffData.days,
              selectedIndex: _selectedDayIndex,
              onDaySelected: (idx) {
                setState(() => _selectedDayIndex = idx);
              },
            ),
            const SizedBox(height: 12),

            // 4. Selected Day Details
            DtrSelectedDateDetails(day: selectedDay),
          ],
        ),
      ),
    );
  }
}
