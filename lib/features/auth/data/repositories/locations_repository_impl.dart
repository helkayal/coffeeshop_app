import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/repositories/locations_repository.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationService _service;

  const LocationsRepositoryImpl(this._service);

  @override
  Future<Result<List<String>>> getStates() => _map(_service.getStates);

  @override
  Future<Result<List<String>>> getCities(String state) =>
      _map(() => _service.getCities(state));

  Future<Result<List<String>>> _map(
    Future<List<String>> Function() request,
  ) async {
    try {
      return Success(await request());
    } on ConnectionException catch (error) {
      return Error(ConnectionFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message ?? 'locations_load_failed'));
    } catch (_) {
      return const Error(ServerFailure('locations_load_failed'));
    }
  }
}
