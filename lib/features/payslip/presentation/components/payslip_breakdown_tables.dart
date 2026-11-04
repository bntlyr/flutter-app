import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';

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

class PayslipBreakdownTables extends StatelessWidget {
  final PayrollDetailOption option;

  const PayslipBreakdownTables({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
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
          _buildSectionSubHeader('Regular Holidays Pay', bgColor: AppColors.primary),
          _buildTableRow(const ['For Regular', '0.00', '86.97', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildSectionSubHeader('Rest And Holidays Pay - Daytime', bgColor: AppColors.primary),
          _buildTableRow(const ['Rest Day', '0.00', '113.06', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday', '0.00', '113.06', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day', '0.00', '130.45', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['For Legal', '0.00', '86.97', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day', '0.00', '226.12', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildSectionSubHeader('Overtime And Excess Pay - Daytime', bgColor: AppColors.primary),
          _buildTableRow(const ['Overtime', '19.00', '108.71', '2,065.54'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Rest Day. Excess', '0.00', '146.98', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday. Excess', '0.00', '146.98', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day. Excess', '0.00', '169.59', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday. Excess', '0.00', '226.12', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day. Excess', '0.00', '293.96', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildSectionSubHeader('Rest And Holidays Pay - ND', bgColor: const Color(0xFF5677AA)),
          _buildTableRow(const ['Rest Day', '0.00', '11.31', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday', '0.00', '11.31', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day', '0.00', '13.05', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday', '0.00', '17.39', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day', '0.00', '22.61', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildSectionSubHeader('Overtime And Excess Pay - ND', bgColor: const Color(0xFF5677AA)),
          _buildTableRow(const ['Regular. Excess', '9.00', '119.58', '1,076.25'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Rest Day. Excess', '0.00', '161.68', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday. Excess', '0.00', '161.68', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Special Holiday & Rest Day. Excess', '0.00', '186.55', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday. Excess', '0.00', '248.73', '0.00'], flexes: const [5, 2, 2, 3]),
          _buildTableRow(const ['Legal Holiday & Rest Day. Excess', '0.00', '323.35', '0.00'], flexes: const [5, 2, 2, 3]),
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
