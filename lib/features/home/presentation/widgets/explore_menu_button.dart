import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_constants.dart';

class ExploreMenuButton extends StatelessWidget {
  const ExploreMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: cs.primaryContainer,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: AppDesignConstants.radiusXl,
            side: BorderSide(color: cs.outlineVariant.withAlpha(102)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explore Our Menu',
              style: tt.displaySmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            Icon(Icons.arrow_forward, color: cs.onSurface),
          ],
        ),
      ),
    );
  }
}
