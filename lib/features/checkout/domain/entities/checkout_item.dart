class CheckoutItem {
  final String productId;
  final int quantity;
  final List<String> modifierIds;

  const CheckoutItem({
    required this.productId,
    required this.quantity,
    this.modifierIds = const [],
  });
}
