import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class TappableIcon extends StatefulWidget {
  final VoidCallback onTap;

  const TappableIcon({super.key, required this.onTap});

  @override
  State<TappableIcon> createState() => _TappableIconState();
}

class _TappableIconState extends State<TappableIcon> {
  bool _isPressed = false;

  void _handleTap() {
    setState(() => _isPressed = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _isPressed = false);
        widget.onTap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.translucent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            child: Icon(
              Icons.arrow_forward_ios,
              size: _isPressed ? 18 : 16,
              color: _isPressed
                  ? Theme.of(context).primaryColor
                  : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
