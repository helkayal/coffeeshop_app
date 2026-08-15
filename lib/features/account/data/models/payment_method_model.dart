import '../../domain/entities/payment_method.dart';

class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({
    required super.id,
    required super.lastFour,
    required super.expiryMonth,
    required super.expiryYear,
    required super.brand,
    required super.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final lastFour = json['card_last4'];
    final month = _parseInt(json['expiry_month']);
    final year = _parseInt(json['expiry_year']);
    if (id is! String ||
        id.isEmpty ||
        lastFour is! String ||
        lastFour.isEmpty ||
        month == null ||
        year == null) {
      throw const FormatException('Invalid payment method');
    }
    return PaymentMethodModel(
      id: id,
      lastFour: lastFour,
      expiryMonth: month,
      expiryYear: year,
      brand: json['card_brand'] as String? ?? 'unknown',
      isDefault: json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'card_last4': lastFour,
    'expiry_month': expiryMonth,
    'expiry_year': expiryYear,
    'card_brand': brand,
    'is_default': isDefault,
  };

  static int? _parseInt(Object? value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '');
}
