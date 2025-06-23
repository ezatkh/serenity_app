import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

BottomNavigationBarItem buildNavItem({
  required IconData icon,
  required String label,
  required int index,
  required int currentIndex,
  double iconSize = 24.0,
}) {
  final isSelected = index == currentIndex;

  return BottomNavigationBarItem(
    icon: isSelected
        ? Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: iconSize * 0.75),
          const SizedBox(width: 6),
          Text(
            label,
            style:  TextStyle(
              fontSize: iconSize * 0.45,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    )
        : Icon(icon, color: AppColors.grey),
    label: '',
  );
}
