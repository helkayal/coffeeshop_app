import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

sealed class MenuState {
  const MenuState();
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final List<Product> products;
  final List<Category> categories;
  final String? selectedCategoryId;

  const MenuLoaded({
    required this.products,
    required this.categories,
    this.selectedCategoryId,
  });
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);
}
