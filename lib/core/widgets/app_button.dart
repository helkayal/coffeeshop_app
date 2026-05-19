import 'package:flutter/material.dart';

import '../theme/app_design_constants.dart';

enum AppButtonStyle { primary, secondary }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonStyle style;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPrimary = style == AppButtonStyle.primary;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? colorScheme.primary : Colors.transparent,
          foregroundColor: isPrimary
              ? colorScheme.onPrimary
              : colorScheme.primary,
          elevation: 0,
          side: isPrimary ? null : BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: AppDesignConstants.radiusMedium,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }
}
