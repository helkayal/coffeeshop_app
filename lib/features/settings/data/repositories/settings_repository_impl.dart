import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;

  SettingsRepositoryImpl(this._local);

  @override
  Future<Result<AppSettings>> getSettings() async {
    try {
      return Success(_local.getSettings());
    } catch (e) {
      return Error(CacheFailure('Failed to load settings: $e'));
    }
  }

  @override
  Future<Result<void>> updateSettings(AppSettings settings) async {
    try {
      await _local.saveSettings(settings);
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure('Failed to save settings: $e'));
    }
  }
}
