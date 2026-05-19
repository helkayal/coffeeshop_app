import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Text(
      title,
      style: tt.displaySmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
      ),
    );
  }
}
