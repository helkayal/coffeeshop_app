import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartRemoteDataSource {
  Future<Cart> getCart();
  Future<Cart> addItem(CartItem item);
  Future<Cart> updateItem(String itemId, int quantity);
  Future<Cart> removeItem(String itemId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService _api;

  CartRemoteDataSourceImpl(this._api);

  @override
  Future<Cart> getCart() async {
    final data = await _api.get(ApiConstants.cart);
    return _parseCart(data as Map<String, dynamic>);
  }

  @override
  Future<Cart> addItem(CartItem item) async {
    final body = <String, dynamic>{
      'menu_item_id': item.productId,
      'quantity': item.quantity,
    };
    if (item.modifierIds.isNotEmpty) {
      body['modifier_ids'] = List<String>.from(item.modifierIds)..sort();
    }
    if (item.variant.isNotEmpty) {
      body['customizations'] = {'variant': item.variant};
    }
    final data = await _api.post(ApiConstants.cartItems, data: body);
    return _parseCart(data as Map<String, dynamic>);
  }

  @override
  Future<Cart> updateItem(String itemId, int quantity) async {
    final data = await _api.patch(
      '${ApiConstants.cartItems}/$itemId',
      data: {'quantity': quantity},
    );
    return _parseCart(data as Map<String, dynamic>);
  }

  @override
  Future<Cart> removeItem(String itemId) async {
    final data = await _api.delete('${ApiConstants.cartItems}/$itemId');
    return _parseCart(data as Map<String, dynamic>);
  }

  @override
  Future<void> clearCart() async {
    await _api.delete(ApiConstants.cartItems);
  }

  Cart _parseCart(Map<String, dynamic> data) {
    final itemsRaw = data['items'] as List<dynamic>? ?? [];
    final items = itemsRaw.map((i) {
      final json = i as Map<String, dynamic>;
      // Backend returns line_total as the computed per-item total including modifiers.
      final lineTotal = double.tryParse(json['line_total']?.toString() ?? '0') ?? 0;
      final quantity = (json['quantity'] as num?)?.toInt() ?? 1;
      // Build a simple variant from customizations if present.
      final customs = json['customizations'];
      String variant = '';
      if (customs is Map && customs.isNotEmpty) {
        variant = customs.values.map((v) => v.toString()).join(' • ');
      }
      // Parse modifier IDs from the backend.
      final modIdsRaw = json['modifier_ids'];
      final modifierIds = modIdsRaw is List
          ? (modIdsRaw.map((e) => e.toString()).toList()..sort())
          : <String>[];

      return CartItem(
        id: json['id'] as String,
        productId: json['menu_item_id'] as String? ?? '',
        name: json['menu_item_name'] as String? ?? '',
        imagePath: json['image_url'] as String? ?? '',
        variant: variant,
        unitPrice: quantity > 0 ? lineTotal / quantity : lineTotal,
        quantity: quantity,
        modifierIds: modifierIds,
      );
    }).toList();
    return Cart(items: items);
  }
}
