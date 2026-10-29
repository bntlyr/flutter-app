import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../data/mock/mock_profile_data.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final profile = MockProfileData.profile;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Profile Header Card
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.gray, primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: primary,
                            child: Text(
                              profile.avatarInitials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile.fullName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.jobTitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.grayLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.department} • ${profile.employeeId}',
                          style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildQuickContactPill(Icons.email_outlined, profile.email),
                            _buildQuickContactPill(Icons.phone_outlined, profile.phone),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Employee Information
          _buildInfoSection(
            context,
            icon: Icons.person_outline,
            title: 'Employee Information',
            subtitle: 'Personal identity & background records',
            children: [
              _buildDataRow('Full Legal Name', profile.fullName),
              _buildDataRow('Date of Birth', profile.birthDate),
              _buildDataRow('Gender / Civil Status', '${profile.gender} • ${profile.civilStatus}'),
              _buildDataRow('Nationality', profile.nationality),
              _buildDataRow('Residential Address', profile.residentialAddress),
              const Divider(height: 16),
              _buildDataRow(
                'Emergency Contact',
                '${profile.emergencyContactName} (${profile.emergencyContactRelation})\n${profile.emergencyContactPhone}',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Employment Information
          _buildInfoSection(
            context,
            icon: Icons.badge_outlined,
            title: 'Employment Information',
            subtitle: 'Company designation, tenure & supervisor',
            children: [
              _buildDataRow('Employment Status', profile.employmentStatus),
              _buildDataRow('Date Hired', profile.dateHired),
              _buildDataRow('Tenure / Service Length', profile.yearsOfService),
              _buildDataRow('Direct Supervisor', profile.directSupervisor),
              _buildDataRow('Work Shift Schedule', profile.workSchedule),
              _buildDataRow('Office Station', profile.officeLocation),
            ],
          ),
          const SizedBox(height: 12),

          // 4. Leave Status
          _buildInfoSection(
            context,
            icon: Icons.beach_access_outlined,
            title: 'Leave Status & Balances',
            subtitle: 'Available credits and year-to-date consumption',
            children: [
              ...profile.leaveCredits.map((leave) {
                final ratio = leave.totalAllocated > 0
                    ? (leave.remaining / leave.totalAllocated).clamp(0.0, 1.0)
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            leave.leaveType,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          Text(
                            '${leave.remaining} / ${leave.totalAllocated} days remaining',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 6,
                          backgroundColor: AppColors.grayBorder,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ratio > 0.3 ? AppColors.primary : Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Used: ${leave.used} days',
                        style: const TextStyle(fontSize: 11, color: AppColors.grayLight),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),

          // 5. Contribution Info
          _buildInfoSection(
            context,
            icon: Icons.account_balance_outlined,
            title: 'Contribution Information',
            subtitle: 'Government statutory identification numbers',
            children: profile.contributions.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 12, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.agencyName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID / Number: ${item.accountOrIdNumber}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: AppColors.mainBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Status: ${item.status} • EE: ${AppFormatters.currency(item.monthlyEmployeeRate)} | ER: ${AppFormatters.currency(item.monthlyEmployerRate)}',
                            style: const TextStyle(fontSize: 11, color: AppColors.grayLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // 6. Loan Information
          _buildInfoSection(
            context,
            icon: Icons.monetization_on_outlined,
            title: 'Loan Information',
            subtitle: 'Active corporate and government amortization ledgers',
            children: profile.loans.map((loan) {
              return Card(
                color: AppColors.surfaceLight,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loan.loanType,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(20),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Maturing: ${loan.maturityDate}',
                              style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Ref: ${loan.referenceNumber}', style: const TextStyle(fontSize: 11, color: AppColors.grayLight)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 4,
                        children: [
                          Text('Original: ${AppFormatters.currency(loan.principalAmount)}', style: const TextStyle(fontSize: 12)),
                          Text('Amortization: ${AppFormatters.currency(loan.monthlyAmortization)}/mo', style: const TextStyle(fontSize: 12)),
                          Text(
                            'Balance: ${AppFormatters.currency(loan.balanceRemaining)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // 7. Deductions
          _buildInfoSection(
            context,
            icon: Icons.remove_circle_outline,
            title: 'Recurring Deductions',
            subtitle: 'Active recurring payroll deductions & withholdings',
            children: profile.recurringDeductions.map((ded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ded.deductionName,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${ded.frequency} • ${ded.notes}',
                            style: const TextStyle(fontSize: 11, color: AppColors.grayLight),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '-${AppFormatters.currency(ded.amount)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickContactPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.grayLight),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 11, color: AppColors.grayLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: AppColors.grayBorder),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.grayLight, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.mainBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
