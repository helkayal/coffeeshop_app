import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _boxName = 'cart';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Future<Cart> getCart() async {
    final box = Hive.box(_boxName);
    final items = box.values
        .map((raw) => CartItemModel.fromMap(Map<String, dynamic>.from(raw as Map)))
        .toList();
    return Cart(items: items);
  }

  Future<void> saveItem(CartItem item) async {
    final box = Hive.box(_boxName);
    final model = CartItemModel(
      id: item.id,
      productId: item.productId,
      name: item.name,
      imagePath: item.imagePath,
      variant: item.variant,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
    );
    await box.put(item.id, model.toMap());
  }

  Future<void> deleteItem(String itemId) async {
    await Hive.box(_boxName).delete(itemId);
  }

  Future<void> clearCart() async {
    await Hive.box(_boxName).clear();
  }
}
