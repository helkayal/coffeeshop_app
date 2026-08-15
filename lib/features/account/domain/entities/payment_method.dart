class PaymentMethod {
  final String id;
  final String lastFour;
  final int expiryMonth;
  final int expiryYear;
  final String brand;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.lastFour,
    required this.expiryMonth,
    required this.expiryYear,
    required this.brand,
    required this.isDefault,
  });
}
