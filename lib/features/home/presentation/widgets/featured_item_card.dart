import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_constants.dart';
import 'action_button.dart';

class FeaturedItemCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final String price;

  const FeaturedItemCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppDesignConstants.radius2xl,
        border: Border.all(color: cs.outlineVariant.withAlpha(153)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: Container(
              color: cs.surfaceContainerHighest,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: cs.surfaceContainerHighest),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: tt.displaySmall?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodySmall?.copyWith(height: 1.625),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: tt.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                      const ActionButton(
                        icon: Icons.add_shopping_cart,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
