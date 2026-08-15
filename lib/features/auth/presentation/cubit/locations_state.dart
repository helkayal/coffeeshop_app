sealed class LocationsState {
  const LocationsState();
}

final class LocationsLoading extends LocationsState {
  final List<String> states;
  final List<String> cities;

  const LocationsLoading({this.states = const [], this.cities = const []});
}

final class LocationsLoaded extends LocationsState {
  final List<String> states;
  final List<String> cities;

  const LocationsLoaded({required this.states, this.cities = const []});
}

final class LocationsError extends LocationsState {
  final String failureCode;

  const LocationsError(this.failureCode);
}
