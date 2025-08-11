import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> items;
  final double scale;
  final Color? labelColor;
  final void Function(String?)? onChanged;
  final bool enabled;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.scale,
    this.selectedValue,
    this.labelColor,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final labelFontSize = (12.0 * scale).clamp(12.0, 14.0);
    final inputFontSize = (14.0 * scale).clamp(14.0, 16.0);

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
        DropdownButtonFormField2<String>(
          value: selectedValue,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item,
                  style:
                  TextStyle(
                    fontWeight: FontWeight.w400, fontSize: inputFontSize
                  )),
            ),
          )
              .toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
          icon: Image.asset(
            'assets/icons/up_down.png',
            width: 28,
            height: 28,
            color: enabled ? AppColors.black : AppColors.grey,
          ),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          dropdownMaxHeight: 200, // optional max height for dropdown
          dropdownWidth: null,
          offset: const Offset(0, -4), // vertical offset to place menu below the field
          style: TextStyle(
            color: enabled ? AppColors.black : AppColors.grey,
            fontSize: inputFontSize,
          ),
        ),
      ],
    );
  }
}
