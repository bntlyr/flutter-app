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

  const DtrScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<DtrScreen> createState() => _DtrScreenState();
}

class _DtrScreenState extends State<DtrScreen> {
  late String _cutoffText;
  late DtrCutoffData _cutoffData;
  int _selectedDayIndex = 3; // Default to Oct 19
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _cutoffText = 'Oct-16-26 — Oct-31-26';
    _cutoffData = DtrSampleData.getCutoff(_cutoffText);
    // Find default day (Oct 19) or default to 0
    final foundIndex = _cutoffData.days.indexWhere((d) => d.date.day == 19);
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
