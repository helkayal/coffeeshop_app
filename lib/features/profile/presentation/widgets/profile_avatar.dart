import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final bool showEditButton;

  const ProfileAvatar({super.key, this.size = 128, this.showEditButton = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cs.primary.withAlpha(51), width: 4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/male_placeholder.png', fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: cs.surfaceContainerHighest)),
        ),
        if (showEditButton)
          Positioned(
            bottom: 0, right: -4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest, shape: BoxShape.circle,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Icon(Icons.edit, size: 16, color: cs.primary),
            ),
          ),
      ],
    );
  }
}
