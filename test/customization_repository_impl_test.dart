import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/core/services/local_storage_service.dart';
import 'package:coffeeshop_app/features/customization/data/repositories/customization_repository_impl.dart';
import 'package:coffeeshop_app/features/customization/domain/entities/saved_customization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomizationRepositoryImpl.get', () {
    test('returns null when nothing is stored for the product', () async {
      final storage = _FakeLocalStorageService();
      final repository = CustomizationRepositoryImpl(storage);

      final result = await repository.get('coffee');

      expect((result as Success<SavedCustomization?>).data, isNull);
      expect(storage.gets, ['coffee']);
    });

    test('maps stored selections back to a saved customization', () async {
      final repository = CustomizationRepositoryImpl(
        _FakeLocalStorageService(
          stored: {
            'picked': {'milk': 'oat'},
            'toggled': {
              'extras': ['shot'],
            },
          },
        ),
      );

      final result = await repository.get('coffee');

      final customization = (result as Success<SavedCustomization?>).data!;
      expect(customization.pickedOptionIds, {'milk': 'oat'});
      expect(customization.toggledOptionIds, {
        'extras': ['shot'],
      });
    });

    test('maps a storage error to the load failure key', () async {
      final repository = CustomizationRepositoryImpl(
        _FakeLocalStorageService()..throwOnRead = true,
      );

      final result = await repository.get('coffee');

      expect(
        (result as Error<SavedCustomization?>).failure,
        isA<CacheFailure>().having((f) => f.message, 'message', 'errors.customization_load_failed'),
      );
    });
  });

  group('CustomizationRepositoryImpl.save', () {
    test('persists the customization for the product', () async {
      final storage = _FakeLocalStorageService();
      final repository = CustomizationRepositoryImpl(storage);

      final result = await repository.save(
        'coffee',
        const SavedCustomization(
          pickedOptionIds: {'milk': 'oat'},
          toggledOptionIds: {
            'extras': ['shot'],
          },
        ),
      );

      expect(result, isA<Success<void>>());
      expect(storage.savedProductIds, ['coffee']);
      expect(storage.savedPayload, {
        'picked': {'milk': 'oat'},
        'toggled': {
          'extras': ['shot'],
        },
      });
    });

    test('maps a storage error to the save failure key', () async {
      final repository = CustomizationRepositoryImpl(
        _FakeLocalStorageService()..throwOnWrite = true,
      );

      final result = await repository.save(
        'coffee',
        const SavedCustomization(),
      );

      expect(
        (result as Error<void>).failure,
        isA<CacheFailure>().having((f) => f.message, 'message', 'errors.customization_save_failed'),
      );
    });
  });

  group('CustomizationRepositoryImpl.clear', () {
    test('removes the stored selections for the product', () async {
      final storage = _FakeLocalStorageService();
      final repository = CustomizationRepositoryImpl(storage);

      final result = await repository.clear('coffee');

      expect(result, isA<Success<void>>());
      expect(storage.clearedProductIds, ['coffee']);
    });

    test('maps a storage error to the clear failure key', () async {
      final repository = CustomizationRepositoryImpl(
        _FakeLocalStorageService()..throwOnWrite = true,
      );

      final result = await repository.clear('coffee');

      expect(
        (result as Error<void>).failure,
        isA<CacheFailure>().having((f) => f.message, 'message', 'errors.customization_clear_failed'),
      );
    });
  });
}

class _FakeLocalStorageService implements LocalStorageService {
  _FakeLocalStorageService({this.stored});

  final Map<String, dynamic>? stored;
  bool throwOnRead = false;
  bool throwOnWrite = false;
  final gets = <String>[];
  final savedProductIds = <String>[];
  final clearedProductIds = <String>[];
  Map<String, dynamic>? savedPayload;

  @override
  Map<String, dynamic>? getFavoriteSelections(String productId) {
    if (throwOnRead) throw StateError('storage down');
    gets.add(productId);
    return stored;
  }

  @override
  Future<void> saveFavoriteSelections(
    String productId,
    Map<String, dynamic> selections,
  ) async {
    if (throwOnWrite) throw StateError('storage down');
    savedProductIds.add(productId);
    savedPayload = selections;
  }

  @override
  Future<void> clearFavoriteSelections(String productId) async {
    if (throwOnWrite) throw StateError('storage down');
    clearedProductIds.add(productId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
