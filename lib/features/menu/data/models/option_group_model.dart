import '../../domain/entities/option_group.dart';
import 'option_value_model.dart';

class OptionGroupModel extends OptionGroup {
  const OptionGroupModel({
    required super.id,
    required super.name,
    required super.values,
    super.required,
  });

  factory OptionGroupModel.fromJson(Map<String, dynamic> json) {
    final values = (json['values'] as List)
        .map((v) => OptionValueModel.fromJson(v))
        .toList();

    return OptionGroupModel(
      id: json['id'],
      name: json['name'],
      values: values,
      required: json['required'] ?? false,
    );
  }
}
