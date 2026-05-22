import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.imagePath,
    required super.variant,
    required super.unitPrice,
    required super.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      name: map['name'] as String,
      imagePath: map['image_path'] as String,
      variant: map['variant'] as String,
      unitPrice: (map['unit_price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'product_id': productId,
        'name': name,
        'image_path': imagePath,
        'variant': variant,
        'unit_price': unitPrice,
        'quantity': quantity,
      };
}
