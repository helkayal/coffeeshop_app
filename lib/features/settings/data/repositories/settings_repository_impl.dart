import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/security/credential_storage.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;
  final ApiService _api;
  final CredentialStorage _credentials;

  SettingsRepositoryImpl(this._local, this._api, this._credentials);

  @override
  Future<Result<AppSettings>> getSettings() async {
    try {
      final local = _local.getSettings();
      await _syncFromApi();
      return Success(local);
    } catch (_) {
      return const Error(CacheFailure('settings_load_failed'));
    }
  }

  Future<void> _syncFromApi() async {
    if (await _credentials.readAccessToken() == null) return;
    final data = await _api.get(ApiConstants.settings) as Map<String, dynamic>;
    final theme = data['theme'] as String?;
    final locale = data['locale'] as String?;
    await _local.saveSettings(
      AppSettings(isDarkMode: theme == 'dark', locale: locale ?? 'en'),
    );
  }

  @override
  Future<Result<void>> updateSettings(AppSettings settings) async {
    try {
      await _local.saveSettings(settings);
      if (await _credentials.readAccessToken() != null) {
        await _api.patch(
          ApiConstants.settings,
          data: {
            'theme': settings.isDarkMode ? 'dark' : 'light',
            'locale': settings.locale,
          },
        );
      }
      return const Success(null);
    } catch (_) {
      return const Error(CacheFailure('settings_save_failed'));
    }
  }
}
