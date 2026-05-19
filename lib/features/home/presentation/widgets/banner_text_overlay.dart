import 'package:flutter/material.dart';

class BannerTextOverlay extends StatelessWidget {
  const BannerTextOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Limited Release',
          style: tt.labelSmall?.copyWith(letterSpacing: 2, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          'The Autumn Equinox Blend',
          style: tt.displaySmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
