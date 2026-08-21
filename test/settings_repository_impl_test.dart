import 'package:coffeeshop_app/core/constants/api_constants.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/core/security/credential_storage.dart';
import 'package:coffeeshop_app/core/services/api_service.dart';
import 'package:coffeeshop_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:coffeeshop_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:coffeeshop_app/features/settings/domain/entities/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

const _localSettings = AppSettings(isDarkMode: false, locale: 'en');

void main() {
  late _FakeSettingsLocalDataSource local;
  late _FakeApiService api;
  late _FakeCredentials credentials;
  late SettingsRepositoryImpl repository;

  setUp(() {
    local = _FakeSettingsLocalDataSource();
    api = _FakeApiService();
    credentials = _FakeCredentials();
    repository = SettingsRepositoryImpl(local, api, credentials);
  });

  group('getSettings', () {
    test('returns local settings without calling the API when logged out',
        () async {
      final result = await repository.getSettings();

      expect(api.getCalls, 0);
      expect((result as Success<AppSettings>).data, _localSettings);
    });

    test('syncs remote settings and saves them locally when logged in',
        () async {
      credentials.access = 'token';
      api.getResult = {'theme': 'dark', 'locale': 'ar'};

      final result = await repository.getSettings();

      expect(api.getCalls, 1);
      expect(api.lastGetPath, ApiConstants.settings);
      expect(local.saved?.isDarkMode, isTrue);
      expect(local.saved?.locale, 'ar');
      // The returned settings are the pre-sync local values.
      expect((result as Success<AppSettings>).data, _localSettings);
    });

    test('defaults the locale to en and light mode when the remote sends none',
        () async {
      credentials.access = 'token';
      api.getResult = const {};

      await repository.getSettings();

      expect(local.saved?.isDarkMode, isFalse);
      expect(local.saved?.locale, 'en');
    });

    test('returns a cache failure when loading local settings fails', () async {
      local.getError = StateError('boom');

      final result = await repository.getSettings();

      expect(
        (result as Error<AppSettings>).failure,
        isA<CacheFailure>().having(
          (f) => f.message,
          'message',
          'errors.settings_load_failed',
        ),
      );
    });

    test('returns a cache failure when the settings sync fails', () async {
      credentials.access = 'token';
      api.getError = StateError('boom');

      final result = await repository.getSettings();

      expect(
        (result as Error<AppSettings>).failure.message,
        'errors.settings_load_failed',
      );
    });
  });

  group('updateSettings', () {
    test('saves locally without calling the API when logged out', () async {
      const settings = AppSettings(isDarkMode: true, locale: 'ar');

      final result = await repository.updateSettings(settings);

      expect(local.saved?.isDarkMode, isTrue);
      expect(local.saved?.locale, 'ar');
      expect(api.patchCalls, 0);
      expect(result, isA<Success<void>>());
    });

    test('saves locally and patches the API when logged in', () async {
      credentials.access = 'token';
      const settings = AppSettings(isDarkMode: true, locale: 'ar');

      final result = await repository.updateSettings(settings);

      expect(local.saved?.isDarkMode, isTrue);
      expect(local.saved?.locale, 'ar');
      expect(api.patchCalls, 1);
      expect(api.lastPatchPath, ApiConstants.settings);
      expect(api.lastPatchData, {'theme': 'dark', 'locale': 'ar'});
      expect(result, isA<Success<void>>());
    });

    test('maps an API failure to settings_save_failed', () async {
      credentials.access = 'token';
      api.patchError = StateError('boom');

      final result = await repository.updateSettings(_localSettings);

      // The local save has already happened by the time the API call fails.
      expect(local.saved?.isDarkMode, isFalse);
      expect(local.saved?.locale, 'en');
      expect(
        (result as Error<void>).failure.message,
        'errors.settings_save_failed',
      );
    });

    test('maps a local save failure to settings_save_failed', () async {
      local.saveError = StateError('boom');

      final result = await repository.updateSettings(_localSettings);

      expect(
        (result as Error<void>).failure.message,
        'errors.settings_save_failed',
      );
    });
  });
}

class _FakeSettingsLocalDataSource extends SettingsLocalDataSource {
  AppSettings settings = _localSettings;
  AppSettings? saved;
  Object? getError;
  Object? saveError;

  @override
  AppSettings getSettings() {
    if (getError != null) throw getError!;
    return settings;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    if (saveError != null) throw saveError!;
    saved = settings;
  }
}

class _FakeApiService extends ApiService {
  _FakeApiService() : super(_FakeCredentials());

  Map<String, dynamic>? getResult;
  Object? getError;
  Object? patchError;
  int getCalls = 0;
  int patchCalls = 0;
  String? lastGetPath;
  String? lastPatchPath;
  dynamic lastPatchData;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (getError != null) throw getError!;
    getCalls++;
    lastGetPath = path;
    return getResult ?? const <String, dynamic>{};
  }

  @override
  Future<dynamic> patch(String path, {dynamic data, Options? options}) async {
    if (patchError != null) throw patchError!;
    patchCalls++;
    lastPatchPath = path;
    lastPatchData = data;
    return null;
  }
}

class _FakeCredentials implements CredentialStorage {
  String? access;

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> writeAccessToken(String token) async => access = token;

  @override
  Future<void> writeRefreshToken(String token) async {}

  @override
  Future<void> clear() async {}
}
