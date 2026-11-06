import 'package:flutter/material.dart';
import '../../domain/entities/payslip_entity.dart';

class PayslipSummaryCard extends StatelessWidget {
  final PayslipEntity? payslip;

  const PayslipSummaryCard({super.key, this.payslip});

  static String _formatNumber(double amount) {
    final parts = amount.abs().toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }

    return '${buffer.toString()}.$decimalPart';
  }

  Widget _buildTrendIcon(double percent) {
    if (percent < 0) {
      return const Icon(Icons.arrow_circle_down, color: Color(0xFFE11D48), size: 14);
    } else if (percent > 0) {
      return const Icon(Icons.arrow_circle_up, color: Color(0xFF10B981), size: 14);
    } else {
      return const Icon(Icons.arrow_circle_right, color: Color(0xFFF59E0B), size: 14);
    }
  }

  Color _getTrendColor(double percent) {
    if (percent < 0) return const Color(0xFFE11D48);
    if (percent > 0) return const Color(0xFF10B981);
    return const Color(0xFFF59E0B);
  }

  @override
  Widget build(BuildContext context) {
    final netPay = payslip?.netPay ?? 0.0;
    final grossPay = payslip?.totalGross ?? 0.0;
    final totalDeduction = payslip?.totalDeductions ?? 0.0;
    final irregAdj = payslip?.irregularAdjustment ?? 0.0;

    final againstNet = payslip?.againstNetpay ?? 0.0;
    final againstGross = payslip?.againstGrosspay ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'Php. ',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _formatNumber(netPay),
                    style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTrendIcon(againstNet),
                  const SizedBox(width: 4),
                  Text(
                    '${againstNet.toStringAsFixed(2)}% ',
                    style: const TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
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
                    Row(
                      children: [
                        const Text('Php. ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text(
                          _formatNumber(grossPay),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildTrendIcon(againstGross),
                        const SizedBox(width: 3),
                        Text(
                          '${againstGross.toStringAsFixed(2)}% ',
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: _getTrendColor(againstGross)),
                        ),
                        const Expanded(
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
                          children: [
                            const Text('Total Deduction', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Text('Php. ', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                Text(
                                  _formatNumber(totalDeduction),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_circle_up, color: Color(0xFF3B82F6), size: 18),
                      ],
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    // Irregular Adjustment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Irregular Adjustment', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Text('Php. ', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                Text(
                                  _formatNumber(irregAdj),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_circle_right, color: Color(0xFFF59E0B), size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
