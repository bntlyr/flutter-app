import 'package:flutter/material.dart';
import '../../../../app.dart';
import '../viewmodels/login_viewmodel.dart';
import '../components/auth_header.dart';
import '../components/login_form.dart';

/// User Login Page.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onSuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: 'Welcome to PayrollNeo',
                    subtitle: 'Sign in to access your attendance, payslips, and requests',
                  ),
                  const SizedBox(height: 32),
                  LoginForm(
                    viewModel: _viewModel,
                    onLoginSuccess: _onSuccess,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
