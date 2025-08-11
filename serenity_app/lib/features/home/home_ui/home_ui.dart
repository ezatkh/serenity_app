import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/home/home_ui/widgets/home_body.dart';
import 'package:serenity_app/features/home/home_ui/widgets/home_header.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryBoldColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primaryBoldColor,
        body: SafeArea(
          child: Column(
            children: const [
              HomeHeader(username: "Asad"),
              Expanded(child: HomeBody()),
            ],
          ),
        ),
      ),
    );
  }
}
