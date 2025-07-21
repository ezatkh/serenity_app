import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double scale;
  final bool enabled;
  final Color? labelColor;
  final String? Function(String?)? validator;

  const CustomDateField({
    super.key,
    required this.label,
    required this.controller,
    required this.scale,
    this.enabled = true,
    this.labelColor,
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
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
              color: labelColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 6.0 * scale),
        TextFormField(
          controller: controller,
          readOnly: true,
          enabled: enabled,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: inputFontSize,
            color: enabled ? AppColors.black : AppColors.grey,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: hintFontSize,
              color: AppColors.grey,
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: AppColors.grey),
            filled: true,
            fillColor: AppColors.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryBoldColor, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grey, width: 1),
            ),
          ),
            onTap: () async {
              if (!enabled) return;

              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.tryParse(controller.text) ?? DateTime(1990, 1, 1),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.secondaryColor, // Header & selected date
                        onPrimary: Colors.white, // Text on header
                        onSurface: AppColors.primaryColor, // Body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.secondaryColor, // OK/Cancel buttons
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                controller.text = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
              }
            }
        ),
      ],
    );
  }
}
