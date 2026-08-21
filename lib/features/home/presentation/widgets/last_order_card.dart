import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../../menu/presentation/cubit/menu_cubit.dart';
import '../../../menu/presentation/cubit/menu_state.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';

class LastOrderCard extends StatelessWidget {
  const LastOrderCard({super.key});

  void _reorder(BuildContext context, OrdersLoaded state) {
    final latestOrder = state.latestOrder;
    if (latestOrder == null) return;

    final cartCubit = context.read<CartCubit>();
    for (final item in latestOrder.items) {
      cartCubit.addItem(
        cartCubit.reorderOrderItemRaw(item, orderId: latestOrder.id),
      );
    }
    context.read<ShellCubit>().pushSecondary(const CartRoute());
  }

  /// Product image paths indexed by product id, built once per build from
  /// the loaded menu instead of scanning products per order item.
  Map<String, String> _imageById(BuildContext context) {
    final result = <String, String>{};
    final menuState = context.read<MenuCubit>().state;
    if (menuState is MenuLoaded) {
      for (final product in menuState.products) {
        result[product.id] = product.imagePath ?? '';
      }
    }
    return result;
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
            final imageById = _imageById(context);
            final shortId = latestOrder.id.substring(0, 8).toUpperCase();
            return Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withAlpha(153)),
              ),
              padding: AppInsets.a12,
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
                        style: AppTextStyles.bodyLarge(
                          weight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.v12,
                  ...latestOrder.items.map((item) {
                    final image = imageById[item.menuItemId] ?? '';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: image.isNotEmpty
                                  ? Image.network(
                                      image,
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
                          AppSpacing.h12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: AppTextStyles.bodyMedium(
                                    weight: FontWeight.w600,
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
                    );
                  }),
                  AppSpacing.v8,
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
