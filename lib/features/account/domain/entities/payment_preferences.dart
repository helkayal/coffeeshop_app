class PaymentPreferences {
  final String? defaultMethod;
  final String? walletPhone;

  const PaymentPreferences({this.defaultMethod, this.walletPhone});

  PaymentPreferences copyWith({String? defaultMethod, String? walletPhone}) =>
      PaymentPreferences(
        defaultMethod: defaultMethod ?? this.defaultMethod,
        walletPhone: walletPhone ?? this.walletPhone,
      );
}
