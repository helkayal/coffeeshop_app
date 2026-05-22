import '../../../../core/helpers/result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository _r;
  const GetSettingsUseCase(this._r);
  Future<Result<AppSettings>> call() => _r.getSettings();
}

class UpdateSettingsUseCase {
  final SettingsRepository _r;
  const UpdateSettingsUseCase(this._r);
  Future<Result<void>> call(AppSettings settings) => _r.updateSettings(settings);
}
