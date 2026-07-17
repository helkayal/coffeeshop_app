import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final bool showEditButton;
  final String? avatarUrl;
  final String? gender;
  final VoidCallback? onEditTap;

  const ProfileAvatar({
    super.key,
    this.size = 128,
    this.showEditButton = true,
    this.avatarUrl,
    this.gender,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cs.primary.withAlpha(51), width: 4),
          ),
          clipBehavior: Clip.antiAlias,
          child: avatarUrl != null
              ? CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => _placeholder(cs),
                )
              : _placeholder(cs),
        ),
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: -4,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Icon(Icons.edit, size: 16, color: cs.primary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholder(ColorScheme cs) {
    final asset = gender == 'female'
        ? 'assets/images/female_placeholder.png'
        : 'assets/images/male_placeholder.png';
    return Image.asset(asset,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(color: cs.surfaceContainerHighest),
    );
  }
}
