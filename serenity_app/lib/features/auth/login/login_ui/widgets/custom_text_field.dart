import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final double scale;
  final String? hint;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.scale,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final labelFontSize = (12.0 * scale).clamp(12.0, 14.0);
    final inputFontSize = (14.0 * scale).clamp(14.0, 16.0);
    final hintFontSize = (13.0 * scale).clamp(13.0, 15.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.0 * scale),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: AppColors.black,
            fontSize: inputFontSize,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:  TextStyle(
              fontSize: hintFontSize,
              color: AppColors.grey,
            ),
            filled: true,
            fillColor: AppColors.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.grey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryBoldColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.errorColor,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.errorColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
