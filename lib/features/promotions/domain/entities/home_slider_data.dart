import 'highlighted_item.dart';
import 'promotion_banner.dart';

class HomeSliderData {
  final List<HighlightedItem> highlightedItems;
  final List<PromotionBanner> promotions;

  const HomeSliderData({
    required this.highlightedItems,
    required this.promotions,
  });

  bool get isEmpty => highlightedItems.isEmpty && promotions.isEmpty;
}
