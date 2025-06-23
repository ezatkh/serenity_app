import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;

  final double fontSize;
  final Color textColor;
  final double borderRadius;
  final Color backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.fontSize = 15,
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.backgroundColor = AppColors.secondaryColor, // Default green
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? backgroundColor : backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
