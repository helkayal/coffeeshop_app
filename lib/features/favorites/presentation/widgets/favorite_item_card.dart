import 'package:coffeeshop_app/core/widgets/product_card.dart';

class FavoriteItemCard extends ProductCard {
  const FavoriteItemCard({
    super.key,
    required super.product,
    super.onQuickAdd,
    super.onFavoriteToggle,
    super.isFavorite,
    super.onTap,
  }) : super(fromFavorites: true);
}
