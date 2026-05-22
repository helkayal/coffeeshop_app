import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
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
              switch (state) {
                OrdersLoading() => const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: CircularProgressIndicator(),
                    )),
                OrdersError(:final message) => Center(
                    child: Text(message,
                        style: tt.bodyMedium?.copyWith(color: cs.error))),
                OrdersLoaded(:final orders) when orders.isEmpty => Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Text('orders_screen.no_orders'.tr(),
                          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                    )),
                OrdersLoaded(:final orders) => Column(
                    children: [
                      for (final order in orders) ...[
                        OrderCard(order: order),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                _ => const SizedBox.shrink(),
              },
            ],
          ),
        );
      },
    );
  }
}
