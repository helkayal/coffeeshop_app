import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'loyalty_deer_painter.dart';

class LoyaltyCupIndicator extends StatelessWidget {
  final Color color;
  const LoyaltyCupIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cupShadow,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          Container(
            width: 17,
            height: 22,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.lightOnPrimary,
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(painter: LoyaltyDeerPainter(color)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
