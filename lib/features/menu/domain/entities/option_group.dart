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

  /// Multi-select groups collect "extra"/"add-on" options (checkboxes).
  bool get isMulti {
    final nameLower = name.toLowerCase();
    return nameLower.contains('extra') || nameLower.contains('add-on');
  }

  /// Slider-style groups are rendered as a step-through picker
  /// (temperature, sweetness, size).
  bool get isSlider {
    final nameLower = name.toLowerCase();
    return nameLower.contains('temperature') ||
        nameLower.contains('sweet') ||
        nameLower.contains('size');
  }
}
