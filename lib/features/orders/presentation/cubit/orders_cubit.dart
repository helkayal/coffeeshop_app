import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/orders_usecases.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase _getOrders;

  OrdersCubit(this._getOrders) : super(const OrdersInitial());

  Future<void> loadOrders() async {
    emit(const OrdersLoading());
    final result = await _getOrders();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }
}
