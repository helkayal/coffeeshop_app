import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String gender;

  const ProfilePictureWidget({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Image.asset(
          gender == 'female'
              ? 'assets/images/female_placeholder.png'
              : 'assets/images/male_placeholder.png',
          width: 120,
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
    );
  }
}
