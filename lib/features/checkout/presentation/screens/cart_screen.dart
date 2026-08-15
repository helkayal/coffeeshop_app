import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/order_summary_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cubit = context.read<CartCubit>();

          return switch (state) {
            CartLoading() => const Center(child: CircularProgressIndicator()),
            CartError(:final message) => Center(
              child: Text(
                message,
                style: tt.bodyMedium?.copyWith(color: cs.error),
              ),
            ),
            CartLoaded() ||
            CartActionInProgress() ||
            OrderResultState() => _buildContent(context, tt, cs, cubit, state),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TextTheme tt,
    ColorScheme cs,
    CartCubit cubit,
    CartState state,
  ) {
    final cart = switch (state) {
      CartLoaded(:final cart) => cart,
      CartActionInProgress(:final cart) => cart,
      _ => null,
    };

    if (cart == null || cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'checkout.empty_bag'.tr(),
              style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'checkout.your_bag'.tr(),
            style: tt.headlineMedium?.copyWith(
              fontSize: 36,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text('checkout.review_selection'.tr(), style: tt.bodySmall),
          const SizedBox(height: 40),
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: CartItemCard(
                item: item,
                onIncrement: () => cubit.increment(item.id),
                onDecrement: () => cubit.decrement(item.id),
                onRemove: () => cubit.remove(item.id),
              ),
            ),
          ),
          const SizedBox(height: 8),
          OrderSummaryCard(
            subtotal: 'common.price'.tr(
              namedArgs: {'amount': cart.subtotal.toStringAsFixed(2)},
            ),
            shipping: 'checkout.calculated_next'.tr(),
            total: 'common.price'.tr(
              namedArgs: {'amount': cart.subtotal.toStringAsFixed(2)},
            ),
            onCheckout: () =>
                context.read<ShellCubit>().pushSecondary(const PaymentRoute()),
          ),
        ],
      ),
    );
  }
}
