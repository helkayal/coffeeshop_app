import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/order_card.dart';
import '../widgets/order_line_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24, top: 8),
            child: Text('orders_screen.your_orders'.tr(),
                style: tt.headlineMedium?.copyWith(fontSize: 24)),
          ),
          const OrderCard(
            orderNumber: 'Order #SB-8921',
            date: 'Oct 24, 2023',
            total: r'$24.50',
            status: 'Delivered',
            items: [
              OrderLineItem(imagePath: 'assets/images/coffee_preparation.png', name: 'Artisan Vanilla Latte', modifiers: 'Oat Milk, Extra Hot', quantity: 'x1'),
              OrderLineItem(imagePath: 'assets/images/coffee_preparation.png', name: 'Butter Croissant', modifiers: 'Warmed', quantity: 'x2'),
            ],
          ),
          const SizedBox(height: 16),
          const OrderCard(
            orderNumber: 'Order #SB-8845',
            date: 'Oct 18, 2023',
            total: r'$18.00',
            status: 'Picked Up',
            items: [
              OrderLineItem(imagePath: 'assets/images/coffee_preparation.png', name: 'Ethiopia Yirgacheffe Pour Over', modifiers: 'Light Roast', quantity: 'x1'),
              OrderLineItem(imagePath: 'assets/images/coffee_preparation.png', name: 'Blueberry Scone', modifiers: '', quantity: 'x1'),
            ],
          ),
        ],
      ),
    );
  }
}
