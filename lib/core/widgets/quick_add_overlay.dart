import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/checkout/domain/entities/cart_item.dart';
import '../../features/checkout/presentation/cubit/cart_cubit.dart';
import '../../features/menu/domain/entities/option_value.dart';
import '../../features/menu/domain/entities/product.dart';
import '../../features/orders/domain/entities/order_item.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/orders/presentation/cubit/orders_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_insets.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'quick_add_option_card.dart';
import 'saved_order_card.dart';

class QuickAddOverlay extends StatefulWidget {
  final String productName;
  final String productDescription;
  final String productImage;
  final String price;
  final Product? product;
  final List<OrderItem> lastOrderItems;
  final void Function(CartItem item) onAddToCart;

  const QuickAddOverlay({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.price,
    this.product,
    this.lastOrderItems = const [],
    required this.onAddToCart,
  });

  static void show(
    BuildContext context, {
    required String productName,
    required String productDescription,
    required String productImage,
    required String price,
    Product? product,
  }) {
    // If no product, show the popup anyway (fallback).
    if (product == null) {
      _showSheet(
        context,
        productName,
        productDescription,
        productImage,
        price,
        product,
        [],
      );
      return;
    }

    // Check if there's a last order for this product.
    List<OrderItem> lastItems = [];
    final ordersState = context.read<OrdersCubit>().state;
    if (ordersState case OrdersLoaded(latestOrder: final order?)) {
      lastItems = order.items
          .where((item) => item.menuItemId == product.id)
          .toList();
    }

    // If no last order and no extras, add directly without popup.
    final hasExtras = product.optionGroups.any((group) => group.isMulti);
    if (lastItems.isEmpty && !hasExtras) {
      context
          .read<CartCubit>()
          .addItem(context.read<CartCubit>().buildQuickAddItem(product));
      return;
    }

    _showSheet(
      context,
      productName,
      productDescription,
      productImage,
      price,
      product,
      lastItems,
    );
  }

  static void _showSheet(
    BuildContext context,
    String productName,
    String productDescription,
    String productImage,
    String price,
    Product? product,
    List<OrderItem> lastOrderItems,
  ) {
    final cartCubit = context.read<CartCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.barrier,
      isScrollControlled: true,
      builder: (_) => QuickAddOverlay(
        productName: productName,
        productDescription: productDescription,
        productImage: productImage,
        price: price,
        product: product,
        lastOrderItems: lastOrderItems,
        onAddToCart: (item) => cartCubit.addItem(item),
      ),
    );
  }

  @override
  State<QuickAddOverlay> createState() => _QuickAddOverlayState();
}

class _QuickAddOverlayState extends State<QuickAddOverlay> {
  final Set<String> _selectedOptionIds = {};

  List<OrderItem>? get _lastOrderItems {
    final items = widget.lastOrderItems;
    return items.isNotEmpty ? items : null;
  }

  List<OptionValue> get _extraOptions {
    final product = widget.product;
    if (product == null) return const [];
    return product.optionGroups
        .where((group) => group.isMulti)
        .expand((group) => group.values)
        .toList();
  }

  void _addToCart() {
    final product = widget.product;
    if (product == null) return;

    final item = context.read<CartCubit>().buildQuickAddItem(
      product,
      lastOrderItems: _lastOrderItems ?? const [],
      selectedExtraIds: _selectedOptionIds,
    );
    widget.onAddToCart(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final lastItems = _lastOrderItems;
    final extras = _extraOptions;
    final product = widget.product;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: cs.outlineVariant.withAlpha(77))),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: AppInsets.a16,
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant.withAlpha(128),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: AppInsets.b24h24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last Order section
                  if (lastItems != null && product != null) ...[
                    Text(
                      'quick_add.last_order'.tr(),
                      style: AppTextStyles.subtitle(color: cs.onSurface)
                          .copyWith(height: 1.3),
                    ),
                    AppSpacing.v12,
                    ...lastItems.map(
                      (item) => SavedOrderCard(
                        item: item,
                        product: product,
                        productName: widget.productName,
                        productImage: widget.productImage,
                        onAddToCart: widget.onAddToCart,
                      ),
                    ),
                    AppSpacing.v24,
                  ],
                  // Quick Add section
                  if (extras.isNotEmpty) ...[
                    Text(
                      'quick_add.quick_add'.tr(),
                      style: AppTextStyles.subtitle(color: cs.onSurface)
                          .copyWith(height: 1.3),
                    ),
                    AppSpacing.v12,
                    ...extras.map(
                      (opt) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                        child: _optionCard(cs, tt, opt),
                      ),
                    ),
                  ],
                  AppSpacing.v32,
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _addToCart,
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: Text(
                        'common.add_to_cart_price'.tr(
                          namedArgs: {
                            'price': 'common.price'.tr(
                              namedArgs: {
                                'amount': product == null
                                    ? '0.00'
                                    : context
                                          .read<CartCubit>()
                                          .quickAddPrice(
                                            product,
                                            selectedExtraIds:
                                                _selectedOptionIds,
                                          )
                                          .toStringAsFixed(2),
                              },
                            ),
                          },
                        ),
                        style: tt.labelLarge?.copyWith(color: cs.onPrimary),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        padding: AppInsets.v16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.v16,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionCard(ColorScheme cs, TextTheme tt, OptionValue option) {
    final selected = _selectedOptionIds.contains(option.id);
    return QuickAddOptionCard(
      option: option,
      isSelected: selected,
      onTap: () {
        setState(() {
          if (selected) {
            _selectedOptionIds.remove(option.id);
          } else {
            _selectedOptionIds.add(option.id);
          }
        });
      },
    );
  }
}
