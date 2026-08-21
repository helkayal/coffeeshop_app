import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/core/security/credential_storage.dart';
import 'package:coffeeshop_app/core/services/api_service.dart';
import 'package:coffeeshop_app/core/services/location_service.dart';
import 'package:coffeeshop_app/features/auth/data/repositories/locations_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeLocationService service;
  late LocationsRepositoryImpl repository;

  setUp(() {
    service = _FakeLocationService();
    repository = LocationsRepositoryImpl(service);
  });

  group('getStates', () {
    test('returns the states loaded from the service', () async {
      service.states = ['NY', 'CA'];

      final result = await repository.getStates();

      expect((result as Success<List<String>>).data, ['NY', 'CA']);
    });

    test('maps a server exception to a ServerFailure with its message',
        () async {
      service.statesError = const ServerException('errors.locations_load_failed');

      final result = await repository.getStates();

      expect(
        (result as Error<List<String>>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.locations_load_failed',
        ),
      );
    });

    test('falls back to locations_load_failed when the server sends no message',
        () async {
      service.statesError = const ServerException();

      final result = await repository.getStates();

      expect(
        (result as Error<List<String>>).failure.message,
        'errors.locations_load_failed',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      service.statesError = const ConnectionException('errors.network_error');

      final result = await repository.getStates();

      expect(
        (result as Error<List<String>>).failure,
        isA<ConnectionFailure>().having(
          (f) => f.message,
          'message',
          'errors.network_error',
        ),
      );
    });

    test('maps unexpected errors to locations_load_failed', () async {
      service.statesError = StateError('boom');

      final result = await repository.getStates();

      expect(
        (result as Error<List<String>>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.locations_load_failed',
        ),
      );
    });
  });

  group('getCities', () {
    test('forwards the state and returns its cities', () async {
      service.cities = ['New York'];

      final result = await repository.getCities('NY');

      expect(service.requestedState, 'NY');
      expect((result as Success<List<String>>).data, ['New York']);
    });

    test('maps a server exception to a ServerFailure', () async {
      service.citiesError = const ServerException('bad_state');

      final result = await repository.getCities('XX');

      expect((result as Error<List<String>>).failure.message, 'bad_state');
    });
  });
}

class _FakeLocationService extends LocationService {
  _FakeLocationService() : super(ApiService(_FakeCredentials()));

  List<String>? states;
  List<String>? cities;
  Object? statesError;
  Object? citiesError;
  String? requestedState;

  @override
  Future<List<String>> getStates() async {
    if (statesError != null) throw statesError!;
    return states ?? const [];
  }

  @override
  Future<List<String>> getCities(String state) async {
    if (citiesError != null) throw citiesError!;
    requestedState = state;
    return cities ?? const [];
  }
}

class _FakeCredentials implements CredentialStorage {
  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> writeAccessToken(String token) async {}

  @override
  Future<void> writeRefreshToken(String token) async {}

  @override
  Future<void> clear() async {}
}
