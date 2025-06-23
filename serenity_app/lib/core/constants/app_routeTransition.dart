import 'package:flutter/material.dart';
class AppRouteTransition<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration transitionDuration;
  final Curve pushCurve;
  final Curve popCurve;

  AppRouteTransition({
    required this.page,
    this.transitionDuration = const Duration(milliseconds: 400),
    this.pushCurve = Curves.easeOut,
    this.popCurve = Curves.easeIn,
  }) : super(
    transitionDuration: transitionDuration,
    reverseTransitionDuration: transitionDuration,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Forward (push) animation
      final pushAnim =
      CurvedAnimation(parent: animation, curve: pushCurve);

      // Reverse (pop) animation
      final popAnim =
      CurvedAnimation(parent: secondaryAnimation, curve: popCurve);

      // Slide from right when pushing
      final offsetPush = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(pushAnim);

      // Slide to left when popping
      final offsetPop = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.0, 0.0),
      ).animate(popAnim);

      return SlideTransition(
        position: offsetPush,
        child: SlideTransition(
          position: offsetPop,
          child: FadeTransition(
            opacity: pushAnim,
            child: child,
          ),
        ),
      );
    },
  );

  /// -------------------------------------------------------------------------
  ///  Static helper: **fadeRoute**
  ///  Matches the `_createRoute` you used in SplashScreen
  /// -------------------------------------------------------------------------
  static Route<T> fadeRoute<T>(
      Widget destination, {
        Duration duration = const Duration(seconds: 2),
      }) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => destination,
      transitionDuration: duration,
      transitionsBuilder: (_, animation, __, child) {
        const begin = 0.5;
        const end = 1.0;
        const curve = Curves.easeInOut;

        final tween = Tween<double>(begin: begin, end: end)
            .chain(CurveTween(curve: curve));
        final fade = animation.drive(tween);

        return FadeTransition(opacity: fade, child: child);
      },
    );
  }
}
