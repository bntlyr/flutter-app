import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../data/mock/mock_attendance_data.dart';
import '../../../data/mock/mock_payslip_data.dart';
import '../../../data/models/attendance_model.dart';
import '../../shared/metric_card.dart';
import '../../shared/section_header.dart';

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
  String? _lastTimeIn = '08:02 AM';
  String? _lastTimeOut;
  bool _isClockedIn = true;

  // View mode toggles for tables
  bool _isAlertsTableView = false;
  bool _isPayrollTableView = false;

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

  void _handleTimeIn() {
    final nowStr = AppFormatters.time(DateTime.now());
    setState(() {
      _lastTimeIn = nowStr;
      _isClockedIn = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Text('Successfully Clocked In at $nowStr!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTimeOut() {
    final nowStr = AppFormatters.time(DateTime.now());
    setState(() {
      _lastTimeOut = nowStr;
      _isClockedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.gray,
        content: Text('Successfully Clocked Out at $nowStr! Shift recorded.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final summary = MockAttendanceData.currentSummary;
    final alerts = MockAttendanceData.activeAlerts;
    final payrollItems = MockPayslipData.payrollSummaryList;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Clock View, Date View, & Time In / Time Out
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gray,
                    AppColors.gray.withAlpha(240),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 16, color: primary),
                          const SizedBox(width: 8),
                          Text(
                            AppFormatters.dateWithDay(_currentTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isClockedIn
                              ? AppColors.primary.withAlpha(50)
                              : Colors.orange.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isClockedIn ? AppColors.primary : Colors.orange,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isClockedIn ? AppColors.primary : Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isClockedIn ? 'CLOCKED IN' : 'CLOCKED OUT',
                              style: TextStyle(
                                color: _isClockedIn ? AppColors.primaryLight : Colors.orange[200],
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Big Clock Display
                  Text(
                    AppFormatters.timeWithSeconds(_currentTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isClockedIn
                        ? 'Today Log: In at $_lastTimeIn • Shift: 08:00 AM - 05:00 PM'
                        : (_lastTimeOut != null
                            ? 'Clocked out at $_lastTimeOut'
                            : 'No punch recorded yet today'),
                    style: TextStyle(
                      color: Colors.white.withAlpha(190),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Time In / Time Out Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isClockedIn ? null : _handleTimeIn,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: Colors.white12,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.login),
                          label: const Text(
                            'Time In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: !_isClockedIn ? null : _handleTimeOut,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white38),
                            disabledForegroundColor: Colors.white24,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Time Out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Attendance Summary Cards
          const SectionHeader(
            title: 'Attendance Summary',
            subtitle: 'Current Cutoff Metric Overview',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              final crossAxisCount = isWide ? 4 : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MetricCard(
                    title: 'Present Days',
                    value: '${summary.presentDays}/${summary.totalWorkDays}',
                    subtitle: 'Workdays logged',
                    icon: Icons.calendar_month_outlined,
                    highlight: true,
                  ),
                  MetricCard(
                    title: 'Late Incidents',
                    value: '${summary.lateCount}',
                    subtitle: '${summary.lateMinutes} mins total',
                    icon: Icons.timer_outlined,
                    accentColor: Colors.orange,
                  ),
                  MetricCard(
                    title: 'Overtime Hours',
                    value: '${summary.overtimeHours} hrs',
                    subtitle: 'Approved OT',
                    icon: Icons.more_time_outlined,
                    accentColor: AppColors.primary,
                  ),
                  MetricCard(
                    title: 'Leave Credits',
                    value: '${summary.leaveCreditsRemaining}',
                    subtitle: 'Days available',
                    icon: Icons.beach_access_outlined,
                    accentColor: AppColors.primary,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // 3. Attendance Alerts Table / Cards
          SectionHeader(
            title: 'Attendance Alerts',
            subtitle: 'Unresolved punches & attendance exceptions',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: _isAlertsTableView ? 'Switch to Card List' : 'Switch to Table View',
                  icon: Icon(
                    _isAlertsTableView ? Icons.view_agenda_outlined : Icons.table_chart_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isAlertsTableView = !_isAlertsTableView;
                    });
                  },
                ),
                TextButton.icon(
                  onPressed: () => widget.onNavigateToTab?.call(2), // Navigate to Request
                  icon: const Icon(Icons.add_task, size: 16),
                  label: const Text('Resolve'),
                ),
              ],
            ),
          ),
          if (alerts.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No active attendance alerts. Great job!'),
                ),
              ),
            )
          else if (!_isAlertsTableView)
            // Mobile-Optimized Alert Cards View (100% visible, no horizontal panning needed!)
            Column(
              children: alerts.map((alert) {
                final severityColor = switch (alert.severity) {
                  AlertSeverity.high => AppColors.error,
                  AlertSeverity.medium => Colors.orange,
                  AlertSeverity.low => AppColors.grayLight,
                };

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: severityColor.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.warning_amber_rounded, size: 16, color: severityColor),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                alert.alertType,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: severityColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                alert.severity.name.toUpperCase(),
                                style: TextStyle(
                                  color: severityColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${AppFormatters.dateShort(alert.date)} • ${alert.timeDetail}',
                          style: const TextStyle(fontSize: 12, color: AppColors.grayLight),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              alert.title,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => widget.onNavigateToTab?.call(2),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                visualDensity: VisualDensity.compact,
                              ),
                              icon: const Icon(Icons.edit_calendar, size: 14),
                              label: Text(alert.recommendedAction, style: const TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          else
            // Full Raw DataTable View with Horizontal Scroll
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: AppColors.surfaceLight,
                    child: const Text(
                      '⇄ Swipe horizontally to inspect table columns',
                      style: TextStyle(fontSize: 11, color: AppColors.grayLight),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceLight),
                      columns: const [
                        DataColumn(label: Text('Alert Type', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Severity', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: alerts.map((alert) {
                        final severityColor = switch (alert.severity) {
                          AlertSeverity.high => AppColors.error,
                          AlertSeverity.medium => Colors.orange,
                          AlertSeverity.low => AppColors.grayLight,
                        };

                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, size: 16, color: severityColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    alert.alertType,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(AppFormatters.dateShort(alert.date))),
                            DataCell(Text(alert.timeDetail)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: severityColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  alert.severity.name.toUpperCase(),
                                  style: TextStyle(
                                    color: severityColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              TextButton(
                                onPressed: () => widget.onNavigateToTab?.call(2),
                                child: Text(
                                  alert.recommendedAction,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // 4. Payroll Summary Table / Cards
          SectionHeader(
            title: 'Payroll Summary',
            subtitle: 'Recent released & upcoming cutoff payouts',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: _isPayrollTableView ? 'Switch to Card List' : 'Switch to Table View',
                  icon: Icon(
                    _isPayrollTableView ? Icons.view_agenda_outlined : Icons.table_chart_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPayrollTableView = !_isPayrollTableView;
                    });
                  },
                ),
                TextButton.icon(
                  onPressed: () => widget.onNavigateToTab?.call(4), // Navigate to Payslip
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('View All'),
                ),
              ],
            ),
          ),
          if (!_isPayrollTableView)
            // Mobile-Optimized Payroll Cards View (all numbers immediately clear!)
            Column(
              children: payrollItems.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.cutoffPeriod,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: item.status == 'Paid'
                                    ? AppColors.primary.withAlpha(25)
                                    : Colors.blue.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  color: item.status == 'Paid' ? AppColors.primary : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPayrollCol('Gross Pay', AppFormatters.currency(item.grossPay)),
                            _buildPayrollCol('Deductions', '-${AppFormatters.currency(item.deductions)}', color: AppColors.error),
                            _buildPayrollCol('Net Take-Home', AppFormatters.currency(item.netPay), color: AppColors.primary, isBold: true),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payout Date: ${item.payoutDate}',
                              style: const TextStyle(fontSize: 11, color: AppColors.grayLight),
                            ),
                            InkWell(
                              onTap: () => widget.onNavigateToTab?.call(4),
                              child: const Row(
                                children: [
                                  Text(
                                    'Payslip Details',
                                    style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.chevron_right, size: 14, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          else
            // Full Raw DataTable View with Horizontal Scroll
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: AppColors.surfaceLight,
                    child: const Text(
                      '⇄ Swipe horizontally to inspect table columns',
                      style: TextStyle(fontSize: 11, color: AppColors.grayLight),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceLight),
                      columns: const [
                        DataColumn(label: Text('Cutoff Period', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Gross Pay', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Net Pay', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Payout Date', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: payrollItems.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                item.cutoffPeriod,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataCell(Text(AppFormatters.currency(item.grossPay))),
                            DataCell(
                              Text(
                                '-${AppFormatters.currency(item.deductions)}',
                                style: const TextStyle(color: AppColors.error),
                              ),
                            ),
                            DataCell(
                              Text(
                                AppFormatters.currency(item.netPay),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            DataCell(Text(item.payoutDate)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.status == 'Paid'
                                      ? AppColors.primary.withAlpha(25)
                                      : Colors.blue.withAlpha(25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.status,
                                  style: TextStyle(
                                    color: item.status == 'Paid' ? AppColors.primary : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPayrollCol(String label, String value, {Color? color, bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.grayLight)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? AppColors.mainBlack,
          ),
        ),
      ],
    );
  }
}
