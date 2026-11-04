import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/mock/mock_attendance_data.dart';
import '../components/portal_action_buttons.dart';
import '../components/portal_analog_clock.dart';
import '../components/portal_attendance_alert_card.dart';
import '../components/portal_attendance_summary_card.dart';
import '../components/portal_manual_time_dialog.dart';
import '../components/portal_payroll_summary_card.dart';

/// Employee Portal Screen matching web-app reference (TopComponent).
class PortalScreen extends StatefulWidget {
  final Function(int targetIndex)? onNavigateToTab;

  const PortalScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  late DateTime _currentTime;
  Timer? _clockTimer;
  bool _isClockedIn = false;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _openManualTimeDialog({required bool isTimeIn}) {
    PortalManualTimeDialog.show(
      context: context,
      isTimeIn: isTimeIn,
      onConfirmed: () {
        if (isTimeIn) {
          _handleTimeIn();
        } else {
          _handleTimeOut();
        }
      },
    );
  }

  void _handleTimeIn() {
    setState(() => _isClockedIn = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF50B5A6),
        content: Text('Successfully Clocked In!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTimeOut() {
    setState(() => _isClockedIn = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFFD65A4F),
        content: Text('Successfully Clocked Out!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = MockAttendanceData.activeAlerts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Clock Card (Analog Clock + Date + Big Digital Time)
            PortalAnalogClockCard(currentTime: _currentTime),
            const SizedBox(height: 12),

            // 2. Action Buttons (Time-In Now / Time-Out Now)
            PortalActionButtons(
              onTimeIn: () => _openManualTimeDialog(isTimeIn: true),
              onTimeOut: () => _openManualTimeDialog(isTimeIn: false),
              isTimeInDisabled: _isClockedIn,
              isTimeOutDisabled: !_isClockedIn,
            ),
            const SizedBox(height: 22),

            // 3. Attendance Alert Card
            PortalAttendanceAlertCard(
              alerts: alerts,
              latestUpdate: _currentTime,
            ),
            const SizedBox(height: 24),

            // 4. Attendance Summary Card
            const PortalAttendanceSummaryCard(
              balanceLeaveDays: 23.1,
              totalLateMins: 0,
              totalOvertimeMins: 0,
            ),
            const SizedBox(height: 24),

            // 5. Payroll Summary Card
            const PortalPayrollSummaryCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
