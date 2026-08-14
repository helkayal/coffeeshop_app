import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/referral_usecases.dart';
import 'referral_state.dart';

class ReferralCubit extends Cubit<ReferralState> {
  final GetReferralUseCase _getReferral;
  final ApplyReferralUseCase _applyReferral;
  final void Function(ConnectionFailure)? onConnectionFailure;

  ReferralCubit({
    required GetReferralUseCase getReferral,
    required ApplyReferralUseCase applyReferral,
    this.onConnectionFailure,
  })  : _getReferral = getReferral,
        _applyReferral = applyReferral,
        super(const ReferralInitial());

  Future<void> loadReferral() async {
    emit(const ReferralLoading());
    final result = await _getReferral();
    result.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(ReferralError(failure.message));
      },
      (data) => emit(ReferralLoaded(code: data.code, history: data.history)),
    );
  }

  Future<void> applyReferral(String code) async {
    final current = state;
    if (current is ReferralLoaded) {
      emit(current.copyWith(isApplying: true));
    }
    final result = await _applyReferral(code);
    result.fold(
      (failure) => emit(ReferralApplyError(failure.message)),
      (_) {
        emit(const ReferralApplySuccess());
        loadReferral();
      },
    );
  }
}
