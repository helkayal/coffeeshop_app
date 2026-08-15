import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_menu.dart';
import '../../domain/usecases/get_products.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetMenu _getMenu;
  final GetProducts _getProducts;
  final void Function(ConnectionFailure)? onConnectionFailure;

  MenuCubit({
    required GetMenu getMenu,
    required GetProducts getProducts,
    this.onConnectionFailure,
  }) : _getMenu = getMenu,
       _getProducts = getProducts,
       super(const MenuInitial());

  Future<void> loadMenu() async {
    if (state is MenuLoading || state is MenuLoaded) return;
    emit(const MenuLoading());

    final result = await _getMenu();

    result.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(MenuError(failure.message));
      },
      (menu) => emit(
        MenuLoaded(categories: menu.categories, products: menu.products),
      ),
    );
  }

  Future<void> reload() async {
    emit(const MenuInitial());
    await loadMenu();
  }

  Future<void> selectCategory(String? categoryId) async {
    final current = state;
    if (current is! MenuLoaded) return;

    final result = await _getProducts(categoryId: categoryId);

    result.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(MenuError(failure.message));
      },
      (products) => emit(
        MenuLoaded(
          products: products,
          categories: current.categories,
          selectedCategoryId: categoryId,
        ),
      ),
    );
  }
}
