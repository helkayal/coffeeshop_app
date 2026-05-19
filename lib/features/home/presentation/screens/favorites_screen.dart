import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        'Favorite',
        style: TextStyle(color: cs.primary, fontSize: 18),
      ),
    );
  }
}
