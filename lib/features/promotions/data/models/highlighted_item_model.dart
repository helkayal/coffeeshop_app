import '../../domain/entities/highlighted_item.dart';

class HighlightedItemModel extends HighlightedItem {
  const HighlightedItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.basePrice,
    required super.menuItemId,
    required super.categoryId,
    required super.categoryName,
    required super.displayOrder,
  });

  factory HighlightedItemModel.fromJson(Map<String, dynamic> json) {
    return HighlightedItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      basePrice: json['base_price'] as String? ?? '0.00',
      menuItemId: json['menu_item_id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );
  }
}
