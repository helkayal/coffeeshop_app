import '../../domain/entities/option_value.dart';

class OptionValueModel extends OptionValue {
  const OptionValueModel({
    required super.id,
    required super.name,
    super.priceModifier,
  });

  factory OptionValueModel.fromJson(Map<String, dynamic> json) {
    return OptionValueModel(
      id: json['id'],
      name: json['name'],
      priceModifier: (json['price_modifier'] ?? 0).toDouble(),
    );
  }
}
