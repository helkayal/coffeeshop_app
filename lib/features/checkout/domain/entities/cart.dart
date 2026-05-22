import 'cart_item.dart';

class Cart {
  final List<CartItem> items;

  const Cart({this.items = const []});

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.total);

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  Cart copyWith({List<CartItem>? items}) =>
      Cart(items: items ?? this.items);
}
