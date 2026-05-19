import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/routes/app_routes.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextButton(
      onPressed: () => Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false),
      child: RichText(
        text: TextSpan(
          text: '${'auth.if_you_have_account'.tr()} ',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
          children: [
            TextSpan(
              text: 'auth.login'.tr(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
