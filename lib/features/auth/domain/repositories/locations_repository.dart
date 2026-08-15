import '../../../../core/helpers/result.dart';

abstract interface class LocationsRepository {
  Future<Result<List<String>>> getStates();

  Future<Result<List<String>>> getCities(String state);
}
