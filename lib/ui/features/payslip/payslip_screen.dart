import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../common/calendar/calendar_cut_off.dart';

enum PayrollDetailOption {
  basicPay('Basic Pay'),
  compensation('Compensation'),
  allowance('Allowance'),
  otherBenefit('Other Benefit'),
  punctuality('Punctuality'),
  contribution('Contribution'),
  loanRepayment('Loan Repayment'),
  tax('Tax'),
  irregularAdjustment('Irregular Adjustment');

  final String label;
  const PayrollDetailOption(this.label);
}

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  String _cutoffText = 'Oct-01-2026 – Oct-15-2026';
  PayrollDetailOption? _selectedDetail;

  final LayerLink _cutoffLayerLink = LayerLink();
  OverlayEntry? _cutoffOverlayEntry;

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

          // 2. Amount of Net Pay Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD6F0EE), Color(0xFF55AAAA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Amount of Net Pay',
                  style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Php. ',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '12,023.25',
                      style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_circle_up, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '4.23% ',
                      style: TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'against last payroll',
                      style: TextStyle(fontSize: 11.5, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Amount of Gross Pay, Total Deduction & Irregular Adjustment
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gross Pay Card
              Expanded(
                child: Container(
                  height: 125,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount of Gross Pay',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                      ),
                      const Row(
                        children: [
                          Text('Php. ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          Text(
                            '12,950.82',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.arrow_circle_up, color: AppColors.primary, size: 14),
                          SizedBox(width: 3),
                          Text('3.29% ', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Expanded(
                            child: Text(
                              'against last payroll',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Total Deduction & Irregular Adjustment Card
              Expanded(
                child: Container(
                  height: 125,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Deduction
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Total Deduction', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Text('Php. ', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  Text('927.57', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_circle_down, color: Color(0xFFD32F2F), size: 18),
                        ],
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      // Irregular Adjustment
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Irregular Adjustment', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Text('Php. ', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  Text('0.00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_circle_right, color: Color(0xFFFFA000), size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          if (_selectedDetail != null) _buildSelectedDetailTable(_selectedDetail!),
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

  // Switch between the 9 tables matching images
  Widget _buildSelectedDetailTable(PayrollDetailOption option) {
    switch (option) {
      case PayrollDetailOption.basicPay:
        return _buildBasicPayTable();
      case PayrollDetailOption.compensation:
        return _buildCompensationTable();
      case PayrollDetailOption.allowance:
        return _buildAllowanceTable();
      case PayrollDetailOption.otherBenefit:
        return _buildOtherBenefitTable();
      case PayrollDetailOption.punctuality:
        return _buildPunctualityTable();
      case PayrollDetailOption.contribution:
        return _buildContributionTable();
      case PayrollDetailOption.loanRepayment:
        return _buildLoanRepaymentTable();
      case PayrollDetailOption.tax:
        return _buildTaxTable();
      case PayrollDetailOption.irregularAdjustment:
        return _buildIrregularAdjustmentTable();
    }
  }

  // Table 1: Basic Pay
  Widget _buildBasicPayTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Basic Pay', 'Days', 'Rate', 'Total'], flexes: const [5, 2, 3, 3]),
          _buildTableRow(const ['Actual Worked Days', '11.0', '695.76', '7,653.36'], flexes: const [5, 2, 3, 3]),
          _buildTableRow(const ['Leave w/ pay', '1.0', '695.76', '695.76'], flexes: const [5, 2, 3, 3]),
          _buildTableFooter('Total Basic Pay', 'Php 8,349.12'),
        ],
      ),
    );
  }

  // Table 2: Compensation
  Widget _buildCompensationTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Compensation', 'Hrs (Day)', 'Rate', 'Total'], flexes: const [5, 2, 2, 3]),
          // Section 1
          _buildSectionSubHeader('Regular Holidays Pay', bgColor: AppColors.primary),
          _buildTableRow(const ['For Regular', '0.00', '86.97', '0.00'], flexes: const [5, 2, 2, 3]),

          // Section 2
          _buildSectionSubHeader('Rest And Holidays Pay - Daytime', bgColor: AppColors.primary),
          _buildTableRow(const ['Rest Day', '0.00', '113.06', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday', '0.00', '113.06', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day', '0.00', '130.45', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['For Legal', '0.00', '86.97', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day', '0.00', '226.12', '0.00'], flexes: const [5, 2, 2, 3]),

          // Section 3
          _buildSectionSubHeader('Overtime And Excess Pay - Daytime', bgColor: AppColors.primary),
          _buildTableRow(const ['Overtime', '19.00', '108.71', '2,065.54'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Rest Day. Excess', '0.00', '146.98', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday. Excess', '0.00', '146.98', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day. Excess', '0.00', '169.59', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday. Excess', '0.00', '226.12', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day. Excess', '0.00', '293.96', '0.00'], flexes: const [5, 2, 2, 3]),

          // Section 4
          _buildSectionSubHeader('Rest And Holidays Pay - ND', bgColor: const Color(0xFF5677AA)),
          _buildTableRow(const ['Rest Day', '0.00', '11.31', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday', '0.00', '11.31', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day', '0.00', '13.05', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday', '0.00', '17.39', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day', '0.00', '22.61', '0.00'], flexes: const [5, 2, 2, 3]),

          // Section 5
          _buildSectionSubHeader('Overtime And Excess Pay - ND', bgColor: const Color(0xFF5677AA)),
          _buildTableRow(const ['Regular. Excess', '9.00', '119.58', '1,076.25'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Rest Day. Excess', '0.00', '161.68', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday. Excess', '0.00', '161.68', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day. Excess', '0.00', '186.55', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday. Excess', '0.00', '248.73', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day. Excess', '0.00', '323.35', '0.00'], flexes: const [5, 2, 2, 3]),

          // Section 6
          _buildSectionSubHeader('Adjustment', bgColor: const Color(0xFFE2E8F0), textColor: Colors.black87),
          _buildTableRow(const ['Adjustment for Compensation', '--', '--', '0.0'], flexes: const [5, 2, 2, 3]),

          _buildTableFooter('Total Compensations', 'Php 3,402.70'),
        ],
      ),
    );
  }

  // Table 3: Allowance
  Widget _buildAllowanceTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Allowance', 'Aquisition Type', 'Total'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Line Leader', 'Daily Basis', '330.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Carbon', 'Daily Basis', '0.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Transportation', 'Daily Basis', '528.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Special Salary', 'Monthly Fixed', '0.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Other Benefits', 'Monthly Fixed', '0.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['ISO', 'Monthly Fixed', '0.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Meal', 'Daily Basis', '341.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Others', 'Manual', '0.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Position', 'Monthly Fixed', '0.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['13th Month Bonus', 'n/a', '0.00'], flexes: const [5, 4, 3]),
          _buildTableRow(const ['Monetized Unused Leaves', 'n/a', '0.00'], flexes: const [5, 4, 3]),
          _buildTableFooter('Total Allowance', 'Php 1,199.00'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('(Taxable Amount)', style: TextStyle(fontSize: 11, color: Color(0xFF757575))),
                Text('Php 330.00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF757575))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Table 4: Other Benefit
  Widget _buildOtherBenefitTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Other Benefit', 'Total'], flexes: const [7, 3]),
          _buildTableRow(const ['Separation Fee', '0.00'], flexes: const [7, 3]),
          _buildTableFooter('Total Other Benefit', 'Php 0.00'),
        ],
      ),
    );
  }

  // Table 5: Punctuality
  Widget _buildPunctualityTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Punctuality', 'Hrs.', 'Rate', 'Total'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Undertime', '0.00', '0.00', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Late', '0.00', '0.00', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Absences w/o pay', '0.00', '0.00', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Adjustment for Punctuality', '0.00', '0.00', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableFooter('Total Punctuality', 'Php 0.00'),
        ],
      ),
    );
  }

  // Table 6: Contribution
  Widget _buildContributionTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Contribution', 'Total'], flexes: const [7, 3]),
          _buildTableRow(const ['SSS Contribution', '600.00'], flexes: const [7, 3]),
          _buildTableRow(const ['Provident Fund', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['PHIC', '227.57'], flexes: const [7, 3]),
          _buildTableRow(const ['HDMF', '100.00'], flexes: const [7, 3]),
          _buildTableFooter('Total Contribution', 'Php 927.57'),
        ],
      ),
    );
  }

  // Table 7: Loan Repayment
  Widget _buildLoanRepaymentTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Loan Repayment', 'Total'], flexes: const [7, 3]),
          _buildTableRow(const ['SSS Salary Loan', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['SSS Calamity Loan', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['HDMF Salary Loan', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['HDMF Calamity Loan', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['HMO', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['Educational Loan', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['Emergency Loan', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['Meal Charges', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['Shuttle Service', '0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['Advances', '0.00'], flexes: const [7, 3]),
          _buildTableFooter('Total Loan Repayment', 'Php 0.00'),
        ],
      ),
    );
  }

  // Table 8: Tax
  Widget _buildTaxTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Tax', 'Total'], flexes: const [7, 3]),
          _buildTableRow(const ['Withholding Tax', '0.00'], flexes: const [7, 3]),
          _buildTableFooter('Total Tax', 'Php 0.00'),
        ],
      ),
    );
  }

  // Table 9: Irregular Adjustment
  Widget _buildIrregularAdjustmentTable() {
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Irregular Adjustment', 'Total'], flexes: const [7, 3]),
          _buildTableRow(const ['By manual', '± 0.00'], flexes: const [7, 3]),
          _buildTableRow(const ['Tax Settlement', '± 0.00'], flexes: const [7, 3]),
          _buildTableFooter('Total Irregular Adjustment', 'Php 0.00'),
        ],
      ),
    );
  }

  // Shared Table builder helpers
  Widget _buildBorderedContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: child,
    );
  }

  Widget _buildTableHeader(List<String> titles, {required List<int> flexes}) {
    return Container(
      color: const Color(0xFF263238),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: List.generate(titles.length, (i) {
          final isFirst = i == 0;
          return Expanded(
            flex: flexes[i],
            child: Text(
              titles[i],
              textAlign: isFirst ? TextAlign.left : TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionSubHeader(String title, {required Color bgColor, Color textColor = Colors.white}) {
    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 11.5,
        ),
      ),
    );
  }

  Widget _buildTableRow(List<String> values, {required List<int> flexes}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFECEFF1))),
      ),
      child: Row(
        children: List.generate(values.length, (i) {
          final isFirst = i == 0;
          return Expanded(
            flex: flexes[i],
            child: Text(
              values[i],
              textAlign: isFirst ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontSize: 11.5,
                color: isFirst ? const Color(0xFF1E293B) : const Color(0xFF334155),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTableFooter(String label, String amount) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}
