import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/payment_methods_usecases.dart';
import 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final GetPaymentMethodsUseCase _getMethods;
  final AddCardUseCase _addCard;
  final DeleteCardUseCase _deleteCard;
  final void Function(ConnectionFailure)? onConnectionFailure;

  PaymentMethodsCubit({
    required GetPaymentMethodsUseCase getMethods,
    required AddCardUseCase addCard,
    required DeleteCardUseCase deleteCard,
    this.onConnectionFailure,
  }) : _getMethods = getMethods,
       _addCard = addCard,
       _deleteCard = deleteCard,
       super(const PaymentMethodsInitial());

  Future<void> loadPaymentMethods() async {
    emit(const PaymentMethodsLoading());
    final result = await _getMethods();
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(PaymentMethodsError(failure.message));
    }, (cards) => emit(PaymentMethodsLoaded(cards)));
  }

  Future<void> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  }) async {
    final current = state;
    final cards = current is PaymentMethodsLoaded
        ? current.cards
        : <PaymentMethod>[];
    emit(PaymentMethodsActionInProgress(cards));
    final result = await _addCard(
      number: number,
      expiry: expiry,
      cvv: cvv,
      name: name,
    );
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(PaymentMethodsError(failure.message));
    }, (_) => loadPaymentMethods());
  }

  Future<void> deleteCard(String cardId) async {
    final current = state;
    if (current is PaymentMethodsLoaded) {
      emit(PaymentMethodsActionInProgress(current.cards));
    }
    final result = await _deleteCard(cardId);
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(PaymentMethodsError(failure.message));
    }, (_) => loadPaymentMethods());
  }

  List<PaymentMethod> get currentCards {
    final s = state;
    if (s is PaymentMethodsLoaded) return s.cards;
    if (s is PaymentMethodsActionInProgress) return s.cards;
    return [];
  }
}
