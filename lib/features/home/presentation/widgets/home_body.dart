import 'package:flutter/material.dart';

import 'explore_menu_button.dart';
import 'featured_items_view.dart';
import 'home_profile_section.dart';
import 'order_item_card.dart';
import 'promo_banner.dart';
import 'section_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeProfileSection(),
          const SizedBox(height: 32),
          const FeaturedItemsView(),
          const SizedBox(height: 48),
          const SectionHeader(title: 'Your Last Order'),
          const SizedBox(height: 16),
          const OrderItemCard(
            imagePath: 'assets/images/coffee_preparation.png',
            name: 'Ethiopian Yirgacheffe',
            description: 'Pour Over • Light Roast',
            price: r'$6.50',
            actionIcon: Icons.replay,
          ),
          const SizedBox(height: 48),
          const ExploreMenuButton(),
          const SizedBox(height: 48),
          const PromoBanner(),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}
