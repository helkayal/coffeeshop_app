class PromotionBanner {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int? discountPercentage;
  final String? validFrom;
  final String? validTo;
  final int displayOrder;

  const PromotionBanner({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.discountPercentage,
    this.validFrom,
    this.validTo,
    required this.displayOrder,
  });
}
