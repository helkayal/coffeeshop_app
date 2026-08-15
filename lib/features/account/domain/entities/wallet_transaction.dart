enum WalletTransactionType { topUp, purchase, refund, unknown }

class WalletTransaction {
  final String id;
  final double amount;
  final WalletTransactionType type;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  bool get isCredit =>
      type == WalletTransactionType.topUp ||
      type == WalletTransactionType.refund;
}
