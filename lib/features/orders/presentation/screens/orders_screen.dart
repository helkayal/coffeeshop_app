import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: cs.surface,
          body: SingleChildScrollView(
            padding: AppInsets.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppInsets.b24t8,
                  child: Text(
                    'orders_screen.your_orders'.tr(),
                    style: tt.headlineMedium?.copyWith(fontSize: 24),
                  ),
                ),
                switch (state) {
                  OrdersInitial() || OrdersLoading() => const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.s48),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  OrdersError(:final message) => Center(
                    child: Text(
                      message,
                      style: tt.bodyMedium?.copyWith(color: cs.error),
                    ),
                  ),
                  OrdersLoaded(:final orders) when orders.isEmpty =>
                    const EmptyState(message: 'orders_screen.no_orders'),
                  OrdersLoaded(:final orders) => Column(
                    children: [
                      for (final order in orders) ...[
                        OrderCard(order: order),
                        AppSpacing.v16,
                      ],
                    ],
                  ),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}
