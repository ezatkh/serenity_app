import 'dart:ui';  // for ImageFilter

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class LoadingAvatar extends StatelessWidget {
  const LoadingAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The blurred and dimmed background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Adjust blur intensity here
            child: Container(
              color: Colors.grey.withOpacity(0.2), // Semi-transparent grey overlay
            ),
          ),
        ),
        Center(
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: CupertinoActivityIndicator(
                radius: 15,
                color: AppColors.primaryLighterColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
