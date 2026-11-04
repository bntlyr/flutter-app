import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/data/mock/mock_profile_data.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import '../components/personal_profile_header.dart';
import '../components/personal_tab_employee_info.dart';
import '../components/personal_tab_employment.dart';
import '../components/personal_tab_leave_contributions.dart';
import '../components/personal_tab_loans_deductions.dart';

/// Profile (Personal) Screen with 4 modular tabs:
/// 1. Employee & Emergency Information (Icons.person)
/// 2. Employment Information, Allowances & Entitlements (Icons.work)
/// 3. Leave Status & Contribution Info (Icons.calendar_today)
/// 4. Loan Information & Deductions (Icons.account_balance)
class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  int _selectedTabIndex = 0;

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

  Widget _buildSelectedTabContent(EmployeeProfile profile) {
    switch (_selectedTabIndex) {
      case 0:
        return PersonalTabEmployeeInfo(profile: profile);
      case 1:
        return PersonalTabEmployment(profile: profile);
      case 2:
        return PersonalTabLeaveContributions(profile: profile);
      case 3:
        return PersonalTabLoansDeductions(profile: profile);
      default:
        return const SizedBox();
    }
  }

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
          PersonalProfileHeader(profile: profile),
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
}
