import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

import '../../../../../../core/services/LocalizationService.dart';

class HomeHeader extends StatelessWidget {
  final String username;
  final int notificationCount;

  const HomeHeader({
    super.key,
    required this.username,
    this.notificationCount = 1,
  });

  // Helper method to format badge count
  String getBadgeText(int count) {
    if (count > 99) return '99+';
    return count.toString();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);
    final avatarSize = 50 * scale;
    final fontSize = (16 * scale).clamp(14.0, 22.0);
    final iconSize = 24.0 * scale;
    final badgeSize = 18.0 * scale;
    final badgeFontSize = 8.0 * scale;
    final badgeText = getBadgeText(notificationCount);
    final adjustedFontSize = badgeText == '99+'
        ? badgeFontSize * 0.85  // reduce if 99+
        : badgeFontSize;

    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    return Container(
      height: size.height * 0.12,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryBoldColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20 * scale,
        vertical: 18 * scale,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset('assets/images/person.png'),
                ),
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Text(
              "${appLocalization.getLocalizedString("welcome")}, $username",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 4 * scale),
          Stack(
            children: [
              IconButton(
                iconSize: iconSize,
                onPressed: () {
                  // Handle notification tap
                },
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 5.5 * scale,
                  top: 5.5 * scale,
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: const BoxDecoration(
                      color: AppColors.notification,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        getBadgeText(notificationCount),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: adjustedFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
