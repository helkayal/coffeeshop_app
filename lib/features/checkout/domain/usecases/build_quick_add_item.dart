import '../../../menu/domain/entities/product.dart';
import '../../../orders/domain/entities/order_item.dart';
import '../entities/cart_item.dart';

/// Builds cart items from a product plus optional reorder/quick-add inputs.
///
/// Pure business logic — the single source of truth for quick-add pricing
/// and cart-item assembly (used by the quick-add overlay, the saved-order
/// card, and the cart cubit).
class BuildQuickAddItemUseCase {
  final int Function() _idSeed;

  BuildQuickAddItemUseCase({int Function()? idSeed})
    : _idSeed = idSeed ?? (() => DateTime.now().millisecondsSinceEpoch);

  /// Unit price for a product with the given selected extras.
  /// Reorder context does not affect the price — extras only.
  double unitPriceFor(
    Product product, {
    Set<String> selectedExtraIds = const {},
  }) {
    var upcharge = 0.0;
    for (final group in product.optionGroups) {
      if (!group.isMulti) continue;
      for (final option in group.values) {
        if (selectedExtraIds.contains(option.id)) {
          upcharge += option.priceModifier;
        }
      }
    }
    return product.basePrice + upcharge;
  }

  /// Builds a quick-add cart item: last-order selections when reordering,
  /// default single-choice options otherwise, plus newly selected extras.
  CartItem call(
    Product product, {
    List<OrderItem> lastOrderItems = const [],
    Set<String> selectedExtraIds = const {},
  }) {
    final variantParts = <String>[];
    final modifierIds = <String>[];
    var upcharge = 0.0;

    if (lastOrderItems.isNotEmpty) {
      for (final item in lastOrderItems) {
        for (final selection in item.selections) {
          final name = selection['modifier_name'] as String? ?? '';
          if (name.isNotEmpty) variantParts.add(name);
          final id = selection['modifier_id'] as String?;
          if (id != null) modifierIds.add(id);
        }
      }
    } else {
      for (final group in product.optionGroups) {
        if (group.isMulti || group.values.isEmpty) continue;
        final option = group.values.first;
        variantParts.add(option.name);
        modifierIds.add(option.id);
        upcharge += option.priceModifier;
      }
    }

    for (final group in product.optionGroups) {
      if (!group.isMulti) continue;
      for (final option in group.values) {
        if (selectedExtraIds.contains(option.id)) {
          variantParts.add(option.name);
          modifierIds.add(option.id);
          upcharge += option.priceModifier;
        }
      }
    }

    final variant = variantParts.isNotEmpty
        ? variantParts.join(' • ')
        : product.name;

    return CartItem(
      id: '${product.id}_${_idSeed()}',
      productId: product.id,
      name: product.name,
      imagePath: product.imagePath ?? '',
      variant: variant,
      unitPrice: product.basePrice + upcharge,
      quantity: 1,
      modifierIds: modifierIds,
    );
  }

  /// Rebuilds a cart item from a previous order line — copies the ordered
  /// price and quantity rather than recomputing them.
  CartItem fromOrderItem(
    Product product,
    OrderItem item, {
    String? productName,
  }) {
    final variantParts = item.selections
        .map((s) => s['modifier_name'] as String? ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    final ids = item.selections
        .map((s) => s['modifier_id'] as String? ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    return CartItem(
      id: '${product.id}_${_idSeed()}',
      productId: product.id,
      name: productName ?? product.name,
      imagePath: product.imagePath ?? '',
      variant: variantParts.isNotEmpty
          ? variantParts.join(' • ')
          : productName ?? product.name,
      unitPrice: item.price,
      quantity: item.quantity,
      modifierIds: ids,
    );
  }

  /// Rebuilds a cart item from a raw order line without product context
  /// (used by the home reorder card, which only knows the menu item id).
  CartItem fromOrderItemRaw(OrderItem item, {required String orderId}) {
    final variantParts = item.selections
        .map((s) => s['modifier_name'] as String? ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    final ids = item.selections
        .map((s) => s['modifier_id'] as String? ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    return CartItem(
      id: '${orderId}_${item.menuItemId}_${_idSeed()}',
      productId: item.menuItemId,
      name: item.name,
      imagePath: '',
      variant: variantParts.isNotEmpty ? variantParts.join(' • ') : item.name,
      unitPrice: item.price,
      quantity: item.quantity,
      modifierIds: ids,
    );
  }
}
