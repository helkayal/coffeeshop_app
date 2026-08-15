import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/orders_usecases.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase _getOrders;
  final void Function(ConnectionFailure)? onConnectionFailure;

  OrdersCubit(this._getOrders, {this.onConnectionFailure})
    : super(const OrdersInitial());

  Future<void> loadOrders() async {
    emit(const OrdersLoading());
    final result = await _getOrders();
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(OrdersError(failure.message));
    }, (orders) => emit(OrdersLoaded(orders)));
  }
}
