import '../../domain/entities/wallet_package.dart';

class WalletPackageModel extends WalletPackage {
  const WalletPackageModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.loyaltyPoints,
  });

  factory WalletPackageModel.fromJson(Map<String, dynamic> json) {
    final amtRaw = json['amount'];
    final amt = amtRaw is num
        ? amtRaw.toDouble()
        : double.tryParse(amtRaw?.toString() ?? '');
    final id = json['id'];
    final name = json['name'];
    if (id is! String || id.isEmpty || name is! String || amt == null) {
      throw const FormatException('Invalid wallet package');
    }

    return WalletPackageModel(
      id: id,
      name: name,
      amount: amt,
      loyaltyPoints: (json['loyalty_points'] as num?)?.toInt() ?? 0,
    );
  }
}
