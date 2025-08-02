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
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
            child: Container(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(1, 1.5),
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
