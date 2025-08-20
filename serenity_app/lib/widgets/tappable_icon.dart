import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class TappableIcon extends StatefulWidget {

  const TappableIcon({super.key});

  @override
  State<TappableIcon> createState() => _TappableIconState();
}

class _TappableIconState extends State<TappableIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        child: Icon(
          Icons.arrow_forward_ios,
          size: _isPressed ? 18 : 16,
          color:Theme.of(context).primaryColor
        ),
      ),
    );
  }
}
