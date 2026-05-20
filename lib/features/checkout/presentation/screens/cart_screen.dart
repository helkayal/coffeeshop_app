import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../config/app_config.dart';
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
      appBar: const AppAppBar(title: AppConfig.appName, leading: BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('checkout.your_bag'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 36, color: cs.onSurface)),
          const SizedBox(height: 8),
          Text('checkout.review_selection'.tr(), style: tt.bodySmall),
          const SizedBox(height: 40),
          const CartItem(imagePath: 'assets/images/coffee_preparation.png', name: 'Artisan Pour Over Set', variant: 'Matte White • Ceramic', price: r'$85', quantity: 1),
          const SizedBox(height: 32),
          const CartItem(imagePath: 'assets/images/latte_art_being_poured.png', name: 'Ethiopia Yirgacheffe', variant: 'Whole Bean • 12oz', price: r'$24', quantity: 2),
          const SizedBox(height: 40),
          OrderSummaryCard(subtotal: r'$133.00', shipping: 'checkout.calculated_next'.tr(), total: r'$133.00'),
        ]),
      ),
    );
  }
}
