import 'package:flutter/material.dart';

import '../theme/app_breakpoints.dart';

/// Centers [child] with a max-width constraint on tablet/desktop screens.
/// On phones it is a transparent pass-through with zero overhead.
class AdaptiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AdaptiveContent({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.contentMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isPhone) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
