import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/favorite_item_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('favorites_screen.your_favorites'.tr(),
              style: tt.headlineMedium?.copyWith(fontSize: 30)),
          const SizedBox(height: 32),
          FavoriteItemCard(
            imagePath: 'assets/images/coffee_preparation.png',
            name: 'Midnight Cortado',
            description: 'Equal parts robust espresso and silky, textured milk. A delicate balance for the discerning palate.',
            price: r'$4.50',
          ),
          const SizedBox(height: 24),
          FavoriteItemCard(
            imagePath: 'assets/images/latte_art_being_poured.png',
            name: 'Obsidian Pour Over',
            description: 'Single-origin Ethiopian beans, meticulously brewed. Notes of dark cherry and subtle cocoa.',
            price: r'$5.00',
          ),
          const SizedBox(height: 24),
          FavoriteItemCard(
            imagePath: 'assets/images/artisanal_coffee_brewing.png',
            name: 'Amber Cold Brew',
            description: 'Slow-steeped for 18 hours. Smooth, deeply resonant, served over crystalline ice.',
            price: r'$6.25',
          ),
        ],
      ),
    );
  }
}
