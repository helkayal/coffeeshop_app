import '../../domain/entities/home_slider_data.dart';
import 'highlighted_item_model.dart';
import 'promotion_banner_model.dart';

class HomeSliderModel extends HomeSliderData {
  const HomeSliderModel({
    required super.highlightedItems,
    required super.promotions,
  });

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;

    final rawHighlights = data['highlighted_items'] as List<dynamic>? ?? [];
    final highlightedItems = rawHighlights
        .map((e) => HighlightedItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawPromotions = data['promotions'] as List<dynamic>? ?? [];
    final promotions = rawPromotions
        .map((e) => PromotionBannerModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return HomeSliderModel(
      highlightedItems: highlightedItems,
      promotions: promotions,
    );
  }
}
