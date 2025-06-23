
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;

  const DashboardTile({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);
    final iconSize = 32.0 * scale;
    final spacing = 12.0 * scale;
    final fontSize = 13.0 * scale;

    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: AppColors.primaryBoldColor),
          SizedBox(height: spacing),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}