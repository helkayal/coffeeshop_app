import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeProfileSection extends StatelessWidget {
  const HomeProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        _buildAvatar(cs),
        const SizedBox(width: 12),
        _buildNameSection(cs, tt),
        _buildPoints(cs, tt),
      ],
    );
  }

  Widget _buildAvatar(ColorScheme cs) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cs.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/male_placeholder.png',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Icon(Icons.person, color: cs.onSurfaceVariant),
      ),
    );
  }

  Widget _buildNameSection(ColorScheme cs, TextTheme tt) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home_screen.welcome'.tr(),
            style: tt.bodySmall?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            'Ahmed Gamal',
            style: tt.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoints(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '1,250',
          style: tt.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
        ),
        Text(
          'home_screen.points'.tr(),
          style: tt.labelLarge?.copyWith(letterSpacing: 2),
        ),
      ],
    );
  }
}
