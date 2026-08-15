import '../../../../core/helpers/result.dart';
import '../entities/saved_customization.dart';

abstract interface class CustomizationRepository {
  Future<Result<SavedCustomization?>> get(String productId);

  Future<Result<void>> save(String productId, SavedCustomization customization);

  Future<Result<void>> clear(String productId);
}
