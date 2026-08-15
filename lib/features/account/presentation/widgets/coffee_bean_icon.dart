import 'package:flutter/material.dart';

class CoffeeBeanIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const CoffeeBeanIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.onSurface;
    return Transform.rotate(
      angle: -0.3,
      child: CustomPaint(
        size: Size(size * 0.7, size),
        painter: _CoffeeBeanPainter(iconColor),
      ),
    );
  }
}

class _CoffeeBeanPainter extends CustomPainter {
  final Color color;

  _CoffeeBeanPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.elliptical(size.width / 2, size.height / 2),
    );
    canvas.drawRRect(rrect, paint);

    final linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final groovePath = Path();
    groovePath.moveTo(size.width * 0.5, size.height * 0.1);
    groovePath.cubicTo(
      size.width * 0.25,
      size.height * 0.35,
      size.width * 0.75,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.9,
    );
    canvas.drawPath(groovePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _CoffeeBeanPainter oldDelegate) =>
      oldDelegate.color != color;
}
