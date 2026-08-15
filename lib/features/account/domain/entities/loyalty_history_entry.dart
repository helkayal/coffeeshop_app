class LoyaltyHistoryEntry {
  final int points;
  final String reason;
  final DateTime createdAt;

  const LoyaltyHistoryEntry({
    required this.points,
    required this.reason,
    required this.createdAt,
  });
}
