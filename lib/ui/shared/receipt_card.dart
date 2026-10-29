import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../data/models/payslip_model.dart';

class ReceiptCard extends StatelessWidget {
  final PayslipCutoffData payslip;
  final VoidCallback onDownloadPdf;

  const ReceiptCard({
    super.key,
    required this.payslip,
    required this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Receipt Top Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'PAYROLL ADVICE RECEIPT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        payslip.cutoffLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payslip.employeeName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${payslip.department} • ${payslip.employeeId}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Ref: ${payslip.paymentReference.split('-').last}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white.withAlpha(160),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Perforated Divider simulation
          _buildPerforation(),

          // Receipt Body Items
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _receiptRow('Cutoff Period', payslip.cutoffLabel),
                const SizedBox(height: 6),
                _receiptRow('Payment Date', payslip.payoutDateStr),
                const SizedBox(height: 6),
                _receiptRow('Transaction ID', payslip.paymentReference),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.grayBorder),
                const SizedBox(height: 14),

                // Financial Summary Rows
                _receiptRow(
                  'Gross Compensation',
                  AppFormatters.currency(payslip.grossPay),
                  isBold: true,
                ),
                const SizedBox(height: 8),
                _receiptRow(
                  'Total Statutory & Other Deductions',
                  '-${AppFormatters.currency(payslip.totalDeductions)}',
                  textColor: AppColors.error,
                ),
                const SizedBox(height: 8),
                _receiptRow(
                  'Irregular Adjustments',
                  '+${AppFormatters.currency(payslip.irregularAdjustment)}',
                  textColor: AppColors.primary,
                ),
                const SizedBox(height: 14),

                // Dotted receipt line
                _buildDottedLine(),
                const SizedBox(height: 14),

                // Total Net Pay Banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NET TAKE-HOME PAY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: AppColors.gray,
                          ),
                        ),
                        Text(
                          'Direct Deposit to Payroll Account',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                    Text(
                      AppFormatters.currency(payslip.netPay),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Simulated Barcode & Security stamp
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grayBorder),
                  ),
                  child: Row(
                    children: [
                      // Simulated vertical barcode bars
                      Row(
                        children: List.generate(
                          18,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            width: (i % 3 == 0) ? 3 : ((i % 2 == 0) ? 2 : 1),
                            height: 28,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'VERIFIED DIGITAL STATEMENT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Encrypted hash authentication verified',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.grayLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.verified, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onDownloadPdf,
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Download Official PDF'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isBold ? AppColors.mainBlack : AppColors.grayLight,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: textColor ?? (isBold ? AppColors.mainBlack : AppColors.gray),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPerforation() {
    return SizedBox(
      height: 14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: List.generate(
              30,
              (index) => Expanded(
                child: Container(
                  height: 1,
                  color: index.isEven ? AppColors.grayBorder : Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            left: -8,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -8,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return Row(
      children: List.generate(
        35,
        (index) => Expanded(
          child: Container(
            height: 1.5,
            color: index.isEven ? AppColors.grayBorder : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
