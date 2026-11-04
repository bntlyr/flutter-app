import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Top dark banner for Auth screens displaying the PayrollNeo branding logo.
class AuthBanner extends StatelessWidget {
  final double height;

  const AuthBanner({
    super.key,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: AppColors.gray,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Image.asset(
        'assets/images/logo.png',
        width: 240,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            'PayrollNeo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          );
        },
      ),
    );
  }
}
