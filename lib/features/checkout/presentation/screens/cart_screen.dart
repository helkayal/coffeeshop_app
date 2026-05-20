import 'package:flutter/material.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../widgets/cart_item.dart';
import '../widgets/order_summary_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppAppBar(title: 'Coffee Shop', leading: BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Your Bag', style: tt.headlineMedium?.copyWith(fontSize: 36, color: cs.onSurface)),
          const SizedBox(height: 8),
          Text('Review your curated selection.', style: tt.bodySmall),
          const SizedBox(height: 40),
          const CartItem(imagePath: 'assets/images/coffee_preparation.png', name: 'Artisan Pour Over Set', variant: 'Matte White • Ceramic', price: r'$85', quantity: 1),
          const SizedBox(height: 32),
          const CartItem(imagePath: 'assets/images/latte_art_being_poured.png', name: 'Ethiopia Yirgacheffe', variant: 'Whole Bean • 12oz', price: r'$24', quantity: 2),
          const SizedBox(height: 40),
          const OrderSummaryCard(subtotal: r'$133.00', shipping: 'Calculated next step', total: r'$133.00'),
        ]),
      ),
    );
  }
}
