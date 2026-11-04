import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'login_input_field.dart';

/// Login Form component featuring ID*, Password* (with toggleable eye icon),
/// and the teal Log In button.
class LoginForm extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginForm({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController(text: 'cbc@67');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // Proceed directly to main page without waiting for remote API
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() => _isLoading = false);
        widget.onLoginSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. ID Field
          LoginInputField(
            controller: _idController,
            labelText: 'ID*',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),

          // 2. Password Field
          LoginInputField(
            controller: _passwordController,
            labelText: 'Password*',
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 22,
                color: const Color(0xFF334155),
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 3. Log In Button
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppColors.primary.withAlpha(120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
