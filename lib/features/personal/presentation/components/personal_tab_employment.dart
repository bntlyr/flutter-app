import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/utils/app_formatters.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import 'personal_section_card.dart';

/// Tab 2: Employment Information, Allowances, and Entitlements
class PersonalTabEmployment extends StatelessWidget {
  final EmployeeProfile profile;

  const PersonalTabEmployment({
    super.key,
    required this.profile,
  });

  Widget _buildAllowancesGrid(List<AllowanceItem> items) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = (i + 1 < items.length) ? items[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(left.label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                    const SizedBox(height: 1),
                    Text(
                      AppFormatters.currency(left.amount),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
              if (right != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(right.label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                      const SizedBox(height: 1),
                      Text(
                        AppFormatters.currency(right.amount),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildEntitlementsList(List<EntitlementGroup> entitlements) {
    return Column(
      children: entitlements.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == entitlements.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left teal timeline indicator
              Column(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 1.5,
                        color: AppColors.primary.withAlpha(90),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Entitlement items
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEntitlementCheck(item.primaryLabel, item.isPrimaryChecked),
                      const SizedBox(height: 6),
                      _buildEntitlementCheck(item.secondaryLabel, item.isSecondaryChecked),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEntitlementCheck(String label, bool isChecked) {
    return Row(
      children: [
        if (isChecked) ...[
          const Icon(Icons.check, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
        ] else ...[
          const SizedBox(width: 20),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: isChecked ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
            fontWeight: isChecked ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonalSectionCard(
          title: 'Employment Information',
          child: Column(
            children: [
              PersonalDataRow(label: 'Date Hired', value: profile.dateHired),
              PersonalDataRow(label: 'Period', value: profile.period),
              PersonalDataRow(label: 'Class', value: profile.jobClass),
              PersonalDataRow(label: 'Resignation', value: profile.resignationDate),
              PersonalDataRow(
                label: 'Basic Salary',
                value: '${AppFormatters.currency(profile.basicSalary)} / ${profile.salaryType}',
              ),
              PersonalDataRow(label: 'Job Location', value: profile.officeLocation),
              PersonalDataRow(label: 'Resignation', value: profile.resignationDate),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 100,
                    height: 1.5,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              PersonalDataRow(label: 'End of Probation', value: profile.endOfProbation),
              PersonalDataRow(label: 'Department', value: profile.department),
              PersonalDataRow(label: 'Section', value: profile.section),
              PersonalDataRow(label: 'Designation', value: profile.designation),
            ],
          ),
        ),
        PersonalSectionCard(
          title: 'Allowances',
          child: _buildAllowancesGrid(profile.allowances),
        ),
        PersonalSectionCard(
          title: 'Entitlements',
          child: _buildEntitlementsList(profile.entitlements),
        ),
      ],
    );
  }
}
