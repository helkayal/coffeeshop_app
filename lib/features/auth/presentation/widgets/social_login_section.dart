import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/social_button.dart';

class SocialLoginSection extends StatelessWidget {
  final void Function(String provider) onSocialLogin;

  const SocialLoginSection({super.key, required this.onSocialLogin});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'auth.continue_with_social'.tr(),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(
              icon: Icons.g_mobiledata,
              onPressed: () => onSocialLogin('google'),
              iconSize: 46,
            ),
            const SizedBox(width: 16),
            SocialButton(
              icon: Icons.facebook,
              onPressed: () => onSocialLogin('facebook'),
            ),
            const SizedBox(width: 16),
            SocialButton(
              icon: Icons.apple,
              onPressed: () => onSocialLogin('apple'),
            ),
          ],
        ),
      ],
    );
  }
}
