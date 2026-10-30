import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/mock/mock_profile_data.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = MockProfileData.profile;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Profile Title
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),

          // 2. Compact Profile Header
          _buildProfileHeader(profile),
          const SizedBox(height: 16),

          // 3. The 4 Tab Buttons
          _buildTabButtonsRow(),
          const SizedBox(height: 16),

          // 4. Tab Content
          _buildSelectedTabContent(profile),
        ],
      ),
    );
  }

  // Header matching images: Avatar, Name, Age, Badge, Schedule, Login/Employee/Biometrics/Remarks
  Widget _buildProfileHeader(EmployeeProfile profile) {
    return Column(
      children: [
        // Circular Avatar with outer border
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF1F5F9),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 46,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Name
        Text(
          profile.fullName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),

        // Age
        Text(
          profile.age,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),

        // Class badge (Regular)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2.5),
          decoration: BoxDecoration(
            color: const Color(0xFF8DB828),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            profile.jobClass,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Schedule Link & Info block
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // See work schedule link
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month, size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'See work schedule >',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Credential rows
              _buildHeaderDataRow('Login ID', profile.loginId),
              _buildHeaderDataRow('Employee ID', profile.employeeId),
              _buildHeaderDataRow('Biometrics No', profile.biometricsNo),
              _buildHeaderDataRow('Remarks', profile.remarks),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }

  // 4 Tab Buttons matching images
  Widget _buildTabButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabButton(0, Icons.person),
        _buildTabButton(1, Icons.work),
        _buildTabButton(2, Icons.calendar_today),
        _buildTabButton(3, Icons.account_balance),
      ],
    );
  }

  Widget _buildTabButton(int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.primary : const Color(0xFFF1F5F9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(80),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // Render tab content matching images 1, 2-3, 4, 5
  Widget _buildSelectedTabContent(EmployeeProfile profile) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildTab1Content(profile);
      case 1:
        return _buildTab2Content(profile);
      case 2:
        return _buildTab3Content(profile);
      case 3:
        return _buildTab4Content(profile);
      default:
        return const SizedBox();
    }
  }

  // Tab 0: Image 1 - Employee Information & Emergency Information
  Widget _buildTab1Content(EmployeeProfile profile) {
    return Column(
      children: [
        _buildSectionCard(
          title: 'Employee Information',
          child: Column(
            children: [
              _buildDataRow('Date of Birth', profile.birthDate),
              _buildDataRow('Sex', profile.gender),
              _buildDataRow('Civil Status', profile.civilStatus),
              _buildDataRow('Mobile No.', profile.mobileNo),
              _buildDataRow('Landline No.', profile.landlineNo),
              _buildDataRow('E-mail', profile.email),
              _buildDataRow('Address', profile.residentialAddress),
            ],
          ),
        ),
        _buildSectionCard(
          title: 'Emergency Information',
          child: Column(
            children: [
              _buildDataRow('Name', profile.emergencyContactName),
              _buildDataRow('Relation', profile.emergencyContactRelation),
              _buildDataRow('Contact', profile.emergencyContactPhone),
              _buildDataRow('Address', profile.emergencyAddress),
            ],
          ),
        ),
      ],
    );
  }

  // Tab 1: Images 2 & 3 - Employment Information, Allowances, Entitlements
  Widget _buildTab2Content(EmployeeProfile profile) {
    return Column(
      children: [
        _buildSectionCard(
          title: 'Employment Information',
          child: Column(
            children: [
              _buildDataRow('Date Hired', profile.dateHired),
              _buildDataRow('Period', profile.period),
              _buildDataRow('Class', profile.jobClass),
              _buildDataRow('Resignation', profile.resignationDate),
              _buildDataRow(
                'Basic Salary',
                '${AppFormatters.currency(profile.basicSalary)} / ${profile.salaryType}',
              ),
              _buildDataRow('Job Location', profile.officeLocation),
              _buildDataRow('Resignation', profile.resignationDate),
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
              _buildDataRow('End of Probation', profile.endOfProbation),
              _buildDataRow('Department', profile.department),
              _buildDataRow('Section', profile.section),
              _buildDataRow('Designation', profile.designation),
            ],
          ),
        ),
        _buildSectionCard(
          title: 'Allowances',
          child: _buildAllowancesGrid(profile.allowances),
        ),
        _buildSectionCard(
          title: 'Entitlements',
          child: _buildEntitlementsList(profile.entitlements),
        ),
      ],
    );
  }

  // Tab 2: Image 4 - Leave Status & Contribution Info
  Widget _buildTab3Content(EmployeeProfile profile) {
    return Column(
      children: [
        _buildSectionCard(
          title: 'Leave Status',
          child: _buildLeaveCreditsTable(profile.leaveCredits),
        ),
        _buildSectionCard(
          title: 'Contribution Info',
          child: Column(
            children: [
              _buildTimingRow(profile.contribPaymentTiming),
              _buildDataRow('SSS No.', profile.sssNo),
              _buildDataRow('Phil. Health No.', profile.philhealthNo),
              _buildDataRow('Pagibig No.', profile.pagibigNo),
              _buildDataRow('TIN No.', profile.tinNo),
              _buildDataRow('Pagibig Cont.', profile.pagibigCont),
            ],
          ),
        ),
      ],
    );
  }

  // Tab 3: Image 5 - Loan Information & Deductions
  Widget _buildTab4Content(EmployeeProfile profile) {
    return Column(
      children: [
        _buildSectionCard(
          title: 'Loan Information',
          child: Column(
            children: [
              _buildTimingRow(profile.loanPaymentTiming),
              _buildLoanTable(profile.loanTableItems),
            ],
          ),
        ),
        _buildSectionCard(
          title: 'Deductions',
          child: Column(
            children: [
              _buildTimingRow(profile.deductionPaymentTiming),
              _buildDeductionsTable(profile.deductionTableItems),
            ],
          ),
        ),
      ],
    );
  }

  // Reusable Section Card with teal accent bar
  Widget _buildSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 3.5,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingRow(String timing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 4,
            child: Text(
              'Timing',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              timing,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Allowances 2-column grid matching image 2
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

  // Entitlements timeline list matching image 3
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

  // Leave credits table matching image 4
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

  // Loan Table matching image 5
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

  // Deductions Table matching image 5
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

  String _formatCredit(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
