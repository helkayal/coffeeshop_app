import '../constants/api_constants.dart';
import 'api_service.dart';

class LocationService {
  final ApiService _api;
  List<String>? _cachedStates;
  final Map<String, List<String>> _cityCache = {};

  LocationService(this._api);

  Future<List<String>> getStates() async {
    if (_cachedStates != null) return _cachedStates!;
    final data = await _api.get(ApiConstants.locationsStates);
    _cachedStates = (data as List<dynamic>)
        .map((s) => (s as Map<String, dynamic>)['name'] as String)
        .toList();
    return _cachedStates!;
  }

  Future<List<String>> getCities(String state) async {
    if (_cityCache.containsKey(state)) return _cityCache[state]!;
    final data = await _api.get(
      ApiConstants.locationsCities,
      queryParameters: {'state': state},
    );
    final cities = (data as List<dynamic>)
        .map((c) => (c as Map<String, dynamic>)['name'] as String)
        .toList();
    _cityCache[state] = cities;
    return cities;
  }
}
