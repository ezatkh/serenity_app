import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomStatusBar extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Brightness? iconBrightness;

  const CustomStatusBar({
    Key? key,
    required this.child,
    this.color,
    this.iconBrightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brightness effectiveBrightness = iconBrightness ??
        (Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);

    final Color effectiveColor = color ?? Theme.of(context).scaffoldBackgroundColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: effectiveColor,
        statusBarIconBrightness: effectiveBrightness,
        statusBarBrightness: effectiveBrightness,
      ),
      child: child,
    );
  }
}
