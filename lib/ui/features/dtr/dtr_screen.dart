import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../data/mock/mock_attendance_data.dart';
import '../../../data/models/attendance_model.dart';
import '../../shared/metric_card.dart';
import '../../shared/section_header.dart';

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
  late String _selectedCutoffId;
  bool _isTableView = false;

  @override
  void initState() {
    super.initState();
    _selectedCutoffId = MockAttendanceData.cutoffPeriods.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final cutoffs = MockAttendanceData.cutoffPeriods;
    final records = MockAttendanceData.cutoffDtrRecords;

    // Calculate aggregated metrics for the cutoff
    double totalWorkedHours = 0;
    double totalOvertimeHours = 0;
    int totalLateMinutes = 0;
    int totalUndertimeMinutes = 0;
    int daysWorked = 0;

    for (final r in records) {
      totalWorkedHours += r.regularHours;
      totalOvertimeHours += r.overtimeHours;
      totalLateMinutes += r.lateMinutes;
      totalUndertimeMinutes += r.undertimeMinutes;
      if (r.regularHours > 0) daysWorked++;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cutoff Selector Card
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.date_range, color: primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Cutoff Period',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.grayLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCutoffId,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainBlack,
                              fontSize: 14,
                            ),
                            items: cutoffs.map((co) {
                              return DropdownMenuItem<String>(
                                value: co.id,
                                child: Text(co.label),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCutoffId = val;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Cutoff Summary Metric Cards
          const SectionHeader(
            title: 'Cutoff DTR Summary',
            subtitle: 'Aggregated hours and attendance totals',
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
                    title: 'Total Regular Hours',
                    value: '${totalWorkedHours.toStringAsFixed(1)} hrs',
                    subtitle: '$daysWorked days logged',
                    icon: Icons.access_time_filled,
                    highlight: true,
                  ),
                  MetricCard(
                    title: 'Approved Overtime',
                    value: '${totalOvertimeHours.toStringAsFixed(1)} hrs',
                    subtitle: 'Across 2 days',
                    icon: Icons.more_time,
                    accentColor: AppColors.primary,
                  ),
                  MetricCard(
                    title: 'Tardiness Total',
                    value: '$totalLateMinutes mins',
                    subtitle: '1 instance',
                    icon: Icons.timelapse,
                    accentColor: Colors.orange,
                  ),
                  MetricCard(
                    title: 'Undertime Total',
                    value: '$totalUndertimeMinutes mins',
                    subtitle: '1 instance',
                    icon: Icons.history_toggle_off,
                    accentColor: AppColors.error,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Daily Time Record Logs with View Toggle
          SectionHeader(
            title: 'Daily Time Record Logs',
            subtitle: 'Day-by-day punch breakdown & status',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: _isTableView ? 'Switch to Card List' : 'Switch to Table View',
                  icon: Icon(
                    _isTableView ? Icons.view_agenda_outlined : Icons.table_chart_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isTableView = !_isTableView;
                    });
                  },
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('DTR Summary report generated for download.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  icon: const Icon(Icons.print_outlined, size: 14),
                  label: const Text('Export', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),

          if (!_isTableView)
            // Mobile-Optimized Daily Log Cards View (100% visible, no scrolling cutoffs!)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final record = records[i];
                final (Color badgeColor, String statusText) = _getStatusProps(record.status);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card Header: Date & Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.event_outlined, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  '${AppFormatters.dateShort(record.date)} (${record.dayOfWeek})',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: badgeColor.withAlpha(100)),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Shift Schedule & Punches Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.grayBorder.withAlpha(100)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Shift Schedule', style: TextStyle(fontSize: 10, color: AppColors.grayLight)),
                                  Text(record.shiftSchedule, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('In ➔ Out', style: TextStyle(fontSize: 10, color: AppColors.grayLight)),
                                  Text(
                                    '${record.timeIn ?? "—"}  →  ${record.timeOut ?? "—"}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: (record.timeIn == null || record.timeOut == null) &&
                                              record.status == DtrStatus.missingPunch
                                          ? AppColors.error
                                          : AppColors.mainBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Hours & Deductions Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reg Hours: ${record.regularHours}h',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            if (record.overtimeHours > 0)
                              Text(
                                'OT: +${record.overtimeHours}h',
                                style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            if (record.lateMinutes > 0)
                              Text(
                                'Late: ${record.lateMinutes}m',
                                style: TextStyle(fontSize: 12, color: Colors.orange[800], fontWeight: FontWeight.bold),
                              ),
                            if (record.undertimeMinutes > 0)
                              Text(
                                'UT: ${record.undertimeMinutes}m',
                                style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),

                        if (record.remarks.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Remarks: ${record.remarks}',
                            style: TextStyle(
                              fontSize: 11,
                              color: record.status == DtrStatus.missingPunch
                                  ? AppColors.error
                                  : AppColors.grayLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
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
                      '⇄ Swipe horizontally to inspect all columns',
                      style: TextStyle(fontSize: 11, color: AppColors.grayLight),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceLight),
                      horizontalMargin: 16,
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Shift', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Time In', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Time Out', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Reg Hrs', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('OT Hrs', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Late/UT', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: records.map((record) {
                        final (Color badgeColor, String statusText) = _getStatusProps(record.status);
                        final lateUtText = (record.lateMinutes > 0 || record.undertimeMinutes > 0)
                            ? '${record.lateMinutes > 0 ? "${record.lateMinutes}m Late" : ""}'
                                '${record.lateMinutes > 0 && record.undertimeMinutes > 0 ? " / " : ""}'
                                '${record.undertimeMinutes > 0 ? "${record.undertimeMinutes}m UT" : ""}'
                            : '—';

                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                '${AppFormatters.dateShort(record.date)} (${record.dayOfWeek})',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataCell(Text(record.shiftSchedule)),
                            DataCell(
                              Text(
                                record.timeIn ?? '—',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: record.timeIn == null && record.status != DtrStatus.restDay && record.status != DtrStatus.onLeave
                                      ? AppColors.error
                                      : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.timeOut ?? '—',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: record.timeOut == null && record.status == DtrStatus.missingPunch
                                      ? AppColors.error
                                      : null,
                                ),
                              ),
                            ),
                            DataCell(Text('${record.regularHours}h')),
                            DataCell(
                              Text(
                                record.overtimeHours > 0 ? '+${record.overtimeHours}h' : '0.0h',
                                style: TextStyle(
                                  fontWeight: record.overtimeHours > 0 ? FontWeight.bold : FontWeight.normal,
                                  color: record.overtimeHours > 0 ? Colors.blue : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                lateUtText,
                                style: TextStyle(
                                  color: lateUtText != '—' ? Colors.orange[800] : null,
                                  fontWeight: lateUtText != '—' ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: badgeColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: badgeColor.withAlpha(100)),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: badgeColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.remarks,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: record.status == DtrStatus.missingPunch
                                      ? AppColors.error
                                      : AppColors.grayLight,
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

  (Color, String) _getStatusProps(DtrStatus status) {
    return switch (status) {
      DtrStatus.normal => (AppColors.primary, 'Normal'),
      DtrStatus.overtime => (Colors.blue, 'OT Work'),
      DtrStatus.tardy => (Colors.orange, 'Late'),
      DtrStatus.undertime => (Colors.amber[800]!, 'Undertime'),
      DtrStatus.restDay => (AppColors.grayLight, 'Rest Day'),
      DtrStatus.onLeave => (Colors.teal[700]!, 'Leave'),
      DtrStatus.missingPunch => (AppColors.error, 'Missing Log'),
      DtrStatus.holiday => (Colors.purple, 'Holiday'),
    };
  }
}
