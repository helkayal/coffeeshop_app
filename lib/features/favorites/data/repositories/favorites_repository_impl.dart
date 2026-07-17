import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../menu/domain/entities/product.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesDataSource _dataSource;

  FavoritesRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Product>>> getFavorites() async {
    try {
      return Success(await _dataSource.getFavorites());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load favorites'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<bool>> isFavorite(String productId) async {
    try {
      return Success(await _dataSource.isFavorite(productId));
    } catch (_) {
      return const Success(false);
    }
  }

  @override
  Future<Result<void>> addFavorite(String productId) async {
    try {
      await _dataSource.addFavorite(productId);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to add favorite'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<void>> removeFavorite(String productId) async {
    try {
      await _dataSource.removeFavorite(productId);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to remove favorite'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }
}
