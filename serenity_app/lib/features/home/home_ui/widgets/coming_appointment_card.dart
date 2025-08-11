import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class ComingAppointmentCard extends StatelessWidget {
  final String title;
  final String date;
  final String iconAsset;

  const ComingAppointmentCard({
    super.key,
    required this.title,
    required this.date,
    this.iconAsset = 'assets/icons/calender.png', // Replace with your actual icon
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scale = (screenSize.shortestSide / 375).clamp(1.0, 1.4);

    final padding = 16.0 * scale;
    final iconSize = 48.0 * scale;
    final imageSize = 36.0 * scale;
    final spacing = 16.0 * scale;

    final titleFontSize = (12.0 * scale);
    final dateFontSize = (14.0 * scale);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: padding),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                iconAsset,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4 * scale),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
