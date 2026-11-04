import 'package:flutter/material.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import 'personal_section_card.dart';

/// Tab 3: Leave Status and Contribution Info
class PersonalTabLeaveContributions extends StatelessWidget {
  final EmployeeProfile profile;

  const PersonalTabLeaveContributions({
    super.key,
    required this.profile,
  });

  Widget _buildLeaveCreditsTable(List<LeaveCreditItem> leaveCredits) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(flex: 5, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Text(
                  'Total',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Used',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Usable',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        ...leaveCredits.asMap().entries.map((entry) {
          final index = entry.key;
          final leave = entry.value;
          final isEven = index % 2 == 0;

          return Container(
            decoration: BoxDecoration(
              color: isEven ? const Color(0xFFEAF1F2) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    leave.leaveType,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _formatCredit(leave.totalAllocated),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _formatCredit(leave.used),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _formatCredit(leave.remaining),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatCredit(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonalSectionCard(
          title: 'Leave Status',
          child: _buildLeaveCreditsTable(profile.leaveCredits),
        ),
        PersonalSectionCard(
          title: 'Contribution Info',
          child: Column(
            children: [
              PersonalTimingRow(timing: profile.contribPaymentTiming),
              PersonalDataRow(label: 'SSS No.', value: profile.sssNo),
              PersonalDataRow(label: 'Phil. Health No.', value: profile.philhealthNo),
              PersonalDataRow(label: 'Pagibig No.', value: profile.pagibigNo),
              PersonalDataRow(label: 'TIN No.', value: profile.tinNo),
              PersonalDataRow(label: 'Pagibig Cont.', value: profile.pagibigCont),
            ],
          ),
        ),
      ],
    );
  }
}
