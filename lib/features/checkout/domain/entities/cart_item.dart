class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imagePath;
  final String variant; // e.g. "Large • Oat Milk"
  final double unitPrice;
  final int quantity;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imagePath,
    required this.variant,
    required this.unitPrice,
    required this.quantity,
  });

  double get total => unitPrice * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        productId: productId,
        name: name,
        imagePath: imagePath,
        variant: variant,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
      );
}
