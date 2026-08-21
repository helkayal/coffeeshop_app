import 'package:flutter/material.dart';

import '../theme/app_design_constants.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: AppDesignConstants.radiusMedium,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            size: iconSize,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
