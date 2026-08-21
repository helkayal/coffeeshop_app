import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/category.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/product.dart';
import 'package:coffeeshop_app/features/menu/domain/repositories/category_repository.dart';
import 'package:coffeeshop_app/features/menu/domain/repositories/product_repository.dart';
import 'package:coffeeshop_app/features/menu/domain/usecases/get_categories.dart';
import 'package:coffeeshop_app/features/menu/domain/usecases/get_menu.dart';
import 'package:coffeeshop_app/features/menu/domain/usecases/get_product_by_id.dart';
import 'package:coffeeshop_app/features/menu/domain/usecases/get_products.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetCategories', () {
    test('returns categories from the repository', () async {
      final useCase = GetCategories(
        _FakeCategoryRepository(
          result: const Success([
            Category(id: 'coffee', name: 'Coffee'),
            Category(id: 'desserts', name: 'Desserts'),
          ]),
        ),
      );

      final result = await useCase();

      final categories = (result as Success<List<Category>>).data;
      expect(categories, hasLength(2));
      expect(categories.first.id, 'coffee');
      expect(categories.first.name, 'Coffee');
    });

    test('propagates a repository failure', () async {
      final useCase = GetCategories(
        _FakeCategoryRepository(
          result: const Error(ServerFailure('errors.categories_load_failed')),
        ),
      );

      final result = await useCase();

      expect(
        (result as Error<List<Category>>).failure.message,
        'errors.categories_load_failed',
      );
    });
  });

  group('GetMenu', () {
    test('returns categories and products from the repository', () async {
      final useCase = GetMenu(
        _FakeProductRepository(
          menuResult: const Success((
            categories: [Category(id: 'coffee', name: 'Coffee')],
            products: [_latte],
          )),
        ),
      );

      final result = await useCase();

      final menu = (result as Success<MenuData>).data;
      expect(menu.categories.single.id, 'coffee');
      expect(menu.products.single.id, 'latte');
    });

    test('propagates a repository failure', () async {
      final useCase = GetMenu(
        _FakeProductRepository(
          menuResult: const Error(ServerFailure('errors.menu_load_failed')),
        ),
      );

      final result = await useCase();

      expect(
        (result as Error<MenuData>).failure.message,
        'errors.menu_load_failed',
      );
    });
  });

  group('GetProducts', () {
    test('forwards the category filter to the repository', () async {
      final repository = _FakeProductRepository(
        productsResult: const Success([_latte]),
      );
      final useCase = GetProducts(repository);

      final result = await useCase(categoryId: 'hot');

      expect(repository.lastCategoryId, 'hot');
      expect((result as Success<List<Product>>).data.single.id, 'latte');
    });

    test('fetches all products when no category filter is given', () async {
      final repository = _FakeProductRepository(
        productsResult: const Success([_latte]),
      );
      final useCase = GetProducts(repository);

      final result = await useCase();

      expect(repository.lastCategoryId, isNull);
      expect(result, isA<Success<List<Product>>>());
    });

    test('propagates a repository failure', () async {
      final useCase = GetProducts(
        _FakeProductRepository(
          productsResult: const Error(ServerFailure('errors.products_load_failed')),
        ),
      );

      final result = await useCase();

      expect(
        (result as Error<List<Product>>).failure.message,
        'errors.products_load_failed',
      );
    });
  });

  group('GetProductByIdUseCase', () {
    test('returns the product for the requested id', () async {
      final repository = _FakeProductRepository(
        productResult: const Success(_latte),
      );
      final useCase = GetProductByIdUseCase(repository);

      final result = await useCase('latte');

      expect(repository.lastProductId, 'latte');
      expect((result as Success<Product>).data.name, 'Latte');
    });

    test('propagates a repository failure', () async {
      final useCase = GetProductByIdUseCase(
        _FakeProductRepository(
          productResult: const Error(ServerFailure('errors.product_not_found')),
        ),
      );

      final result = await useCase('latte');

      expect(
        (result as Error<Product>).failure.message,
        'errors.product_not_found',
      );
    });
  });
}

const _latte = Product(
  id: 'latte',
  name: 'Latte',
  description: '',
  basePrice: 4.5,
  category: 'coffee',
);

class _FakeCategoryRepository implements CategoryRepository {
  _FakeCategoryRepository({this.result = const Success(<Category>[])});

  final Result<List<Category>> result;

  @override
  Future<Result<List<Category>>> getCategories() async => result;
}

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository({
    this.productsResult = const Success(<Product>[]),
    this.productResult,
    this.menuResult,
  });

  final Result<List<Product>> productsResult;
  final Result<Product>? productResult;
  final Result<MenuData>? menuResult;
  String? lastCategoryId;
  String? lastProductId;

  @override
  Future<Result<List<Product>>> getProducts({String? categoryId}) async {
    lastCategoryId = categoryId;
    return productsResult;
  }

  @override
  Future<Result<Product>> getProductById(String id) async {
    lastProductId = id;
    return productResult ?? const Success(_latte);
  }

  @override
  Future<Result<MenuData>> getMenu() async =>
      menuResult ??
      const Success((categories: <Category>[], products: <Product>[]));
}
