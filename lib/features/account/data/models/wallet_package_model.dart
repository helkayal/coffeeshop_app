class WalletPackage {
  final String id;
  final String name;
  final double amount;
  final int loyaltyPoints;

  const WalletPackage({
    required this.id,
    required this.name,
    required this.amount,
    required this.loyaltyPoints,
  });

  factory WalletPackage.fromJson(Map<String, dynamic> json) {
    final amtRaw = json['amount'];
    final amt = amtRaw is num
        ? amtRaw.toDouble()
        : double.tryParse(amtRaw?.toString() ?? '0') ?? 0.0;

    return WalletPackage(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      amount: amt,
      loyaltyPoints: (json['loyalty_points'] as num?)?.toInt() ?? 0,
    );
  }
}
