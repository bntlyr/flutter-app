import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import '../pages/personal_schedule_screen.dart';

/// Profile Header displaying Avatar, Name, Age, Job Class,
/// Schedule navigation link, and employee credentials.
class PersonalProfileHeader extends StatelessWidget {
  final EmployeeProfile profile;

  const PersonalProfileHeader({
    super.key,
    required this.profile,
  });

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

  @override
  Widget build(BuildContext context) {
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PersonalScheduleScreen(),
                    ),
                  );
                },
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
}
