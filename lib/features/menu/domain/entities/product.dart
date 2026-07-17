import 'option_group.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String? imagePath;
  final double basePrice;
  final String category;
  final List<OptionGroup> optionGroups;
  final bool isFavorited;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    this.imagePath,
    required this.basePrice,
    required this.category,
    this.optionGroups = const [],
    this.isFavorited = false,
  });
}
