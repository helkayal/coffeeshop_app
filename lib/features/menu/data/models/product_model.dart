import '../../domain/entities/product.dart';
import 'option_group_model.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imagePath,
    required super.basePrice,
    required super.category,
    super.optionGroups,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final optionGroups = (json['option_groups'] as List?)
            ?.map((g) => OptionGroupModel.fromJson(g))
            .toList() ??
        [];

    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['image_path'],
      basePrice: (json['base_price'] ?? 0).toDouble(),
      category: json['category'],
      optionGroups: optionGroups,
    );
  }
}
