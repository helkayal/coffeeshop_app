class HighlightedItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String basePrice;
  final String menuItemId;
  final String categoryId;
  final String categoryName;
  final int displayOrder;

  const HighlightedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.menuItemId,
    required this.categoryId,
    required this.categoryName,
    required this.displayOrder,
  });
}
