import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/favorites/data/datasources/favorites_data_source.dart';
import 'package:coffeeshop_app/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoritesRepositoryImpl.getFavorites', () {
    test('returns favorite products from the data source', () async {
      final dataSource = _FakeFavoritesDataSource(favorites: [_latte]);
      final repository = FavoritesRepositoryImpl(dataSource);

      final result = await repository.getFavorites();

      final favorites = (result as Success<List<Product>>).data;
      expect(favorites.single.id, 'latte');
      expect(favorites.single.name, 'Latte');
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ServerException('favorites_down')),
      );

      final result = await repository.getFavorites();

      final failure = (result as Error<List<Product>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'favorites_down');
    });

    test(
      'falls back to the default key when the ServerException has no message',
      () async {
        final repository = FavoritesRepositoryImpl(
          _FakeFavoritesDataSource(error: const ServerException()),
        );

        final result = await repository.getFavorites();

        expect(
          (result as Error<List<Product>>).failure.message,
          'errors.favorites_load_failed',
        );
      },
    );

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.getFavorites();

      final failure = (result as Error<List<Product>>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: Exception('boom')),
      );

      final result = await repository.getFavorites();

      final failure = (result as Error<List<Product>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('FavoritesRepositoryImpl.isFavorite', () {
    test('returns the favorite state from the data source', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(isFavoriteValue: true),
      );

      final result = await repository.isFavorite('latte');

      expect((result as Success<bool>).data, isTrue);
    });

    test('maps a ServerException to a ServerFailure', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ServerException('check_down')),
      );

      final result = await repository.isFavorite('latte');

      final failure = (result as Error<bool>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'check_down');
    });

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.isFavorite('latte');

      final failure = (result as Error<bool>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: Exception('boom')),
      );

      final result = await repository.isFavorite('latte');

      final failure = (result as Error<bool>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('FavoritesRepositoryImpl.addFavorite', () {
    test('adds the product and succeeds', () async {
      final dataSource = _FakeFavoritesDataSource();
      final repository = FavoritesRepositoryImpl(dataSource);

      final result = await repository.addFavorite('latte');

      expect(dataSource.added, ['latte']);
      expect(result, isA<Success<void>>());
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ServerException('add_down')),
      );

      final result = await repository.addFavorite('latte');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'add_down');
    });

    test('falls back to the default key when the ServerException has no message',
        () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ServerException()),
      );

      final result = await repository.addFavorite('latte');

      expect(
        (result as Error<void>).failure.message,
        'errors.favorites_add_failed',
      );
    });

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.addFavorite('latte');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: Exception('boom')),
      );

      final result = await repository.addFavorite('latte');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('FavoritesRepositoryImpl.removeFavorite', () {
    test('removes the product and succeeds', () async {
      final dataSource = _FakeFavoritesDataSource();
      final repository = FavoritesRepositoryImpl(dataSource);

      final result = await repository.removeFavorite('latte');

      expect(dataSource.removed, ['latte']);
      expect(result, isA<Success<void>>());
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ServerException('remove_down')),
      );

      final result = await repository.removeFavorite('latte');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'remove_down');
    });

    test(
      'falls back to the default key when the ServerException has no message',
      () async {
        final repository = FavoritesRepositoryImpl(
          _FakeFavoritesDataSource(error: const ServerException()),
        );

        final result = await repository.removeFavorite('latte');

        expect(
          (result as Error<void>).failure.message,
          'errors.favorites_remove_failed',
        );
      },
    );

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.removeFavorite('latte');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = FavoritesRepositoryImpl(
        _FakeFavoritesDataSource(error: Exception('boom')),
      );

      final result = await repository.removeFavorite('latte');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
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

class _FakeFavoritesDataSource implements FavoritesDataSource {
  _FakeFavoritesDataSource({
    this.favorites = const [],
    this.isFavoriteValue = true,
    this.error,
  });

  final List<Product> favorites;
  final bool isFavoriteValue;
  final Exception? error;
  final added = <String>[];
  final removed = <String>[];

  @override
  Future<List<Product>> getFavorites() async {
    final e = error;
    if (e != null) throw e;
    return favorites;
  }

  @override
  Future<bool> isFavorite(String productId) async {
    final e = error;
    if (e != null) throw e;
    return isFavoriteValue;
  }

  @override
  Future<void> addFavorite(String productId) async {
    final e = error;
    if (e != null) throw e;
    added.add(productId);
  }

  @override
  Future<void> removeFavorite(String productId) async {
    final e = error;
    if (e != null) throw e;
    removed.add(productId);
  }
}
