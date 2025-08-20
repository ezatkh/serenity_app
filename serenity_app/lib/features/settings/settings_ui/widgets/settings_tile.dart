import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool showArrow;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double elevation;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    this.showArrow = true,
    this.iconColor = Colors.black,
    this.titleColor = Colors.black,
    this.onTap,
    this.trailing,
    this.elevation = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.of(context).size.shortestSide / 375).clamp(1.0, 1.3);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: elevation, // adds shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.grey.withOpacity(0.3), // subtle shadow color
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 22 * scale,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Use custom trailing if provided
              if (trailing != null)
                trailing!
              else if (showArrow)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15 * scale,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
