import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../checkout/domain/entities/cart_item.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../../menu/presentation/cubit/menu_cubit.dart';
import '../../../menu/presentation/cubit/menu_state.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
import 'explore_menu_button.dart';
import 'featured_items_view.dart';
import 'home_profile_section.dart';
import 'section_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: HomeProfileSection(),
          ),
          const SizedBox(height: 15),
          const FeaturedItemsView(),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (_, state) {
                    if (state case OrdersLoaded(
                      latestOrder: final order?,
                    ) when order.items.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: 'home_screen.your_last_order'.tr(),
                          ),
                          const SizedBox(height: 5),
                          _LastOrderCard(),
                          const SizedBox(height: 15),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const ExploreMenuButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LastOrderCard extends StatelessWidget {
  void _reorder(BuildContext context, OrdersLoaded state) {
    final latestOrder = state.latestOrder;
    if (latestOrder == null) return;

    final cartCubit = context.read<CartCubit>();
    for (final item in latestOrder.items) {
      final variantParts = item.selections
          .map((s) => s['modifier_name'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      final ids = item.selections
          .map((s) => s['modifier_id'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      final variant = variantParts.isNotEmpty
          ? variantParts.join(' • ')
          : item.name;
      final cartItem = CartItem(
        id: '${latestOrder.id}_${item.menuItemId}_${DateTime.now().millisecondsSinceEpoch}',
        productId: item.menuItemId,
        name: item.name,
        imagePath: '',
        variant: variant,
        unitPrice: item.price,
        quantity: item.quantity,
        modifierIds: ids,
      );
      cartCubit.addItem(cartItem);
    }
    context.read<ShellCubit>().pushSecondary(const CartRoute());
  }

  String _lookupImage(BuildContext context, String menuItemId) {
    if (menuItemId.isEmpty) return '';
    final menuState = context.read<MenuCubit>().state;
    if (menuState is MenuLoaded) {
      for (final p in menuState.products) {
        if (p.id == menuItemId) {
          return p.imagePath ?? '';
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoaded) {
          final latestOrder = state.latestOrder;
          if (latestOrder != null && latestOrder.items.isNotEmpty) {
            final cs = Theme.of(context).colorScheme;
            final tt = Theme.of(context).textTheme;
            final shortId = latestOrder.id.substring(0, 8).toUpperCase();
            return Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withAlpha(153)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'common.order_id'.tr(namedArgs: {'id': shortId}),
                        style: tt.labelLarge?.copyWith(color: cs.secondary),
                      ),
                      const Spacer(),
                      Text(
                        'common.price'.tr(
                          namedArgs: {
                            'amount': latestOrder.total.toStringAsFixed(2),
                          },
                        ),
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...latestOrder.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child:
                                  _lookupImage(
                                    context,
                                    item.menuItemId,
                                  ).isNotEmpty
                                  ? Image.network(
                                      _lookupImage(context, item.menuItemId),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        color: cs.surfaceContainerHighest,
                                      ),
                                    )
                                  : Container(
                                      color: cs.surfaceContainerHighest,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: tt.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                ),
                                Text(
                                  'common.quantity_price'.tr(
                                    namedArgs: {
                                      'quantity': item.quantity.toString(),
                                      'price': 'common.price'.tr(
                                        namedArgs: {
                                          'amount': item.price.toStringAsFixed(
                                            2,
                                          ),
                                        },
                                      ),
                                    },
                                  ),
                                  style: tt.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _reorder(context, state),
                      icon: Icon(Icons.replay, size: 16, color: cs.primary),
                      label: Text(
                        'orders_screen.reorder'.tr(),
                        style: tt.labelLarge?.copyWith(color: cs.primary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
