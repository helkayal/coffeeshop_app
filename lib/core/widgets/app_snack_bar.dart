import 'package:flutter/material.dart';

import '../theme/app_design_constants.dart';

enum SnackBarType { error, success, info }

class AppSnackBar {
  /// Shows a themed snackbar matching the app's coffee-shop aesthetic.
  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.error,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
        const Color(0xE6245C3B),
        const Color(0xFFE8F5E9),
        const Color(0xFF4CAF50),
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
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  message,
                  style: textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w500,
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
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.horizontal,
          elevation: 0,
        ),
      );
  }
}
