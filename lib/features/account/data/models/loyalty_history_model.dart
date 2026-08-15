import '../../domain/entities/loyalty_history_entry.dart';

class LoyaltyHistoryModel extends LoyaltyHistoryEntry {
  const LoyaltyHistoryModel({
    required super.points,
    required super.reason,
    required super.createdAt,
  });

  factory LoyaltyHistoryModel.fromJson(Map<String, dynamic> json) {
    final points = json['points'];
    final reason = json['reason'];
    final date = DateTime.tryParse(json['created_at']?.toString() ?? '');
    if (points is! num || reason is! String || date == null) {
      throw const FormatException('Invalid loyalty history entry');
    }
    return LoyaltyHistoryModel(
      points: points.toInt(),
      reason: reason,
      createdAt: date,
    );
  }
}
