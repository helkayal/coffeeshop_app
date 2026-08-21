import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/settings/domain/entities/app_settings.dart';
import 'package:coffeeshop_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:coffeeshop_app/features/settings/domain/usecases/settings_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

const _settings = AppSettings(isDarkMode: true, locale: 'ar');

void main() {
  late _FakeSettingsRepository repository;

  setUp(() {
    repository = _FakeSettingsRepository();
  });

  group('GetSettingsUseCase', () {
    test('returns the settings from the repository', () async {
      repository.settingsResult = const Success(_settings);

      final result = await GetSettingsUseCase(repository)();

      expect((result as Success<AppSettings>).data, _settings);
    });

    test('propagates a settings load failure', () async {
      repository.settingsResult = const Error<AppSettings>(
        CacheFailure('errors.settings_load_failed'),
      );

      final result = await GetSettingsUseCase(repository)();

      expect(
        (result as Error<AppSettings>).failure.message,
        'errors.settings_load_failed',
      );
    });
  });

  group('UpdateSettingsUseCase', () {
    test('forwards the settings to the repository', () async {
      final result = await UpdateSettingsUseCase(repository)(_settings);

      expect(repository.updated, _settings);
      expect(result, isA<Success<void>>());
    });

    test('propagates a settings update failure', () async {
      repository.updateResult = const Error<void>(
        CacheFailure('errors.settings_save_failed'),
      );

      final result = await UpdateSettingsUseCase(repository)(_settings);

      expect(
        (result as Error<void>).failure.message,
        'errors.settings_save_failed',
      );
    });
  });
}

class _FakeSettingsRepository implements SettingsRepository {
  Result<AppSettings>? settingsResult;
  Result<void>? updateResult;
  AppSettings? updated;

  @override
  Future<Result<AppSettings>> getSettings() async =>
      settingsResult ?? const Success(AppSettings(isDarkMode: false, locale: 'en'));

  @override
  Future<Result<void>> updateSettings(AppSettings settings) async {
    updated = settings;
    return updateResult ?? const Success(null);
  }
}
