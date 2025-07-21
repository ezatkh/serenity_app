import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:serenity_app/core/constants/app_colors.dart';

class LoginUI extends StatelessWidget {
  const LoginUI({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: math.pi / 2,
              child: Image.asset(
                'assets/images/topRight.png',
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
