import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/location_usecases.dart';
import 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  final GetStatesUseCase _getStates;
  final GetCitiesUseCase _getCities;

  LocationsCubit({
    required GetStatesUseCase getStates,
    required GetCitiesUseCase getCities,
  }) : _getStates = getStates,
       _getCities = getCities,
       super(const LocationsLoading());

  Future<void> loadStates() async {
    emit(const LocationsLoading());
    final result = await _getStates();
    result.fold(
      (failure) => emit(LocationsError(failure.message)),
      (states) => emit(LocationsLoaded(states: states)),
    );
  }

  Future<void> loadCities(String state) async {
    final states = switch (this.state) {
      LocationsLoaded(:final states) => states,
      LocationsLoading(:final states) => states,
      _ => const <String>[],
    };
    emit(LocationsLoading(states: states));
    final result = await _getCities(state);
    result.fold(
      (failure) => emit(LocationsError(failure.message)),
      (cities) => emit(LocationsLoaded(states: states, cities: cities)),
    );
  }
}
