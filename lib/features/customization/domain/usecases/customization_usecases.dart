import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../checkout/domain/entities/cart_item.dart';
import '../../../menu/domain/entities/option_value.dart';
import '../../../menu/domain/entities/product.dart';
import '../entities/saved_customization.dart';
import '../repositories/customization_repository.dart';

class GetSavedCustomizationUseCase {
  final CustomizationRepository _repository;

  const GetSavedCustomizationUseCase(this._repository);

  Future<Result<SavedCustomization?>> call(String productId) =>
      _repository.get(productId);
}

class SaveCustomizationUseCase {
  final CustomizationRepository _repository;

  const SaveCustomizationUseCase(this._repository);

  Future<Result<void>> call(
    String productId,
    SavedCustomization customization,
  ) => _repository.save(productId, customization);
}

class ClearCustomizationUseCase {
  final CustomizationRepository _repository;

  const ClearCustomizationUseCase(this._repository);

  Future<Result<void>> call(String productId) => _repository.clear(productId);
}

class BuildSavedCartItemUseCase {
  final CustomizationRepository _repository;
  final int Function() _idSeed;

  BuildSavedCartItemUseCase(this._repository, {int Function()? idSeed})
    : _idSeed = idSeed ?? (() => DateTime.now().millisecondsSinceEpoch);

  Future<Result<CartItem>> call(Product product) async {
    final result = await _repository.get(product.id);
    if (result case Error<SavedCustomization?>(:final failure)) {
      return Error(failure);
    }
    final saved = (result as Success<SavedCustomization?>).data;
    final names = <String>[];
    final ids = <String>[];
    var upcharge = 0.0;

    for (final group in product.optionGroups) {
      final isMulti =
          group.name.toLowerCase().contains('extra') ||
          group.name.toLowerCase().contains('add-on');
      final options = <OptionValue>[];
      if (isMulti) {
        final selectedIds = saved?.toggledOptionIds[group.id] ?? const [];
        options.addAll(
          group.values.where((option) => selectedIds.contains(option.id)),
        );
      } else {
        final selectedId = saved?.pickedOptionIds[group.id];
        final selected = group.values
            .where((option) => option.id == selectedId)
            .firstOrNull;
        if (selected != null) {
          options.add(selected);
        } else if (group.values.isNotEmpty) {
          options.add(group.values.first);
        }
      }
      for (final option in options) {
        names.add(option.name);
        ids.add(option.id);
        upcharge += option.priceModifier;
      }
    }

    if (product.id.isEmpty) {
      return const Error(CacheFailure('invalid_product'));
    }
    return Success(
      CartItem(
        id: '${product.id}_${_idSeed()}',
        productId: product.id,
        name: product.name,
        imagePath: product.imagePath ?? '',
        variant: names.join(' • '),
        unitPrice: product.basePrice + upcharge,
        quantity: 1,
        modifierIds: ids,
      ),
    );
  }
}
