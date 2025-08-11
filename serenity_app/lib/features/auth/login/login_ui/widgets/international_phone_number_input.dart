import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class CustomPhoneNumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double scale;
  final String? hint;
  final Color? labelColor;
  final bool enabled;
  final void Function(PhoneNumber)? onChanged;

  const CustomPhoneNumberField({
    super.key,
    required this.label,
    required this.controller,
    required this.scale,
    this.hint,
    this.onChanged,
    this.labelColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final labelFontSize = (12.0 * scale).clamp(12.0, 14.0);
    final inputFontSize = (14.0 * scale).clamp(14.0, 16.0);
    final hintFontSize = (13.0 * scale).clamp(13.0, 15.0);
    final spacing = 6.0 * scale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: labelColor ?? Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: spacing),
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              // Text color inside input fields (including search field in picker)
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          child: IntlPhoneField(
            pickerDialogStyle: PickerDialogStyle(
              backgroundColor: Colors.white,
              searchFieldInputDecoration: const InputDecoration(
                fillColor: AppColors.backgroundColor,
                filled: true,
                hintText: 'Search country...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
              countryNameStyle: const TextStyle(fontSize: 15, color: Colors.black),
              countryCodeStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              // add other styles as needed
            ),
            onChanged: onChanged,
            autovalidateMode: AutovalidateMode.disabled,
            controller: controller,
            initialCountryCode: 'PT',
            showCountryFlag: true,
            dropdownIconPosition: IconPosition.leading,
            dropdownTextStyle: TextStyle(
              color: Colors.black,
              fontSize: inputFontSize,
            ),
            style: TextStyle(
              fontSize: inputFontSize,
              fontWeight: FontWeight.w400,
              color: enabled ? AppColors.black : AppColors.grey,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: hintFontSize,
                color: AppColors.grey,
              ),
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.grey, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}