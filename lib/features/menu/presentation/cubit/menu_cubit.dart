import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_menu.dart';
import '../../domain/usecases/get_products.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetMenu _getMenu;
  final GetProducts _getProducts;

  MenuCubit({required GetMenu getMenu, required GetProducts getProducts})
    : _getMenu = getMenu,
      _getProducts = getProducts,
      super(const MenuInitial());

  /// Loads the full menu with a **single** GET /menu request.
  /// Guards against redundant or concurrent calls.
  Future<void> loadMenu() async {
    if (state is MenuLoading || state is MenuLoaded) return;
    emit(const MenuLoading());

    final result = await _getMenu();

    result.fold(
      (failure) => emit(MenuError(failure.message)),
      (menu) => emit(
        MenuLoaded(
          categories: menu.categories,
          products: menu.products,
        ),
      ),
    );
  }

  /// Filters products by category with a targeted GET /menu call.
  Future<void> selectCategory(String? categoryId) async {
    final current = state;
    if (current is! MenuLoaded) return;

    final result = await _getProducts(categoryId: categoryId);

    result.fold(
      (failure) => emit(MenuError(failure.message)),
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
