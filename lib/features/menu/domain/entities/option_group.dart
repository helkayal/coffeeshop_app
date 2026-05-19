import 'option_value.dart';

class OptionGroup {
  final String id;
  final String name;
  final List<OptionValue> values;
  final bool required;

  const OptionGroup({
    required this.id,
    required this.name,
    required this.values,
    this.required = false,
  });
}
