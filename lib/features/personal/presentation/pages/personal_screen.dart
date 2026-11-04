import 'package:flutter/material.dart';
import 'package:flutter_app/components/loaders/app_loading_indicator.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import '../components/personal_profile_header.dart';
import '../components/personal_tab_employee_info.dart';
import '../components/personal_tab_employment.dart';
import '../components/personal_tab_leave_contributions.dart';
import '../components/personal_tab_loans_deductions.dart';
import '../viewmodels/personal_viewmodel.dart';

/// Profile (Personal) Screen with 4 modular tabs:
/// 1. Employee & Emergency Information (Icons.person)
/// 2. Employment Information, Allowances & Entitlements (Icons.work)
/// 3. Leave Status & Contribution Info (Icons.calendar_today)
/// 4. Loan Information & Deductions (Icons.account_balance)
class PersonalScreen extends StatefulWidget {
  final PersonalViewModel? viewModel;

  const PersonalScreen({super.key, this.viewModel});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  late final PersonalViewModel _viewModel;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? PersonalViewModel();
    _viewModel.loadProfile();
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
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading && _viewModel.profile == null) {
          return const Center(
            child: AppLoadingIndicator(message: 'Loading profile...'),
          );
        }

        if (_viewModel.hasError && _viewModel.profile == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 12),
                  Text(
                    _viewModel.errorMessage ?? 'Failed to load profile',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _viewModel.loadProfile(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final profile = _viewModel.profile!;

        return RefreshIndicator(
          onRefresh: _viewModel.refresh,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                PersonalProfileHeader(profile: profile),
                const SizedBox(height: 16),
                _buildTabButtonsRow(),
                const SizedBox(height: 16),
                _buildSelectedTabContent(profile),
              ],
            ),
          ),
        );
      },
    );
  }
}
