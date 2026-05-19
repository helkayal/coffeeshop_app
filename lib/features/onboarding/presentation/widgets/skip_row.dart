import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/theme/app_design_constants.dart';

class SkipRow extends StatelessWidget {
  final VoidCallback onSkip;

  const SkipRow({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).colorScheme.outline,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignConstants.paddingLarge,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${'onboarding.skip_text'.tr()} ', style: textStyle),
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'onboarding.skip_action'.tr(),
              style: textStyle?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
