import 'package:flutter/material.dart';
import '../../../../app.dart';
import '../components/auth_banner.dart';
import '../components/login_form.dart';

/// User Login Page featuring top dark banner with PayrollNeo logo
/// and bottom outline login form.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _onSuccess(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bannerHeight = (screenHeight * 0.28).clamp(180.0, 240.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Dark Banner with PayrollNeo Logo
              AuthBanner(height: bannerHeight),

              // 2. Form Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: LoginForm(
                      onLoginSuccess: () => _onSuccess(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
