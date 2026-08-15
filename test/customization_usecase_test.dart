import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/customization/domain/entities/saved_customization.dart';
import 'package:coffeeshop_app/features/customization/domain/repositories/customization_repository.dart';
import 'package:coffeeshop_app/features/customization/domain/usecases/customization_usecases.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/option_group.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/option_value.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds a priced cart item from saved customization', () async {
    final repository = _FakeCustomizationRepository(
      const SavedCustomization(
        pickedOptionIds: {'milk': 'oat'},
        toggledOptionIds: {
          'extras': ['shot'],
        },
      ),
    );
    final useCase = BuildSavedCartItemUseCase(repository, idSeed: () => 7);

    final result = await useCase(_product());
    final item = (result as Success).data;

    expect(item.id, 'coffee_7');
    expect(item.unitPrice, 57);
    expect(item.modifierIds, ['oat', 'shot']);
  });

  test(
    'uses first single-select option when no customization is saved',
    () async {
      final useCase = BuildSavedCartItemUseCase(
        _FakeCustomizationRepository(null),
        idSeed: () => 1,
      );

      final result = await useCase(_product());
      final item = (result as Success).data;

      expect(item.unitPrice, 50);
      expect(item.modifierIds, ['whole']);
    },
  );
}

Product _product() => const Product(
  id: 'coffee',
  name: 'Coffee',
  description: '',
  basePrice: 50,
  category: 'coffee',
  optionGroups: [
    OptionGroup(
      id: 'milk',
      name: 'Milk',
      values: [
        OptionValue(id: 'whole', name: 'Whole', priceModifier: 0),
        OptionValue(id: 'oat', name: 'Oat', priceModifier: 5),
      ],
    ),
    OptionGroup(
      id: 'extras',
      name: 'Extras',
      values: [OptionValue(id: 'shot', name: 'Shot', priceModifier: 2)],
    ),
  ],
);

class _FakeCustomizationRepository implements CustomizationRepository {
  final SavedCustomization? saved;

  _FakeCustomizationRepository(this.saved);

  @override
  Future<Result<SavedCustomization?>> get(String productId) async =>
      Success(saved);

  @override
  Future<Result<void>> clear(String productId) async => const Success(null);

  @override
  Future<Result<void>> save(
    String productId,
    SavedCustomization customization,
  ) async => const Success(null);
}
