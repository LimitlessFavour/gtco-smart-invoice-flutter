import 'package:flutter/material.dart';
import '../common/app_text.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? prefixText;
  final bool readOnly;
  final Widget? suffix;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixText,
    this.readOnly = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          weight: FontWeight.w500,
          color: const Color(0xFF333333),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            suffixIcon: suffixIcon,
            suffix: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: suffix != null ? 0 : 12,
              bottom: suffix != null ? 7 : 0,
            ),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey[100] : null,
          ),
        ),
      ],
    );
  }
}
