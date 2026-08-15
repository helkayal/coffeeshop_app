class LoyaltyTier {
  static const tier1Boundary = 180.0;
  static const tier2Boundary = 500.0;
  static const tier3Boundary = 1000.0;

  final String name;
  final double progress;
  final int? pointsToNext;
  final String? nextTier;
  final int index;

  const LoyaltyTier({
    required this.name,
    required this.progress,
    required this.pointsToNext,
    required this.nextTier,
    required this.index,
  });

  factory LoyaltyTier.fromPoints(double points) {
    if (points < tier1Boundary) {
      final progress = (points / tier1Boundary) * 0.333;
      return LoyaltyTier(
        name: 'blue',
        progress: progress.clamp(0.0, 0.333),
        pointsToNext: (tier1Boundary - points).ceil(),
        nextTier: 'silver',
        index: 0,
      );
    } else if (points < tier2Boundary) {
      final progress =
          0.333 +
          ((points - tier1Boundary) / (tier2Boundary - tier1Boundary)) * 0.333;
      return LoyaltyTier(
        name: 'silver',
        progress: progress.clamp(0.333, 0.667),
        pointsToNext: (tier2Boundary - points).ceil(),
        nextTier: 'gold',
        index: 1,
      );
    } else if (points < tier3Boundary) {
      final progress =
          0.667 +
          ((points - tier2Boundary) / (tier3Boundary - tier2Boundary)) * 0.333;
      return LoyaltyTier(
        name: 'gold',
        progress: progress.clamp(0.667, 1.0),
        pointsToNext: (tier3Boundary - points).ceil(),
        nextTier: 'platinum',
        index: 2,
      );
    } else {
      return LoyaltyTier(
        name: 'platinum',
        progress: 1.0,
        pointsToNext: null,
        nextTier: null,
        index: 3,
      );
    }
  }
}
