class OptionValue {
  final String id;
  final String name;
  final double priceModifier;

  const OptionValue({
    required this.id,
    required this.name,
    this.priceModifier = 0,
  });
}
