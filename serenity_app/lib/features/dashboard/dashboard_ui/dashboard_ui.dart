import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/dashboard/dashboard_ui/widgets/bottom_navigation_bar_item.dart';
import 'package:serenity_app/features/dashboard/tabs/home/home_ui/home_ui.dart';
import 'package:serenity_app/features/dashboard/tabs/chat/chat_ui/chat_ui.dart';
import 'package:serenity_app/features/dashboard/tabs/profile/profile_ui/profile_ui.dart';
import 'package:serenity_app/features/dashboard/tabs/settings/settings_ui/settings_ui.dart';

import '../../../core/services/LocalizationService.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeUI(),
    ChatUI(),
    ProfileUI(),
    SettingsUI(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    final iconSize = 24.0 * scale;

    var appLocalization = Provider.of<LocalizationService>(context, listen: false);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.white,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppColors.secondaryColor,
          unselectedItemColor: AppColors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            buildNavItem(icon: Icons.home, label: appLocalization.getLocalizedString("home"), index: 0, currentIndex: _currentIndex, iconSize: iconSize),
            buildNavItem(icon: Icons.chat_bubble_outline, label: appLocalization.getLocalizedString("chat"), index: 1, currentIndex: _currentIndex, iconSize: iconSize),
            buildNavItem(icon: Icons.person_outline, label: appLocalization.getLocalizedString("profile"), index: 2, currentIndex: _currentIndex, iconSize: iconSize),
            buildNavItem(icon: Icons.settings, label: appLocalization.getLocalizedString("settings"), index: 3, currentIndex: _currentIndex, iconSize: iconSize),
          ],
        ),
      ),
    );
  }

}
