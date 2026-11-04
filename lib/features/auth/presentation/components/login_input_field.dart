import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Form input field with outline border and floating label matching PayrollNeo web style.
class LoginInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const LoginInputField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 14.5,
        color: Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 13.5,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
