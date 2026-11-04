import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';

class PayslipSummaryCard extends StatelessWidget {
  const PayslipSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}
