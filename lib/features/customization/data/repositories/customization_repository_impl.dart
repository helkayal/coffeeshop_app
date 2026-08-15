import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/saved_customization.dart';
import '../../domain/repositories/customization_repository.dart';
import '../models/saved_customization_model.dart';

class CustomizationRepositoryImpl implements CustomizationRepository {
  final LocalStorageService _storage;

  const CustomizationRepositoryImpl(this._storage);

  @override
  Future<Result<SavedCustomization?>> get(String productId) async {
    try {
      final data = _storage.getFavoriteSelections(productId);
      return Success(
        data == null ? null : SavedCustomizationModel.fromStorage(data),
      );
    } catch (_) {
      return const Error(CacheFailure('customization_load_failed'));
    }
  }

  @override
  Future<Result<void>> save(
    String productId,
    SavedCustomization customization,
  ) async {
    try {
      final model = SavedCustomizationModel.fromEntity(customization);
      await _storage.saveFavoriteSelections(productId, model.toStorage());
      return const Success(null);
    } catch (_) {
      return const Error(CacheFailure('customization_save_failed'));
    }
  }

  @override
  Future<Result<void>> clear(String productId) async {
    try {
      await _storage.clearFavoriteSelections(productId);
      return const Success(null);
    } catch (_) {
      return const Error(CacheFailure('customization_clear_failed'));
    }
  }
}
