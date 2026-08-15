import '../../domain/entities/loyalty_history_entry.dart';

sealed class LoyaltyHistoryState {
  const LoyaltyHistoryState();
}

final class LoyaltyHistoryLoading extends LoyaltyHistoryState {
  const LoyaltyHistoryLoading();
}

final class LoyaltyHistoryLoaded extends LoyaltyHistoryState {
  final List<LoyaltyHistoryEntry> entries;

  const LoyaltyHistoryLoaded(this.entries);
}

final class LoyaltyHistoryError extends LoyaltyHistoryState {
  final String failureCode;

  const LoyaltyHistoryError(this.failureCode);
}
