import 'dart:io';

import 'package:flutter/material.dart';

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
            child: imagePath != null
                ? Image.file(
                    File(imagePath!),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _placeholder(colorScheme),
                  )
                : _placeholder(colorScheme),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
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
      errorBuilder: (_, _, _) => Icon(Icons.person, size: 60, color: colorScheme.outline),
    );
  }
}
