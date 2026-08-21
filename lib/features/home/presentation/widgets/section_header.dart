import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Text(
      title,
      style: AppTextStyles.headlineSm(
        weight: FontWeight.w700,
        color: cs.onSurface,
      ),
    );
  }
}
