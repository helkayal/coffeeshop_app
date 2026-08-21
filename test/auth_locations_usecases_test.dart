import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/auth/domain/repositories/locations_repository.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/location_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeLocationsRepository repository;

  setUp(() {
    repository = _FakeLocationsRepository();
  });

  group('GetStatesUseCase', () {
    test('returns the states from the repository', () async {
      repository.statesResult = const Success(['NY', 'CA']);

      final result = await GetStatesUseCase(repository)();

      expect((result as Success<List<String>>).data, ['NY', 'CA']);
    });

    test('propagates a states loading failure', () async {
      repository.statesResult = const Error<List<String>>(
        ServerFailure('errors.locations_load_failed'),
      );

      final result = await GetStatesUseCase(repository)();

      expect(
        (result as Error<List<String>>).failure.message,
        'errors.locations_load_failed',
      );
    });
  });

  group('GetCitiesUseCase', () {
    test('forwards the state and returns its cities', () async {
      repository.citiesResult = const Success(['New York']);

      final result = await GetCitiesUseCase(repository)('NY');

      expect(repository.requestedState, 'NY');
      expect((result as Success<List<String>>).data, ['New York']);
    });

    test('propagates a cities loading failure', () async {
      repository.citiesResult = const Error<List<String>>(
        ServerFailure('errors.locations_load_failed'),
      );

      final result = await GetCitiesUseCase(repository)('NY');

      expect(result, isA<Error<List<String>>>());
    });
  });
}

class _FakeLocationsRepository implements LocationsRepository {
  Result<List<String>>? statesResult;
  Result<List<String>>? citiesResult;
  String? requestedState;

  @override
  Future<Result<List<String>>> getStates() async =>
      statesResult ?? const Success([]);

  @override
  Future<Result<List<String>>> getCities(String state) async {
    requestedState = state;
    return citiesResult ?? const Success([]);
  }
}
