import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/checkout/domain/entities/cart_item.dart';
import '../../features/checkout/presentation/cubit/cart_cubit.dart';
import '../../features/menu/domain/entities/option_value.dart';
import '../../features/menu/domain/entities/product.dart';
import '../../features/orders/domain/entities/order_item.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/orders/presentation/cubit/orders_state.dart';
import 'quick_add_option_card.dart';

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
      _showSheet(context, productName, productDescription, productImage, price, product, []);
      return;
    }

    // Check if there's a last order for this product.
    List<OrderItem> lastItems = [];
    final ordersState = context.read<OrdersCubit>().state;
    final hasLastOrder = ordersState is OrdersLoaded &&
        ordersState.latestOrder != null;
    if (hasLastOrder) {
      lastItems = ordersState.latestOrder!.items
          .where((i) => i.menuItemId == product.id)
          .toList();
    }

    // Check if there are extras/addons.
    final hasExtras = product.optionGroups.any((g) {
      final n = g.name.toLowerCase();
      return n.contains('extra') || n.contains('add-on');
    });

    // If no last order and no extras, add directly without popup.
    if (lastItems.isEmpty && !hasExtras) {
      _addToCartDirectly(context, product);
      return;
    }

    _showSheet(context, productName, productDescription, productImage, price, product, lastItems);
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
      barrierColor: Colors.black.withAlpha(153),
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

  static void _addToCartDirectly(BuildContext context, Product product) {
    final cartCubit = context.read<CartCubit>();
    // Build variant from the first (default) option of each group.
    final variantParts = <String>[];
    final defaultIds = <String>[];
    double upcharge = 0;
    for (final group in product.optionGroups) {
      if (group.values.isNotEmpty) {
        final defaultOpt = group.values.first;
        variantParts.add(defaultOpt.name);
        defaultIds.add(defaultOpt.id);
        upcharge += defaultOpt.priceModifier;
      }
    }
    final item = CartItem(
      id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      name: product.name,
      imagePath: product.imagePath ?? '',
      variant: variantParts.join(' • '),
      unitPrice: product.basePrice + upcharge,
      quantity: 1,
      modifierIds: defaultIds,
    );
    cartCubit.addItem(item);
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
    if (product == null) return [];
    final result = <OptionValue>[];
    for (final group in product.optionGroups) {
      final n = group.name.toLowerCase();
      if (n.contains('extra') || n.contains('add-on')) {
        result.addAll(group.values);
      }
    }
    return result;
  }

  double get _selectedUpcharge {
    double total = 0;
    for (final opt in _extraOptions) {
      if (_selectedOptionIds.contains(opt.id)) {
        total += opt.priceModifier;
      }
    }
    return total;
  }

  void _addToCart() {
    final product = widget.product;
    if (product == null) return;

    final variantParts = <String>[];
    final lastItems = _lastOrderItems;
    if (lastItems != null) {
      for (final item in lastItems) {
        for (final sel in item.selections) {
          final name = sel['modifier_name'] as String? ?? '';
          if (name.isNotEmpty) variantParts.add(name);
        }
      }
    } else {
      // No last order — use default options from non-extra groups.
      for (final group in product.optionGroups) {
        final n = group.name.toLowerCase();
        if (!n.contains('extra') && !n.contains('add-on') && group.values.isNotEmpty) {
          variantParts.add(group.values.first.name);
        }
      }
    }
    for (final optId in _selectedOptionIds) {
      for (final opt in _extraOptions) {
        if (opt.id == optId) variantParts.add(opt.name);
      }
    }

    // Collect modifier IDs from last order selections + selected extras.
    final modifierIds = <String>[];
    if (lastItems != null) {
      for (final item in lastItems) {
        for (final sel in item.selections) {
          final id = sel['modifier_id'] as String?;
          if (id != null) modifierIds.add(id);
        }
      }
    }
    modifierIds.addAll(_selectedOptionIds);

    final variant = variantParts.isNotEmpty
        ? variantParts.join(' • ')
        : product.name;

    final item = CartItem(
      id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      name: product.name,
      imagePath: product.imagePath ?? '',
      variant: variant,
      unitPrice: product.basePrice + _selectedUpcharge,
      quantity: 1,
      modifierIds: modifierIds,
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

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: cs.outlineVariant.withAlpha(77))),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(
          child: Container(
            margin: const EdgeInsets.all(16), width: 48, height: 4,
            decoration: BoxDecoration(color: cs.outlineVariant.withAlpha(128), borderRadius: BorderRadius.circular(2)),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Last Order section
              if (lastItems != null) ...[
                Text('quick_add.last_order'.tr(),
                    style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
                const SizedBox(height: 12),
                ...lastItems.map((item) => _savedOrderCard(cs, tt, item)),
                const SizedBox(height: 24),
              ],
              // Quick Add section
              if (extras.isNotEmpty) ...[
                Text('quick_add.quick_add'.tr(),
                    style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
                const SizedBox(height: 12),
                ...extras.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _optionCard(cs, tt, opt),
                )),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: Text(
                    '\$${((widget.product?.basePrice ?? 0) + _selectedUpcharge).toStringAsFixed(2)} - Add to Cart',
                    style: tt.labelLarge?.copyWith(color: cs.onPrimary),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary, foregroundColor: cs.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _savedOrderCard(ColorScheme cs, TextTheme tt, OrderItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withAlpha(51)),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 64, height: 64,
            child: widget.productImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.productImage,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(color: cs.surfaceContainerHighest),
                  )
                : Container(color: cs.surfaceContainerHighest),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name,
                style: tt.headlineMedium?.copyWith(fontSize: 16, color: cs.primary)),
            if (item.selections.isNotEmpty)
              Text(
                item.selections.map((s) => s['modifier_name'] ?? '').join(', '),
                maxLines: 2, overflow: TextOverflow.ellipsis, style: tt.bodySmall,
              ),
            Text('x${item.quantity}  \$${item.price.toStringAsFixed(2)}',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: cs.primary, shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero, iconSize: 20,
            onPressed: () {
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
                  : widget.productName;
              final cartItem = CartItem(
                id: '${widget.product?.id ?? ''}_${DateTime.now().millisecondsSinceEpoch}',
                productId: widget.product?.id ?? '',
                name: widget.productName,
                imagePath: widget.productImage,
                variant: variant,
                unitPrice: item.price,
                quantity: item.quantity,
                modifierIds: ids,
              );
              widget.onAddToCart(cartItem);
              Navigator.pop(context);
            },
            icon: Icon(Icons.replay, color: cs.onPrimary),
          ),
        ),
      ]),
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
