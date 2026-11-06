import 'package:flutter/material.dart';
import '../../domain/entities/payslip_entity.dart';

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
  final PayslipEntity? payslip;

  const PayslipBreakdownTables({
    super.key,
    required this.option,
    this.payslip,
  });

  static String _format(double val) {
    final parts = val.abs().toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];
    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }
    return '${val < 0 ? '-' : ''}${buffer.toString()}.$decimalPart';
  }

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
    final p = payslip;
    final isDaily = p?.payrollAgreement == 'Daily Basis';
    final workDays = p?.workDays ?? 0.0;
    final dailyRate = p?.dailyRate ?? 0.0;
    final leaveCount = p?.leaveCount ?? 0.0;
    final basicPay = p?.basicPay ?? 0.0;

    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Basic Pay', 'Days', 'Rate', 'Total'], flexes: const [5, 2, 3, 3]),
          _buildTableRow([
            'Actual Worked Days',
            workDays.toStringAsFixed(1),
            isDaily ? _format(dailyRate) : '--',
            isDaily ? _format(workDays * dailyRate) : '--',
          ], flexes: const [5, 2, 3, 3]),
          _buildTableRow([
            'Leave w/ pay',
            leaveCount.toStringAsFixed(1),
            isDaily ? _format(dailyRate) : '--',
            isDaily ? _format(leaveCount * dailyRate) : '--',
          ], flexes: const [5, 2, 3, 3]),
          _buildTableFooter('Total Basic Pay', 'Php ${_format(basicPay)}'),
        ],
      ),
    );
  }

  static const _compGroups = [
    (
      'Regular Holidays Pay',
      [
        ('For Regular', 'rh', 1.0, 1.0),
      ],
    ),
    (
      'Rest And Holidays Pay - Daytime',
      [
        ('Rest Day', 'rd', 1.3, 1.3),
        ('Special Holiday', 'sh', 1.3, 0.3),
        ('Special Holiday & Rest Day', 'shAndRd', 1.5, 1.5),
        ('For Legal', 'lh', 1.0, 1.0),
        ('Legal Holiday & Rest Day', 'lhAndRd', 2.6, 2.6),
      ],
    ),
    (
      'Overtime And Excess Pay - Daytime',
      [
        ('Overtime', 'rot', 1.25, 1.25),
        ('Rest Day. Excess', 'rdExcess', 1.69, 1.69),
        ('Special Holiday. Excess', 'shExcess', 1.69, 1.69),
        ('Special Holiday & Rest Day. Excess', 'shAndRdExcess', 1.95, 1.95),
        ('Legal Holiday. Excess', 'lhExcess', 2.6, 2.6),
        ('Legal Holiday & Rest Day. Excess', 'lhAndRdExcess', 3.38, 3.38),
      ],
    ),
    (
      'Night Differential Pay',
      [
        ('Regular', 'regNd', 0.1, 0.1),
      ],
    ),
    (
      'Rest And Holidays Pay - ND',
      [
        ('Rest Day', 'rdNd', 0.13, 0.13),
        ('Special Holiday', 'shNd', 0.13, 0.13),
        ('Special Holiday & Rest Day', 'shAndRdNd', 0.15, 0.15),
        ('Legal Holiday', 'lhNd', 0.2, 0.2),
        ('Legal Holiday & Rest Day', 'lhAndRdNd', 0.26, 0.26),
      ],
    ),
    (
      'Overtime And Excess Pay - ND',
      [
        ('Regular. Excess', 'regNdExcess', 1.375, 1.375),
        ('Rest Day. Excess', 'rdNdExcess', 1.859, 1.859),
        ('Special Holiday. Excess', 'shNdExcess', 1.859, 1.859),
        ('Special Holiday & Rest Day. Excess', 'shAndRdNdExcess', 2.145, 2.145),
        ('Legal Holiday. Excess', 'lhNdExcess', 2.86, 2.86),
        ('Legal Holiday & Rest Day. Excess', 'lhAndRdNdExcess', 3.718, 3.718),
      ],
    ),
  ];

  // Table 2: Compensation
  Widget _buildCompensationTable() {
    final p = payslip;
    final isDaily = p?.payrollAgreement == 'Daily Basis';
    final baseHourly = (p?.hourlyRate ?? 0) > 0
        ? p!.hourlyRate
        : ((p?.dailyRate ?? 0) > 0 ? p!.dailyRate / 8 : 176.75);
    final comp = p?.compensation ?? 0.0;
    final otAdj = p?.overtimeAdjustment ?? 0.0;

    final rows = <Widget>[
      _buildTableHeader(const ['Compensation', 'Hrs (Day)', 'Rate', 'Total'], flexes: const [5, 3, 3, 3]),
    ];

    for (final group in _compGroups) {
      rows.add(_buildSectionBanner(group.$1));
      for (final item in group.$2) {
        final title = item.$1;
        final key = item.$2;
        final mult = isDaily ? item.$3 : item.$4;
        final rate = baseHourly * mult;

        double hours = p?.overtimeHours[key] ?? 0.0;
        double total = p?.overtimeAmounts[key] ?? 0.0;

        if (key == 'rot' && hours == 0.0 && total == 0.0 && comp > 0) {
          total = comp;
          hours = rate > 0 ? (total / rate) : 0.0;
        }

        final hoursText = (title == 'For Regular' && hours >= 8)
            ? '(${(hours / 8).toStringAsFixed(2)})'
            : hours.toStringAsFixed(2);
        final rateText = (title == 'For Regular' && hours >= 8)
            ? _format(rate * 8)
            : _format(rate);

        rows.add(
          _buildTableRow([
            title,
            hoursText,
            rateText,
            _format(total),
          ], flexes: const [5, 3, 3, 3]),
        );
      }
    }

    rows.add(_buildSectionBanner('Adjustment'));
    rows.add(
      _buildTableRow([
        'Adjustment for Compensation',
        '--',
        '--',
        _format(otAdj),
      ], flexes: const [5, 3, 3, 3]),
    );
    rows.add(_buildTableFooter('Total Compensation', 'Php ${_format(comp)}'));

    return _buildBorderedContainer(
      child: Column(children: rows),
    );
  }

  Widget _buildSectionBanner(String title) {
    Color bg = const Color(0xFF4BA5A5);
    Color text = Colors.white;
    if (title == 'Adjustment') {
      bg = const Color(0xFFE1E1E1);
      text = const Color(0xFF1E293B);
    } else if (title.contains('Night Differential') || title.contains('ND')) {
      bg = const Color(0xFF5677AA);
    }
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        title,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Table 3: Allowance
  Widget _buildAllowanceTable() {
    final p = payslip;
    final taxAllowance = p?.allowanceTaxable ?? 0.0;
    final total = p?.totalAllowance != 0.0
        ? (p?.totalAllowance ?? 0.0)
        : (taxAllowance + (p?.allowanceNonTaxable ?? 0.0));
    final items = p?.allowanceItems ?? const [];

    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Allowance', 'Aquisition Type', 'Total'], flexes: const [5, 4, 3]),
          if (items.isEmpty)
            _buildTableRow(const ['No Allowance Items', '--', '0.00'], flexes: const [5, 4, 3])
          else
            ...items.map((r) => _buildTableRow([
                  r.label,
                  r.acquisitionType,
                  _format(r.amount),
                ], flexes: const [5, 4, 3])),
          _buildTableFooter('Total Allowance', 'Php ${_format(total)}'),
          _buildTaxableFooter('(Taxable Amount)', 'Php ${_format(taxAllowance)}'),
        ],
      ),
    );
  }

  // Table 4: Other Benefit
  Widget _buildOtherBenefitTable() {
    final other = payslip?.otherBenefit ?? 0.0;
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Other Benefit', 'Total'], flexes: const [7, 3]),
          _buildTableRow(['Separation Fee', _format(other)], flexes: const [7, 3]),
          _buildTableFooter('Total Other Benefit', 'Php ${_format(other)}'),
        ],
      ),
    );
  }

  // Table 5: Punctuality
  Widget _buildPunctualityTable() {
    final late = payslip?.punctuality ?? 0.0;
    final rate = payslip?.hourlyRate ?? 0.0;
    final hasLate = late > 0 && rate > 0;
    final hrs = hasLate ? (late / rate) : 0.0;

    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Punctuality', 'Hrs.', 'Rate', 'Total'], flexes: const [5, 3, 3, 3]),
          _buildTableRow(['Undertime', '0.00', '0.00', '0.00'], flexes: const [5, 3, 3, 3]),
          _buildTableRow([
            'Late',
            hrs.toStringAsFixed(2),
            hasLate ? _format(rate) : '0.00',
            _format(late),
          ], flexes: const [5, 3, 3, 3]),
          _buildTableRow(['Absences w/o pay', '0.00', '0.00', '0.00'], flexes: const [5, 3, 3, 3]),
          _buildTableRow(['Adjustment for Punctuality', '0.00', '0.00', '0.00'], flexes: const [5, 3, 3, 3]),
          _buildTableFooter('Total Punctuality', 'Php ${_format(late)}'),
        ],
      ),
    );
  }

  // Table 6: Contribution
  Widget _buildContributionTable() {
    final p = payslip;
    final sss = p?.sss ?? 0.0;
    final providentFund = p?.providentFund ?? 0.0;
    final phic = p?.phic ?? 0.0;
    final hdmf = p?.hdmf ?? 0.0;
    final total = p?.contribution ?? (sss + providentFund + phic + hdmf);

    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Contribution', 'Total'], flexes: const [7, 3]),
          _buildTableRow(['SSS Contribution', _format(sss)], flexes: const [7, 3]),
          _buildTableRow(['Provident Fund', _format(providentFund)], flexes: const [7, 3]),
          _buildTableRow(['PHIC', _format(phic)], flexes: const [7, 3]),
          _buildTableRow(['HDMF', _format(hdmf)], flexes: const [7, 3]),
          _buildTableFooter('Total Contribution', 'Php ${_format(total)}'),
        ],
      ),
    );
  }

  // Table 7: Loan Repayment
  Widget _buildLoanRepaymentTable() {
    final p = payslip;
    final items = p?.loanItems ?? const [];
    final total = p?.loanRepayment ?? 0.0;

    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Loan Repayment', 'Total'], flexes: const [7, 3]),
          if (items.isEmpty)
            _buildTableRow(const ['No Active Loans', '0.00'], flexes: const [7, 3])
          else
            ...items.map((i) => _buildTableRow([i.label, _format(i.amount)], flexes: const [7, 3])),
          _buildTableFooter('Total Loan Repayment', 'Php ${_format(total)}'),
        ],
      ),
    );
  }

  // Table 8: Tax
  Widget _buildTaxTable() {
    final tax = payslip?.tax ?? 0.0;
    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Tax', 'Total'], flexes: const [7, 3]),
          _buildTableRow(['Withholding Tax', _format(tax)], flexes: const [7, 3]),
          _buildTableFooter('Total Tax', 'Php ${_format(tax)}'),
        ],
      ),
    );
  }

  // Table 9: Irregular Adjustment
  Widget _buildIrregularAdjustmentTable() {
    final p = payslip;
    final adj = p?.adjustment ?? 0.0;
    final settlement = p?.taxSettlement ?? 0.0;
    final total = p?.irregularAdjustment ?? (adj + settlement);

    return _buildBorderedContainer(
      child: Column(
        children: [
          _buildTableHeader(const ['Irregular Adjustment', 'Total'], flexes: const [7, 3]),
          _buildTableRow(['By manual', adj != 0 ? _format(adj) : '± 0.00'], flexes: const [7, 3]),
          _buildTableRow(['Tax Settlement', settlement != 0 ? _format(settlement) : '± 0.00'], flexes: const [7, 3]),
          _buildTableFooter('Total Irregular Adjustment', 'Php ${_format(total)}'),
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

  Widget _buildTaxableFooter(String label, String amount) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
