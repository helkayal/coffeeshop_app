import 'package:flutter/material.dart';

import 'featured_item_card.dart';
import 'promo_banner.dart';

class FeaturedItemsView extends StatelessWidget {
  const FeaturedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenHeight * 0.4;
    final cardWidth = screenWidth * 0.85;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, index) => SizedBox(
          width: cardWidth,
          child: index.isEven ? _buildCard() : _buildPromo(),
        ),
      ),
    );
  }

  static Widget _buildCard() {
    return const FeaturedItemCard(
      imagePath: 'assets/images/cardamom_cose_latte.png',
      name: 'Cardamom Rose Latte',
      description:
          'Robust espresso, steamed oat milk, and house-made cardamom-rose syrup.',
      price: r'$7.25',
    );
  }

  static Widget _buildPromo() {
    return const PromoBanner();
  }
}
