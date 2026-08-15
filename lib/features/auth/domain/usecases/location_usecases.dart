import '../../../../core/helpers/result.dart';
import '../repositories/locations_repository.dart';

class GetStatesUseCase {
  final LocationsRepository _repository;

  const GetStatesUseCase(this._repository);

  Future<Result<List<String>>> call() => _repository.getStates();
}

class GetCitiesUseCase {
  final LocationsRepository _repository;

  const GetCitiesUseCase(this._repository);

  Future<Result<List<String>>> call(String state) =>
      _repository.getCities(state);
}
