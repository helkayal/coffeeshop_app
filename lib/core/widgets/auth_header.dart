import 'package:flutter/material.dart';

import '../../config/app_config.dart';

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
        const SizedBox(height: 20),
        // Brand Logo/Title
        Text(
          AppConfig.appName,
          style: textTheme.displayLarge?.copyWith(color: colorScheme.primary),
        ),
        const SizedBox(height: 40),

        // Title & Subtitle
        Text(title, style: textTheme.displayLarge?.copyWith(color: colorScheme.onSurface)),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.outline),
        ),
      ],
    );
  }
}
