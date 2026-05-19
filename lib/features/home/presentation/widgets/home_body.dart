import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'explore_menu_button.dart';
import 'featured_items_view.dart';
import 'home_profile_section.dart';
import 'order_item_card.dart';
import 'section_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeProfileSection(),
          const SizedBox(height: 15),
          SectionHeader(title: 'home_screen.our_pick'.tr()),
          const SizedBox(height: 10),
          const FeaturedItemsView(),
          const SizedBox(height: 20),
          SectionHeader(title: 'home_screen.your_last_order'.tr()),
          const SizedBox(height: 5),
          const OrderItemCard(
            imagePath: 'assets/images/coffee_preparation.png',
            name: 'Ethiopian Yirgacheffe',
            description: 'Pour Over • Light Roast',
            price: r'$6.50',
            actionIcon: Icons.replay,
          ),
          const SizedBox(height: 15),
          const ExploreMenuButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
