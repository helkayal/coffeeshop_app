import '../../domain/entities/referral_history_entry.dart';

sealed class ReferralState {
  const ReferralState();
}

final class ReferralInitial extends ReferralState {
  const ReferralInitial();
}

final class ReferralLoading extends ReferralState {
  const ReferralLoading();
}

final class ReferralLoaded extends ReferralState {
  final String code;
  final List<ReferralHistoryEntry> history;
  final bool isApplying;

  const ReferralLoaded({
    required this.code,
    required this.history,
    this.isApplying = false,
  });

  ReferralLoaded copyWith({
    String? code,
    List<ReferralHistoryEntry>? history,
    bool? isApplying,
  }) {
    return ReferralLoaded(
      code: code ?? this.code,
      history: history ?? this.history,
      isApplying: isApplying ?? this.isApplying,
    );
  }
}

final class ReferralError extends ReferralState {
  final String message;
  const ReferralError(this.message);
}

final class ReferralApplySuccess extends ReferralState {
  const ReferralApplySuccess();
}

final class ReferralApplyError extends ReferralState {
  final String message;
  const ReferralApplyError(this.message);
}
