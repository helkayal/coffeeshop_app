import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/result.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/purchase_method_decision.dart';
import '../../domain/usecases/decide_purchase_method.dart';
import '../../domain/usecases/payment_preferences_usecases.dart';
import '../../domain/usecases/wallet_usecases.dart';
import 'payment_preferences_state.dart';

class PaymentPreferencesCubit extends Cubit<PaymentPreferencesState> {
  final GetPaymentPreferencesUseCase _getPreferences;
  final SetDefaultPaymentMethodUseCase _setDefaultMethod;
  final SetWalletPhoneUseCase _setWalletPhone;
  final UpdateWalletPhoneUseCase _updateWalletPhone;
  final DecidePurchaseMethodUseCase _decidePurchaseMethod;

  PaymentPreferencesCubit({
    required GetPaymentPreferencesUseCase getPreferences,
    required SetDefaultPaymentMethodUseCase setDefaultMethod,
    required SetWalletPhoneUseCase setWalletPhone,
    required UpdateWalletPhoneUseCase updateWalletPhone,
    required DecidePurchaseMethodUseCase decidePurchaseMethod,
  }) : _getPreferences = getPreferences,
       _setDefaultMethod = setDefaultMethod,
       _setWalletPhone = setWalletPhone,
       _updateWalletPhone = updateWalletPhone,
       _decidePurchaseMethod = decidePurchaseMethod,
       super(const PaymentPreferencesLoading());

  /// Decides the payment path for a purchase from the loaded preferences
  /// and the given cards.
  PurchaseMethodDecision decidePurchaseMethod({
    required List<PaymentMethod> cards,
  }) {
    final preferences = state is PaymentPreferencesLoaded
        ? (state as PaymentPreferencesLoaded).preferences
        : null;
    return _decidePurchaseMethod(preferences: preferences, cards: cards);
  }

  Future<void> load() async {
    final result = await _getPreferences();
    if (isClosed) return;
    result.fold(
      (failure) => emit(PaymentPreferencesError(failure.message)),
      (preferences) => emit(PaymentPreferencesLoaded(preferences)),
    );
  }

  Future<void> selectMethod(String method) async {
    final result = await _setDefaultMethod(method);
    if (isClosed) return;
    result.fold(
      (failure) => emit(PaymentPreferencesError(failure.message)),
      (_) => load(),
    );
  }

  Future<bool> saveWalletPhone(String phone) async {
    final remoteResult = await _updateWalletPhone(phone);
    if (isClosed) return false;
    if (remoteResult case Error<void>(:final failure)) {
      emit(PaymentPreferencesError(failure.message));
      return false;
    }
    final localResult = await _setWalletPhone(phone);
    if (isClosed) return false;
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
