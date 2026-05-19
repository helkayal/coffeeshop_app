import 'option_group.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double basePrice;
  final String category;
  final List<OptionGroup> optionGroups;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.basePrice,
    required this.category,
    this.optionGroups = const [],
  });
}
