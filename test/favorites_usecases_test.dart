import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:coffeeshop_app/features/favorites/domain/usecases/favorites_usecases.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetFavoritesUseCase', () {
    test('returns the favorite products from the repository', () async {
      final useCase = GetFavoritesUseCase(
        _FakeFavoritesRepository(favoritesResult: const Success([_latte])),
      );

      final result = await useCase();

      expect((result as Success<List<Product>>).data.single.id, 'latte');
    });

    test('propagates a repository failure', () async {
      final useCase = GetFavoritesUseCase(
        _FakeFavoritesRepository(
          favoritesResult: const Error(ServerFailure('errors.favorites_load_failed')),
        ),
      );

      final result = await useCase();

      expect(
        (result as Error<List<Product>>).failure.message,
        'errors.favorites_load_failed',
      );
    });
  });

  group('ToggleFavoriteUseCase', () {
    test('adds the product when it is not favorited', () async {
      final repository = _FakeFavoritesRepository(
        isFavoriteResult: const Success(false),
      );
      final useCase = ToggleFavoriteUseCase(repository);

      final result = await useCase('latte');

      expect((result as Success<bool>).data, isTrue);
      expect(repository.checked, ['latte']);
      expect(repository.added, ['latte']);
      expect(repository.removed, isEmpty);
    });

    test('removes the product when it is already favorited', () async {
      final repository = _FakeFavoritesRepository(
        isFavoriteResult: const Success(true),
      );
      final useCase = ToggleFavoriteUseCase(repository);

      final result = await useCase('latte');

      expect((result as Success<bool>).data, isFalse);
      expect(repository.checked, ['latte']);
      expect(repository.removed, ['latte']);
      expect(repository.added, isEmpty);
    });

    test('propagates a favorite check failure without mutating', () async {
      final repository = _FakeFavoritesRepository(
        isFavoriteResult: const Error(ServerFailure('check_failed')),
      );
      final useCase = ToggleFavoriteUseCase(repository);

      final result = await useCase('latte');

      expect((result as Error<bool>).failure.message, 'check_failed');
      expect(repository.added, isEmpty);
      expect(repository.removed, isEmpty);
    });

    test('propagates an add failure without removing', () async {
      final repository = _FakeFavoritesRepository(
        isFavoriteResult: const Success(false),
        addResult: const Error(ServerFailure('add_failed')),
      );
      final useCase = ToggleFavoriteUseCase(repository);

      final result = await useCase('latte');

      expect((result as Error<bool>).failure.message, 'add_failed');
      expect(repository.removed, isEmpty);
    });

    test('propagates a remove failure without adding', () async {
      final repository = _FakeFavoritesRepository(
        isFavoriteResult: const Success(true),
        removeResult: const Error(ServerFailure('remove_failed')),
      );
      final useCase = ToggleFavoriteUseCase(repository);

      final result = await useCase('latte');

      expect((result as Error<bool>).failure.message, 'remove_failed');
      expect(repository.added, isEmpty);
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

class _FakeFavoritesRepository implements FavoritesRepository {
  _FakeFavoritesRepository({
    this.favoritesResult = const Success(<Product>[]),
    this.isFavoriteResult,
    this.addResult,
    this.removeResult,
  });

  final Result<List<Product>> favoritesResult;
  final Result<bool>? isFavoriteResult;
  final Result<void>? addResult;
  final Result<void>? removeResult;
  final checked = <String>[];
  final added = <String>[];
  final removed = <String>[];

  @override
  Future<Result<List<Product>>> getFavorites() async => favoritesResult;

  @override
  Future<Result<bool>> isFavorite(String productId) async {
    checked.add(productId);
    return isFavoriteResult ?? const Success(false);
  }

  @override
  Future<Result<void>> addFavorite(String productId) async {
    added.add(productId);
    return addResult ?? const Success(null);
  }

  @override
  Future<Result<void>> removeFavorite(String productId) async {
    removed.add(productId);
    return removeResult ?? const Success(null);
  }
}
