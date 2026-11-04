import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/shared/widgets/calendar/calendar_cut_off.dart';

import '../components/payslip_breakdown_tables.dart';
import '../components/payslip_summary_card.dart';
export '../components/payslip_breakdown_tables.dart' show PayrollDetailOption;

class PayslipScreen extends StatefulWidget {
  final String? initialCutoff;

  const PayslipScreen({
    super.key,
    this.initialCutoff,
  });

  /// Dynamically computes active cutoff based on date.
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
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  late String _cutoffText;
  PayrollDetailOption? _selectedDetail;

  final LayerLink _cutoffLayerLink = LayerLink();
  OverlayEntry? _cutoffOverlayEntry;

  @override
  void initState() {
    super.initState();
    _cutoffText = widget.initialCutoff ?? PayslipScreen.getDefaultCutoff();
  }

  @override
  void dispose() {
    _closeCutoffPicker();
    super.dispose();
  }

  void _toggleCutoffPicker() {
    if (_cutoffOverlayEntry != null) {
      _closeCutoffPicker();
    } else {
      _showCutoffPicker();
    }
  }

  void _closeCutoffPicker() {
    _cutoffOverlayEntry?.remove();
    _cutoffOverlayEntry = null;
  }

  void _showCutoffPicker() {
    final overlay = Overlay.of(context);
    _cutoffOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            // Tap outside to dismiss
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeCutoffPicker,
              ),
            ),
            // Anchor directly below the Cut-off input box
            Positioned(
              width: 275,
              child: CompositedTransformFollower(
                link: _cutoffLayerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 4),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: CalendarCutOff(
                    selectedCutoff: _cutoffText,
                    onCutoffSelected: (newRange) {
                      setState(() {
                        _cutoffText = newRange;
                      });
                      _closeCutoffPicker();
                    },
                    onClose: _closeCutoffPicker,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_cutoffOverlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Cut-off Header & Print Payslip Button
          const Text(
            'Cut-off',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // Cutoff Input selector
              Expanded(
                flex: 6,
                child: CompositedTransformTarget(
                  link: _cutoffLayerLink,
                  child: InkWell(
                    onTap: _toggleCutoffPicker,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            _cutoffText,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

              // Print Payslip Button
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text(
                      'Print Payslip',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Printing payslip for $_cutoffText...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2 & 3. Net Pay, Gross Pay, Deductions, and Adjustments
          const PayslipSummaryCard(),
          const SizedBox(height: 16),

          // 4. Payroll Breakdown Section
          const Text(
            'Payroll Breakdown',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rates Row
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payroll Agreement', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                    Text('Daily Rate', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                    Text('Php. 695.76', style: TextStyle(fontSize: 11.5, color: Color(0xFF1E293B))),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly Basis', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                    Text('Hourly Rate', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                    Text('Php. 86.97', style: TextStyle(fontSize: 11.5, color: Color(0xFF1E293B))),
                  ],
                ),
                const SizedBox(height: 12),

                // Taxable Income Items
                const Text(
                  'Taxable Income Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                _buildBreakdownRow('Basic Pay (w/Leave)', 'Php. 8,349.12'),
                _buildBreakdownRow('Compensation', 'Php. 3,402.70'),
                _buildBreakdownRow('Allowance Taxable', 'Php. 330.00'),
                const SizedBox(height: 10),

                // Taxable Deduction Items
                const Text(
                  'Taxable Deduction Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                _buildBreakdownRow('Punctuality', 'Php. 0.00'),
                _buildBreakdownRow('Contribution', 'Php. 927.57'),
                const Divider(color: Color(0xFF9E9E9E), height: 16),

                _buildBreakdownRow('Total Taxable Income', 'Php. 11,154.25'),
                _buildBreakdownRow('Tax', 'Php. 0.00'),
                _buildBreakdownRow('After Tax Income', 'Php. 11,154.25'),
                const Divider(color: Color(0xFF9E9E9E), height: 16),

                // Non Taxable Income Items
                const Text(
                  'Non Taxable Income Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                _buildBreakdownRow('Allowance (Non-Taxable)', 'Php. 869.00'),
                _buildBreakdownRow('Other Benefit', 'Php. 0.00'),
                const SizedBox(height: 10),

                // Tax Exempt Deduction Items
                const Text(
                  'Tax Exempt Deduction Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                _buildBreakdownRow('Loan Repayment', 'Php. 0.00'),
                const Divider(color: Color(0xFF9E9E9E), height: 16),

                _buildBreakdownRow('Irregular Adjustment', '± Php. 0.00'),
                const Divider(color: Color(0xFF9E9E9E), height: 16),

                _buildBreakdownRow('Net Pay', 'Php. 12,023.25', isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 5. Payroll Detail Section with Dropdown & Clear Button
          const Text(
            'Payroll Detail',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              // Dropdown
              Expanded(
                flex: 7,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PayrollDetailOption>(
                      value: _selectedDetail,
                      isExpanded: true,
                      hint: const Text('Select detail category', style: TextStyle(fontSize: 12.5)),
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E293B)),
                      items: PayrollDetailOption.values.map((opt) {
                        return DropdownMenuItem<PayrollDetailOption>(
                          value: opt,
                          child: Text(
                            opt.label,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDetail = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Clear > button
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedDetail = null;
                      });
                    },
                    child: const Text(
                      'Clear >',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 6. Selected Detail Table (Rendered based on selected dropdown option)
          if (_selectedDetail != null) PayslipBreakdownTables(option: _selectedDetail!),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF334155),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
