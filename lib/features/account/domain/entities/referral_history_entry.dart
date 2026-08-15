class ReferralHistoryEntry {
  final String referredEmail;
  final int pointsEarned;
  final DateTime createdAt;

  const ReferralHistoryEntry({
    required this.referredEmail,
    required this.pointsEarned,
    required this.createdAt,
  });
}
