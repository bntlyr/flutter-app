import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/app_formatters.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import 'personal_section_card.dart';

/// Tab 4: Loan Information and Deductions
class PersonalTabLoansDeductions extends StatelessWidget {
  final EmployeeProfile profile;

  const PersonalTabLoansDeductions({
    super.key,
    required this.profile,
  });

  Widget _buildLoanTable(List<LoanTableItem> items) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: Color(0xFFCBD5E1))),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text('Loan Type', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Repayment per Month',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Paid until',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isEven = index % 2 == 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: isEven ? const Color(0xFFEAF1F2) : Colors.transparent,
                border: index < items.length - 1
                    ? const Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      item.loanType,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      AppFormatters.currency(item.repaymentPerMonth),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.paidUntil,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDeductionsTable(List<DeductionTableItem> items) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: Color(0xFFCBD5E1))),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text('Deduction Type', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Amount Per Month',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isEven = index % 2 == 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: isEven ? const Color(0xFFEAF1F2) : Colors.transparent,
                border: index < items.length - 1
                    ? const Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      item.deductionType,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      AppFormatters.currency(item.amountPerMonth),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonalSectionCard(
          title: 'Loan Information',
          child: Column(
            children: [
              PersonalTimingRow(timing: profile.loanPaymentTiming),
              _buildLoanTable(profile.loanTableItems),
            ],
          ),
        ),
        PersonalSectionCard(
          title: 'Deductions',
          child: Column(
            children: [
              PersonalTimingRow(timing: profile.deductionPaymentTiming),
              _buildDeductionsTable(profile.deductionTableItems),
            ],
          ),
        ),
      ],
    );
  }
}
