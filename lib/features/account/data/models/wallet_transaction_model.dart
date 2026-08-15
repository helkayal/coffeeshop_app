import '../../domain/entities/wallet_transaction.dart';

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final rawAmount = json['amount'];
    final amount = rawAmount is num
        ? rawAmount.toDouble()
        : double.tryParse(rawAmount?.toString() ?? '');
    final createdAt = DateTime.tryParse(json['created_at']?.toString() ?? '');
    if (id is! String || amount == null || createdAt == null) {
      throw const FormatException('Invalid wallet transaction');
    }
    return WalletTransactionModel(
      id: id,
      amount: amount,
      type: switch (json['type']) {
        'top_up' => WalletTransactionType.topUp,
        'purchase' => WalletTransactionType.purchase,
        'refund' => WalletTransactionType.refund,
        _ => WalletTransactionType.unknown,
      },
      createdAt: createdAt,
    );
  }
}
