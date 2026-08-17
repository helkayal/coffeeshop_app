import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_constants.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import 'action_button.dart';

class OrderItemCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final String price;
  final IconData actionIcon;
  final bool isPrimaryAction;
  final VoidCallback? onAction;

  const OrderItemCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
    required this.actionIcon,
    this.isPrimaryAction = false,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppDesignConstants.radiusXl,
        border: Border.all(color: cs.outlineVariant.withAlpha(153)),
      ),
      padding: AppInsets.a12,
      child: Row(
        children: [
          _buildImage(cs),
          AppSpacing.h16,
          _buildDetails(cs, tt),
          ActionButton(
            icon: actionIcon,
            isPrimary: isPrimaryAction,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(ColorScheme cs) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: AppDesignConstants.radiusMedium,
        color: cs.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: imagePath.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) =>
                  Container(color: cs.surfaceContainerHighest),
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: cs.surfaceContainerHighest),
            ),
    );
  }

  Widget _buildDetails(ColorScheme cs, TextTheme tt) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: tt.displaySmall?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.v4,
          Text(
            description,
            style: tt.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.v8,
          Text(
            price,
            style: tt.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}
