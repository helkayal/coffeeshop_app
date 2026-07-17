class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imagePath;
  final String variant;
  final double unitPrice;
  final int quantity;
  final List<String> modifierIds;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imagePath,
    required this.variant,
    required this.unitPrice,
    required this.quantity,
    this.modifierIds = const [],
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
        modifierIds: modifierIds,
      );
}
