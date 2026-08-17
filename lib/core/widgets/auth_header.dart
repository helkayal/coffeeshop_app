import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        AppSpacing.v20,
        // Brand Logo/Title
        Text(
          'app_name'.tr(),
          style: textTheme.displayLarge?.copyWith(color: colorScheme.primary),
        ),
        AppSpacing.v40,

        // Title & Subtitle
        Text(
          title,
          style: textTheme.displayLarge?.copyWith(color: colorScheme.onSurface),
        ),
        AppSpacing.v12,
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.outline),
        ),
      ],
    );
  }
}
