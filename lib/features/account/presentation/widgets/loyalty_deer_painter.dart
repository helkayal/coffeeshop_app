import 'package:flutter/material.dart';

class LoyaltyDeerPainter extends CustomPainter {
  final Color color;

  LoyaltyDeerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width * 0.25, size.height * 0.45);
    path.lineTo(size.width * 0.45, size.height * 0.6);
    path.lineTo(size.width * 0.48, size.height * 0.85);
    path.lineTo(size.width * 0.65, size.height * 0.85);
    path.lineTo(size.width * 0.58, size.height * 0.5);
    path.close();
    canvas.drawPath(path, paint);
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;
    final antlerPath = Path();
    antlerPath.moveTo(size.width * 0.48, size.height * 0.45);
    antlerPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.25,
      size.width * 0.25,
      size.height * 0.2,
    );
    antlerPath.moveTo(size.width * 0.52, size.height * 0.45);
    antlerPath.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.25,
      size.width * 0.75,
      size.height * 0.2,
    );
    canvas.drawPath(antlerPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant LoyaltyDeerPainter oldDelegate) =>
      oldDelegate.color != color;
}
