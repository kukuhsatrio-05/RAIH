import 'package:flutter/material.dart';
import 'package:raih/core/constants/const_colors.dart';

class NavbarBackground extends StatelessWidget {
  final double activeIndex;
  final int itemCount;

  const NavbarBackground({
    super.key,
    required this.activeIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: NavbarBackgroundPainter(
          activeIndex: activeIndex,
          itemCount: itemCount,
        ),
      ),
    );
  }
}

class NavbarBackgroundPainter extends CustomPainter {
  final double activeIndex;
  final int itemCount;

  NavbarBackgroundPainter({
    required this.activeIndex,
    required this.itemCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.whiteNormal
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    const double y0 = 0.0;
    const double cornerRadius = 28.0;

    // Calculate the notch center
    final double itemWidth = width / itemCount;
    final double x0 = (activeIndex + 0.5) * itemWidth;

    final Path path = Path();
    path.moveTo(0, height);
    path.lineTo(0, y0 + cornerRadius);

    // Top-left corner
    path.quadraticBezierTo(0, y0, cornerRadius, y0);

    // Flat top edge to the notch
    const double notchWidth = 90.0;
    final double startX = x0 - notchWidth / 2;
    final double endX = x0 + notchWidth / 2;
    const double depth = 30.0;

    path.lineTo(startX, y0);

    // Notch curve (smooth dip using cubic bezier curves)
    path.cubicTo(
      x0 - 25.0, y0,
      x0 - 20.0, y0 + depth,
      x0, y0 + depth,
    );
    path.cubicTo(
      x0 + 20.0, y0 + depth,
      x0 + 25.0, y0,
      endX, y0,
    );

    // Flat top edge to the right corner
    path.lineTo(width - cornerRadius, y0);

    // Top-right corner
    path.quadraticBezierTo(width, y0, width, y0 + cornerRadius);

    path.lineTo(width, height);
    path.close();

    // Draw the shadow
    // Use a soft shadow to match visual elevation
    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.06), // Soft shadow
      12.0, // Elevation
      true, // Transparent occluder
    );

    // Paint the white background shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavbarBackgroundPainter oldDelegate) {
    return oldDelegate.activeIndex != activeIndex || oldDelegate.itemCount != itemCount;
  }
}
