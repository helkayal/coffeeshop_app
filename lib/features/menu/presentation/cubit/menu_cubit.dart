import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetProducts _getProducts;
  final GetCategories _getCategories;

  MenuCubit({
    required GetProducts getProducts,
    required GetCategories getCategories,
  })  : _getProducts = getProducts,
        _getCategories = getCategories,
        super(const MenuInitial());

  Future<void> loadMenu() async {
    emit(const MenuLoading());

    final productsResult = await _getProducts();
    final categoriesResult = await _getCategories();

    final hasError = productsResult
        .fold((_) => true, (_) => false) ||
        categoriesResult.fold((_) => true, (_) => false);

    if (hasError) {
      final message = productsResult.fold(
        (f) => f.message,
        (_) => '',
      );
      emit(MenuError(message.isNotEmpty ? message : 'Failed to load menu'));
      return;
    }

    productsResult.fold(
      (_) => null,
      (products) => categoriesResult.fold(
        (_) => null,
        (categories) => emit(MenuLoaded(products: products, categories: categories)),
      ),
    );
  }

  Future<void> selectCategory(String? categoryId) async {
    final current = state;
    if (current is! MenuLoaded) return;

    final categories = current.categories;
    final result = await _getProducts(categoryId: categoryId);

    result.fold(
      (failure) => emit(MenuError(failure.message)),
      (products) => emit(MenuLoaded(
        products: products,
        categories: categories,
        selectedCategoryId: categoryId,
      )),
    );
  }
}
