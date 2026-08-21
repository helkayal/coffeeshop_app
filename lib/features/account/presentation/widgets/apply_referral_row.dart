import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';

class ApplyReferralRow extends StatelessWidget {
  final TextEditingController controller;
  final bool isApplying;
  final VoidCallback onApply;

  const ApplyReferralRow({
    super.key,
    required this.controller,
    required this.isApplying,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'referral.enter_code'.tr(),
              filled: true,
              fillColor: cs.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cs.outlineVariant.withAlpha(128)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cs.outlineVariant.withAlpha(128)),
              ),
            ),
          ),
        ),
        AppSpacing.h12,
        FilledButton(
          onPressed: isApplying ? null : onApply,
          style: FilledButton.styleFrom(
            padding: AppInsets.h24v16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isApplying
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.lightOnPrimary,
                  ),
                )
              : Text('referral.apply'.tr()),
        ),
      ],
    );
  }
}
