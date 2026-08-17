import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String imageAsset;

  const EmptyState({
    super.key,
    required this.message,
    this.imageAsset = 'assets/images/no_item_image.png',
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageAsset,
                width: width * .5,
                height: height * .3,
                fit: BoxFit.cover,
              ),
            ),
            AppSpacing.v16,
            Text(
              message.tr(),
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
