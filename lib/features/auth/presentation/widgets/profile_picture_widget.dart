import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String gender;
  final String? imagePath;
  final VoidCallback onTap;

  const ProfilePictureWidget({
    super.key,
    required this.gender,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipOval(
            child: switch (imagePath) {
              final path? => Image.file(
                File(path),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(colorScheme),
              ),
              null => _placeholder(colorScheme),
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: AppInsets.a6,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit, size: 20, color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Image.asset(
      gender == 'female'
          ? 'assets/images/female_placeholder.png'
          : 'assets/images/male_placeholder.png',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) =>
          Icon(Icons.person, size: 60, color: colorScheme.outline),
    );
  }
}
