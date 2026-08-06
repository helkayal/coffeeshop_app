import '../../domain/entities/promotion_banner.dart';

class PromotionBannerModel extends PromotionBanner {
  const PromotionBannerModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    super.discountPercentage,
    super.validFrom,
    super.validTo,
    required super.displayOrder,
  });

  factory PromotionBannerModel.fromJson(Map<String, dynamic> json) {
    return PromotionBannerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      discountPercentage: (json['discount_percentage'] as num?)?.toInt(),
      validFrom: json['valid_from'] as String?,
      validTo: json['valid_to'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );
  }
}
