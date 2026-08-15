import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/result.dart';
import '../../domain/usecases/payment_preferences_usecases.dart';
import '../../domain/usecases/wallet_usecases.dart';
import 'payment_preferences_state.dart';

class PaymentPreferencesCubit extends Cubit<PaymentPreferencesState> {
  final GetPaymentPreferencesUseCase _getPreferences;
  final SetDefaultPaymentMethodUseCase _setDefaultMethod;
  final SetWalletPhoneUseCase _setWalletPhone;
  final UpdateWalletPhoneUseCase _updateWalletPhone;

  PaymentPreferencesCubit({
    required GetPaymentPreferencesUseCase getPreferences,
    required SetDefaultPaymentMethodUseCase setDefaultMethod,
    required SetWalletPhoneUseCase setWalletPhone,
    required UpdateWalletPhoneUseCase updateWalletPhone,
  }) : _getPreferences = getPreferences,
       _setDefaultMethod = setDefaultMethod,
       _setWalletPhone = setWalletPhone,
       _updateWalletPhone = updateWalletPhone,
       super(const PaymentPreferencesLoading());

  Future<void> load() async {
    final result = await _getPreferences();
    result.fold(
      (failure) => emit(PaymentPreferencesError(failure.message)),
      (preferences) => emit(PaymentPreferencesLoaded(preferences)),
    );
  }

  Future<void> selectMethod(String method) async {
    final result = await _setDefaultMethod(method);
    result.fold(
      (failure) => emit(PaymentPreferencesError(failure.message)),
      (_) => load(),
    );
  }

  Future<bool> saveWalletPhone(String phone) async {
    final remoteResult = await _updateWalletPhone(phone);
    if (remoteResult case Error<void>(:final failure)) {
      emit(PaymentPreferencesError(failure.message));
      return false;
    }
    final localResult = await _setWalletPhone(phone);
    return localResult.fold(
      (failure) {
        emit(PaymentPreferencesError(failure.message));
        return false;
      },
      (_) {
        load();
        return true;
      },
    );
  }
}
