import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;
  final ApiService _api;
  final LocalStorageService _storage;

  SettingsRepositoryImpl(this._local, this._api, this._storage);

  @override
  Future<Result<AppSettings>> getSettings() async {
    try {
      // Load from local first (instant), then sync from API.
      final local = _local.getSettings();
      _syncFromApi();
      return Success(local);
    } catch (e) {
      return Error(CacheFailure('Failed to load settings: $e'));
    }
  }

  Future<void> _syncFromApi() async {
    if (_storage.getAuthToken() == null) return;
    try {
      final data = await _api.get(ApiConstants.settings);
      final theme = data['theme'] as String?;
      final locale = data['locale'] as String?;
      final settings = AppSettings(
        isDarkMode: theme == 'dark',
        locale: locale ?? 'en',
      );
      await _local.saveSettings(settings);
    } catch (_) {}
  }

  @override
  Future<Result<void>> updateSettings(AppSettings settings) async {
    try {
      await _local.saveSettings(settings);
      if (_storage.getAuthToken() != null) {
        try {
          await _api.patch(ApiConstants.settings, data: {
          'theme': settings.isDarkMode ? 'dark' : 'light',
          'locale': settings.locale,
        });
      } catch (_) {}
      }
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure('Failed to save settings: $e'));
    }
  }
}
