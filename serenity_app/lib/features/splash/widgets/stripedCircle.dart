import 'package:flutter/cupertino.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class StripedCircle extends StatelessWidget {
  final double size;

  const StripedCircle({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      size: Size(size, size),
      painter: _StripedCirclePainter(),
    );
  }
}

class _StripedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.secondaryLighterColor // Stripe color
      ..strokeWidth = 3;

    // Clip the paint area to a circle
    final Path clipPath = Path()
      ..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.clipPath(clipPath);

    // Draw diagonal lines across the circle
    const double spacing = 8;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i + size.height, 0),
        Offset(i, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
