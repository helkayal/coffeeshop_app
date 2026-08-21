import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_design_constants.dart';
import '../theme/app_insets.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum SnackBarType { error, success, info }

class AppSnackBar {
  /// Shows a themed snackbar matching the app's coffee-shop aesthetic.
  ///
  /// [message] is translated internally: pass localization keys, or already
  /// translated text (`.tr()` returns non-key text unchanged).
  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.error,
  }) {
    final colors = Theme.of(context).colorScheme;

    final (
      Color background,
      Color foreground,
      Color accent,
      IconData icon,
    ) = switch (type) {
      SnackBarType.error => (
        colors.error.withAlpha(230),
        colors.onError,
        colors.error,
        Icons.error_outline,
      ),
      SnackBarType.success => (
        AppColors.successBackground,
        AppColors.successForeground,
        AppColors.successAccent,
        Icons.check_circle_outline,
      ),
      SnackBarType.info => (
        colors.primary.withAlpha(230),
        colors.onPrimary,
        colors.primary,
        Icons.info_outline,
      ),
    };

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              AppSpacing.h14,
              Expanded(
                child: Text(
                  message.tr(),
                  style: AppTextStyles.bodyMedium(
                    weight: FontWeight.w500,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: AppDesignConstants.radiusMedium,
          ),
          margin: AppInsets.h16v12,
          padding: AppInsets.h18v14,
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.horizontal,
          elevation: 0,
        ),
      );
  }
}
