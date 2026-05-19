import 'package:flutter/material.dart';

import 'featured_item_card.dart';

class FeaturedItemsView extends StatelessWidget {
  const FeaturedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenHeight * 0.45;
    final cardWidth = screenWidth * 0.85;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, index) => SizedBox(
          width: cardWidth,
          child: FeaturedItemCard(
            imagePath: 'assets/images/cardamom_cose_latte.png',
            name: 'Cardamom Rose Latte',
            description:
                'Robust espresso, steamed oat milk, and house-made cardamom-rose syrup.',
            price: r'$7.25',
          ),
        ),
      ),
    );
  }
}
