import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/menu/data/datasources/category_remote_data_source.dart';
import 'package:coffeeshop_app/features/menu/data/datasources/product_remote_data_source.dart';
import 'package:coffeeshop_app/features/menu/data/models/category_model.dart';
import 'package:coffeeshop_app/features/menu/data/models/product_model.dart';
import 'package:coffeeshop_app/features/menu/data/repositories/category_repository_impl.dart';
import 'package:coffeeshop_app/features/menu/data/repositories/product_repository_impl.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/category.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/product.dart';
import 'package:coffeeshop_app/features/menu/domain/usecases/get_menu.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryRepositoryImpl', () {
    test('returns categories from the remote data source', () async {
      final repository = CategoryRepositoryImpl(
        _FakeCategoryDataSource(
          models: [
            CategoryModel.fromJson({'id': 'coffee', 'name': 'Coffee'}),
          ],
        ),
      );

      final result = await repository.getCategories();

      final categories = (result as Success<List<Category>>).data;
      expect(categories, hasLength(1));
      expect(categories.first.id, 'coffee');
      expect(categories.first.name, 'Coffee');
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = CategoryRepositoryImpl(
        _FakeCategoryDataSource(error: const ServerException('menu_down')),
      );

      final result = await repository.getCategories();

      final failure = (result as Error<List<Category>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'menu_down');
    });

    test(
      'falls back to the default key when the ServerException has no message',
      () async {
        final repository = CategoryRepositoryImpl(
          _FakeCategoryDataSource(error: const ServerException()),
        );

        final result = await repository.getCategories();

        expect(
          (result as Error<List<Category>>).failure.message,
          'errors.categories_load_failed',
        );
      },
    );

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = CategoryRepositoryImpl(
        _FakeCategoryDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.getCategories();

      final failure = (result as Error<List<Category>>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = CategoryRepositoryImpl(
        _FakeCategoryDataSource(error: Exception('boom')),
      );

      final result = await repository.getCategories();

      final failure = (result as Error<List<Category>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('ProductRepositoryImpl.getProducts', () {
    test('returns products mapped from the data source models', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(
          products: [
            ProductModel.fromJson({
              'id': 'latte',
              'name': 'Latte',
              'description': 'Double shot',
              'image_url': 'assets/latte.png',
              'base_price': '4.50',
              '_category_id': 'hot-drinks',
              'is_favorited': true,
              'modifiers': [
                {
                  'modifier_group': 'Milk',
                  'option_name': 'Oat',
                  'upcharge_price': '0.50',
                },
              ],
            }),
          ],
        ),
      );

      final result = await repository.getProducts(categoryId: 'hot');

      final products = (result as Success<List<Product>>).data;
      expect(products, hasLength(1));
      final product = products.first;
      expect(product.id, 'latte');
      expect(product.name, 'Latte');
      expect(product.description, 'Double shot');
      expect(product.imagePath, 'assets/latte.png');
      expect(product.basePrice, 4.5);
      expect(product.category, 'hot-drinks');
      expect(product.isFavorited, isTrue);
      expect(product.optionGroups.single.values.single.priceModifier, 0.5);
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ServerException('products_down')),
      );

      final result = await repository.getProducts();

      final failure = (result as Error<List<Product>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'products_down');
    });

    test('falls back to the default key when the ServerException has no message',
        () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ServerException()),
      );

      final result = await repository.getProducts();

      expect(
        (result as Error<List<Product>>).failure.message,
        'errors.products_load_failed',
      );
    });

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.getProducts();

      final failure = (result as Error<List<Product>>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: Exception('boom')),
      );

      final result = await repository.getProducts();

      final failure = (result as Error<List<Product>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('ProductRepositoryImpl.getProductById', () {
    test('returns the product for the requested id', () async {
      final dataSource = _FakeProductDataSource(
        product: ProductModel.fromJson({
          'id': 'latte',
          'name': 'Latte',
          'base_price': '4.50',
          'category': 'coffee',
        }),
      );
      final repository = ProductRepositoryImpl(dataSource);

      final result = await repository.getProductById('latte');

      expect(dataSource.requestedProductId, 'latte');
      final product = (result as Success<Product>).data;
      expect(product.id, 'latte');
      expect(product.basePrice, 4.5);
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ServerException('missing')),
      );

      final result = await repository.getProductById('latte');

      final failure = (result as Error<Product>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'missing');
    });

    test('falls back to the default key when the ServerException has no message',
        () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ServerException()),
      );

      final result = await repository.getProductById('latte');

      expect(
        (result as Error<Product>).failure.message,
        'errors.product_not_found',
      );
    });

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.getProductById('latte');

      final failure = (result as Error<Product>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: Exception('boom')),
      );

      final result = await repository.getProductById('latte');

      final failure = (result as Error<Product>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('ProductRepositoryImpl.getMenu', () {
    test('returns both categories and products from the data source', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(
          menu: (
            categories: [
              CategoryModel.fromJson({'id': 'coffee', 'name': 'Coffee'}),
            ],
            products: [
              ProductModel.fromJson({
                'id': 'latte',
                'name': 'Latte',
                'base_price': '4.50',
                'category': 'coffee',
              }),
            ],
          ),
        ),
      );

      final result = await repository.getMenu();

      final menu = (result as Success<MenuData>).data;
      expect(menu.categories.single.name, 'Coffee');
      expect(menu.products.single.basePrice, 4.5);
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ServerException('menu_down')),
      );

      final result = await repository.getMenu();

      final failure = (result as Error<MenuData>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'menu_down');
    });

    test('falls back to the default key when the ServerException has no message',
        () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ServerException()),
      );

      final result = await repository.getMenu();

      expect(
        (result as Error<MenuData>).failure.message,
        'errors.menu_load_failed',
      );
    });

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.getMenu();

      final failure = (result as Error<MenuData>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductDataSource(error: Exception('boom')),
      );

      final result = await repository.getMenu();

      final failure = (result as Error<MenuData>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('ProductModel.fromJson', () {
    test('parses base_price strings into a double', () {
      final model = ProductModel.fromJson({
        'id': 'latte',
        'name': 'Latte',
        'base_price': '4.50',
      });

      expect(model.basePrice, 4.5);
      expect(model.description, '');
      expect(model.isFavorited, isFalse);
    });

    test('reads the category id from _category_id', () {
      final model = ProductModel.fromJson({
        'id': 'latte',
        'name': 'Latte',
        '_category_id': 'hot-drinks',
        'is_favorited': true,
      });

      expect(model.category, 'hot-drinks');
      expect(model.isFavorited, isTrue);
    });

    test('groups flat modifiers into option groups', () {
      final model = ProductModel.fromJson({
        'id': 'latte',
        'name': 'Latte',
        'base_price': 4.5,
        'modifiers': [
          {
            'modifier_group': 'Milk',
            'option_name': 'Oat',
            'upcharge_price': '0.50',
          },
          {
            'modifier_group': 'Milk',
            'option_name': 'Whole',
            'upcharge_price': 0,
          },
          {
            'id': 'extra-shot',
            'modifier_group': 'Extras',
            'option_name': 'Extra Shot',
            'upcharge_price': '1.00',
          },
        ],
      });

      expect(model.optionGroups, hasLength(2));
      final milk = model.optionGroups.first;
      expect(milk.id, 'Milk');
      expect(milk.required, isFalse);
      expect(milk.values, hasLength(2));
      // A modifier without an id falls back to the group name.
      expect(milk.values.first.id, 'Milk');
      expect(milk.values.first.name, 'Oat');
      expect(milk.values.first.priceModifier, 0.5);
      expect(model.optionGroups.last.values.single.id, 'extra-shot');
      expect(model.optionGroups.last.values.single.priceModifier, 1.0);
    });
  });
}

class _FakeCategoryDataSource implements CategoryRemoteDataSource {
  _FakeCategoryDataSource({this.models = const [], this.error});

  final List<CategoryModel> models;
  final Exception? error;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final e = error;
    if (e != null) throw e;
    return models;
  }
}

class _FakeProductDataSource implements ProductRemoteDataSource {
  _FakeProductDataSource({
    this.products = const [],
    this.product,
    this.menu = const (
      categories: <CategoryModel>[],
      products: <ProductModel>[],
    ),
    this.error,
  });

  final List<ProductModel> products;
  final ProductModel? product;
  final ({List<CategoryModel> categories, List<ProductModel> products}) menu;
  final Exception? error;
  String? requestedCategoryId;
  String? requestedProductId;

  @override
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    requestedCategoryId = categoryId;
    final e = error;
    if (e != null) throw e;
    return products;
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    requestedProductId = id;
    final e = error;
    if (e != null) throw e;
    return product!;
  }

  @override
  Future<({List<CategoryModel> categories, List<ProductModel> products})>
  getMenu() async {
    final e = error;
    if (e != null) throw e;
    return menu;
  }
}
