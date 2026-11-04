import 'package:flutter/material.dart';

const Color kPayrollHeaderTeal = Color(0xFF50B5A6);
const Color kPayrollStripeLight = Color(0xFFF4FAF9);
const Color kPayrollBorderColor = Color(0xFFE0E0E0);

class PayrollSummaryRowItem {
  final String creditedAt;
  final String gross;
  final String deductions;
  final String adjustments;
  final String netPay;

  const PayrollSummaryRowItem({
    required this.creditedAt,
    required this.gross,
    required this.deductions,
    required this.adjustments,
    required this.netPay,
  });
}

/// Default payroll summary rows matching web-app reference (Image 2 & 3).
const List<PayrollSummaryRowItem> kDefaultPayrollSummaryRows = [
  PayrollSummaryRowItem(
    creditedAt: 'Oct 20, 2026',
    gross: '₱ 24,068.25',
    deductions: '₱ 6,970.40',
    adjustments: '₱ null',
    netPay: '₱ 31,756.26',
  ),
  PayrollSummaryRowItem(
    creditedAt: 'Oct 05, 2026',
    gross: '₱ 24,068.25',
    deductions: '₱ 6,482.90',
    adjustments: '₱ null',
    netPay: '₱ 32,243.77',
  ),
  PayrollSummaryRowItem(
    creditedAt: 'Sep 18, 2026',
    gross: '₱ 24,068.25',
    deductions: '₱ 6,970.40',
    adjustments: '₱ null',
    netPay: '₱ 31,756.27',
  ),
  PayrollSummaryRowItem(
    creditedAt: 'Sep 04, 2026',
    gross: '₱ 24,068.25',
    deductions: '₱ 6,482.90',
    adjustments: '₱ null',
    netPay: '₱ 32,243.77',
  ),
];

/// Payroll Summary section matching web-app reference (Image 2 & 3).
class PortalPayrollSummaryCard extends StatefulWidget {
  final List<PayrollSummaryRowItem> rows;
  final int totalCount;

  const PortalPayrollSummaryCard({
    super.key,
    this.rows = kDefaultPayrollSummaryRows,
    this.totalCount = 24,
  });

  @override
  State<PortalPayrollSummaryCard> createState() =>
      _PortalPayrollSummaryCardState();
}

class _PortalPayrollSummaryCardState extends State<PortalPayrollSummaryCard> {
  int _currentPage = 0;
  static const int _pageSize = 4;

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.totalCount / _pageSize).ceil();
    final startIndex = _currentPage * _pageSize + 1;
    final endIndex =
        (startIndex + widget.rows.length - 1).clamp(1, widget.totalCount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header
        const Text(
          'Payroll Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: kPayrollHeaderTeal,
          ),
        ),
        const SizedBox(height: 8),

        // 2. Horizontally scrollable table container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kPayrollBorderColor, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 480,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      height: 34,
                      color: kPayrollHeaderTeal,
                      child: Row(
                        children: const [
                          _PayrollCell(
                              label: 'Credited At', isHeader: true, flex: 10),
                          _PayrollCell(label: 'Gross', isHeader: true, flex: 10),
                          _PayrollCell(
                              label: 'Deductions', isHeader: true, flex: 10),
                          _PayrollCell(
                              label: 'Adjustments', isHeader: true, flex: 10),
                          _PayrollCell(label: 'Net Pay', isHeader: true, flex: 10),
                        ],
                      ),
                    ),

                    // Data Rows
                    for (int i = 0; i < widget.rows.length; i++)
                      _buildRow(widget.rows[i], isStripe: i % 2 == 1),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 3. Paginator
        _buildPaginator(
          startIndex: startIndex,
          endIndex: endIndex,
          totalItems: widget.totalCount,
          totalPages: totalPages,
        ),
      ],
    );
  }

  Widget _buildRow(PayrollSummaryRowItem item, {required bool isStripe}) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: isStripe ? kPayrollStripeLight : Colors.white,
        border: const Border(
          bottom: BorderSide(color: kPayrollBorderColor, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          _PayrollCell(label: item.creditedAt, flex: 10),
          _PayrollCell(label: item.gross, flex: 10),
          _PayrollCell(label: item.deductions, flex: 10),
          _PayrollCell(label: item.adjustments, flex: 10),
          _PayrollCell(label: item.netPay, flex: 10),
        ],
      ),
    );
  }

  Widget _buildPaginator({
    required int startIndex,
    required int endIndex,
    required int totalItems,
    required int totalPages,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageButton(
          icon: Icons.first_page,
          enabled: _currentPage > 0,
          onTap: () => setState(() => _currentPage = 0),
        ),
        const SizedBox(width: 6),
        _PageButton(
          icon: Icons.chevron_left,
          enabled: _currentPage > 0,
          onTap: () => setState(() => _currentPage--),
        ),
        const SizedBox(width: 14),
        Text(
          '$startIndex – $endIndex of $totalItems',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF424242),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 14),
        _PageButton(
          icon: Icons.chevron_right,
          enabled: _currentPage < totalPages - 1,
          onTap: () => setState(() => _currentPage++),
        ),
        const SizedBox(width: 6),
        _PageButton(
          icon: Icons.last_page,
          enabled: _currentPage < totalPages - 1,
          onTap: () => setState(() => _currentPage = totalPages - 1),
        ),
      ],
    );
  }
}

class _PayrollCell extends StatelessWidget {
  final String label;
  final bool isHeader;
  final int flex;

  const _PayrollCell({
    required this.label,
    this.isHeader = false,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isHeader ? Colors.white : const Color(0xFF212121),
            fontSize: 11,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: enabled ? const Color(0xFF9E9E9E) : const Color(0xFFE0E0E0),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? const Color(0xFF424242) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
