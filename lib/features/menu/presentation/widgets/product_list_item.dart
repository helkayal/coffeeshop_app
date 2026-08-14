import 'package:coffeeshop_app/core/widgets/product_card.dart';

class ProductListItem extends ProductCard {
  const ProductListItem({
    super.key,
    required super.product,
    super.onQuickAdd,
    super.onFavoriteToggle,
    super.isFavorite,
    super.onTap,
  });
}
