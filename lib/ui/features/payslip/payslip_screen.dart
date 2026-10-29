import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../data/mock/mock_attendance_data.dart';
import '../../../data/mock/mock_payslip_data.dart';
import '../../../data/models/payslip_model.dart';
import '../../shared/metric_card.dart';
import '../../shared/receipt_card.dart';
import '../../shared/section_header.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  late String _selectedCutoffId;
  PayrollCategory _selectedCategory = PayrollCategory.basicPayCompensation;
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

    final payslip = MockPayslipData.cutoffPayslips[_selectedCutoffId] ??
        MockPayslipData.cutoffPayslips.values.first;

    final categoryItems = payslip.categoryBreakdown[_selectedCategory] ?? [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Cutoff Selector Card
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
                    child: Icon(Icons.receipt, color: primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payroll Cutoff Period',
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

          // 2. 4 Key Financial KPI Cards
          const SectionHeader(
            title: 'Payslip Overview',
            subtitle: 'Cutoff financial summary and take-home pay',
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
                    title: 'Net Take-Home Pay',
                    value: AppFormatters.currency(payslip.netPay),
                    subtitle: 'Direct Deposit',
                    icon: Icons.account_balance_wallet,
                    highlight: true,
                  ),
                  MetricCard(
                    title: 'Gross Compensation',
                    value: AppFormatters.currency(payslip.grossPay),
                    subtitle: 'Base + Allowances',
                    icon: Icons.payments_outlined,
                    accentColor: AppColors.gray,
                  ),
                  MetricCard(
                    title: 'Total Deductions',
                    value: '-${AppFormatters.currency(payslip.totalDeductions)}',
                    subtitle: 'Taxes & Mandates',
                    icon: Icons.remove_circle_outline,
                    accentColor: AppColors.error,
                  ),
                  MetricCard(
                    title: 'Irregular Adjustment',
                    value: '+${AppFormatters.currency(payslip.irregularAdjustment)}',
                    subtitle: 'Retro & Disputes',
                    icon: Icons.tune,
                    accentColor: AppColors.primary,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // 3. Receipt-Like Card for Payroll Breakdown
          const SectionHeader(
            title: 'Official Payroll Advice',
            subtitle: 'Digital pay slip receipt statement',
          ),
          ReceiptCard(
            payslip: payslip,
            onDownloadPdf: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primary,
                  content: Text('Downloading official PDF for ${payslip.cutoffLabel}...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // 4. Payroll Detail Category Selector & Breakdown Table
          SectionHeader(
            title: 'Payroll Breakdown Details',
            subtitle: 'Select a category to inspect its itemized calculation',
            trailing: IconButton(
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
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dropdown of the 8 categories
                  Row(
                    children: [
                      const Icon(Icons.category_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'Category:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grayBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PayrollCategory>(
                              value: _selectedCategory,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: PayrollCategory.values.map((cat) {
                                return DropdownMenuItem<PayrollCategory>(
                                  value: cat,
                                  child: Text(
                                    cat.displayName,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedCategory = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Horizontal chip shortcuts
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: PayrollCategory.values.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(
                              cat.displayName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 5. Itemized Category List (Mobile Optimized) or Table
          if (categoryItems.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No itemized entries found for this category in this cutoff.'),
                ),
              ),
            )
          else if (!_isTableView)
            // Mobile-Optimized Breakdown Cards (100% visible, clean numbers!)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryItems.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final item = categoryItems[i];
                final color = item.isDeduction ? AppColors.error : AppColors.primary;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: color.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item.isDeduction ? Icons.remove : Icons.add,
                                size: 14,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.description,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.basis,
                                    style: const TextStyle(fontSize: 12, color: AppColors.grayLight),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${item.isDeduction ? "-" : "+"}${AppFormatters.currency(item.employeeAmount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (item.employerShare > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text('Employer Counterpart Share:', style: TextStyle(fontSize: 11, color: AppColors.grayLight)),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppFormatters.currency(item.employerShare),
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray),
                                ),
                              ],
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
                      '⇄ Swipe horizontally to inspect all table columns',
                      style: TextStyle(fontSize: 11, color: AppColors.grayLight),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceLight),
                      columns: const [
                        DataColumn(label: Text('Item Description', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Basis / Units', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Employer Share', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Employee Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: categoryItems.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Icon(
                                    item.isDeduction ? Icons.remove_circle_outline : Icons.add_circle_outline,
                                    size: 16,
                                    color: item.isDeduction ? AppColors.error : AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.description,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(item.basis, style: const TextStyle(fontSize: 12))),
                            DataCell(
                              Text(
                                item.employerShare > 0 ? AppFormatters.currency(item.employerShare) : '—',
                                style: const TextStyle(color: AppColors.grayLight),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${item.isDeduction ? "-" : "+"}${AppFormatters.currency(item.employeeAmount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: item.isDeduction ? AppColors.error : AppColors.primary,
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
}
