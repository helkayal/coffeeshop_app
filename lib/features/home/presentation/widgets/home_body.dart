import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
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
          const FeaturedItemsView(),
          const SizedBox(height: 20),
          SectionHeader(title: 'home_screen.your_last_order'.tr()),
          const SizedBox(height: 5),
          _LastOrderCard(),
          const SizedBox(height: 15),
          const ExploreMenuButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _LastOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoaded) {
          final latestOrder = state.latestOrder;
          if (latestOrder != null && latestOrder.items.isNotEmpty) {
            final item = latestOrder.items.first;
            return OrderItemCard(
              imagePath: 'assets/images/coffee_preparation.png',
              name: item.name,
              description: 'Order #${latestOrder.id} · ${latestOrder.status}',
              price: '\$${item.price.toStringAsFixed(2)}',
              actionIcon: Icons.replay,
            );
          }
        }

        // Fallback while loading or no orders yet.
        return const OrderItemCard(
          imagePath: 'assets/images/coffee_preparation.png',
          name: 'Ethiopian Yirgacheffe',
          description: 'Pour Over • Light Roast',
          price: r'$6.50',
          actionIcon: Icons.replay,
        );
      },
    );
  }
}
