import 'package:flutter/material.dart';
import 'package:flutter_app/components/buttons/app_button.dart';
import 'package:flutter_app/components/inputs/app_text_field.dart';
import '../viewmodels/login_viewmodel.dart';

/// Form component for user login credentials.
class LoginForm extends StatefulWidget {
  final LoginViewModel viewModel;
  final VoidCallback onLoginSuccess;

  const LoginForm({
    super.key,
    required this.viewModel,
    required this.onLoginSuccess,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'cbc@67');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await widget.viewModel.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (success) {
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
          AppTextField(
            controller: _emailController,
            label: 'Login ID / Email',
            hint: 'Enter your Login ID or email',
            prefixIcon: const Icon(Icons.person_outline, size: 20),
            validator: (v) => (v == null || v.isEmpty) ? 'Please enter Login ID' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            obscureText: _obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Please enter password' : null,
          ),
          if (widget.viewModel.errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              widget.viewModel.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 24),
          AppButton(
            text: 'Sign In',
            isLoading: widget.viewModel.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
