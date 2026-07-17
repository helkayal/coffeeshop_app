class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String menuItemId;
  final List<Map<String, dynamic>> selections;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.menuItemId = '',
    this.selections = const [],
  });

  double get total => price * quantity;
}
