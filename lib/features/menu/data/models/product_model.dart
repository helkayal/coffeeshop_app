import '../../domain/entities/option_group.dart';
import '../../domain/entities/option_value.dart';
import '../../domain/entities/product.dart';
/// Maps the backend's flat modifier list into the frontend's nested
/// OptionGroup → OptionValue structure by grouping on [modifier_group].
List<OptionGroup> _mapModifiersToOptionGroups(
  List<dynamic> modifiersJson,
) {
  if (modifiersJson.isEmpty) return [];

  final grouped = <String, List<OptionValue>>{};
  final groupOrder = <String>[];

  for (final m in modifiersJson) {
    final json = m as Map<String, dynamic>;
    final groupName = json['modifier_group'] as String;
    if (!grouped.containsKey(groupName)) {
      grouped[groupName] = [];
      groupOrder.add(groupName);
    }

    final upchargeRaw = json['upcharge_price'];
    final upcharge = upchargeRaw is double
        ? upchargeRaw
        : double.tryParse(upchargeRaw.toString()) ?? 0.0;

    grouped[groupName]!.add(
      OptionValue(
        id: json['id'] as String? ?? groupName,
        name: json['option_name'] as String? ?? '',
        priceModifier: upcharge,
      ),
    );
  }

  return groupOrder.map((group) {
    return OptionGroup(
      id: group,
      name: group,
      values: grouped[group]!,
      required: false,
    );
  }).toList();
}

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    super.imagePath,
    required super.basePrice,
    required super.category,
    super.optionGroups,
    super.isFavorited,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final modifiers = json['modifiers'] as List<dynamic>? ?? [];
    final optionGroups = _mapModifiersToOptionGroups(modifiers);

    final priceRaw = json['base_price'];
    final basePrice = priceRaw is double
        ? priceRaw
        : double.tryParse(priceRaw?.toString() ?? '0') ?? 0.0;

    final categoryId = json['_category_id'] as String? ??
        (json['category'] is Map ? (json['category'] as Map)['id'] : json['category']) as String? ??
        '';

    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      imagePath: json['image_url'] as String?,
      basePrice: basePrice,
      category: categoryId,
      optionGroups: optionGroups,
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }
}
