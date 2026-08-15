import '../../domain/entities/referral_history_entry.dart';

class ReferralHistoryModel extends ReferralHistoryEntry {
  const ReferralHistoryModel({
    required super.referredEmail,
    required super.pointsEarned,
    required super.createdAt,
  });

  factory ReferralHistoryModel.fromJson(Map<String, dynamic> json) {
    final email = json['referred_email'];
    final points = json['points_earned'];
    final date = DateTime.tryParse(json['created_at']?.toString() ?? '');
    if (email is! String || points is! num || date == null) {
      throw const FormatException('Invalid referral history entry');
    }
    return ReferralHistoryModel(
      referredEmail: email,
      pointsEarned: points.toInt(),
      createdAt: date,
    );
  }
}
