import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/profile_usecases.dart';
import 'loyalty_history_state.dart';

class LoyaltyHistoryCubit extends Cubit<LoyaltyHistoryState> {
  final GetLoyaltyHistoryUseCase _getHistory;

  LoyaltyHistoryCubit(this._getHistory) : super(const LoyaltyHistoryLoading());

  Future<void> load() async {
    emit(const LoyaltyHistoryLoading());
    final result = await _getHistory();
    result.fold(
      (failure) => emit(LoyaltyHistoryError(failure.message)),
      (entries) => emit(LoyaltyHistoryLoaded(entries)),
    );
  }
}
