
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class DashboardTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardTile({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  State<DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  bool _isPressed = false;
  double _scale = 1.0;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);
    final iconSize = 32.0 * scale;
    final spacing = 12.0 * scale;
    final fontSize = 13.0 * scale;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
          _scale = 0.93;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          _scale = 1.0;
        });
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
          _scale = 1.0;
        });
        },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
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
              Icon(widget.icon, size: iconSize, color: AppColors.primaryBoldColor),
              SizedBox(height: spacing),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}