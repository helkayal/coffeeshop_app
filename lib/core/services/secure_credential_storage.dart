import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../security/credential_storage.dart';

class SecureCredentialStorage implements CredentialStorage {
  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  SecureCredentialStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> writeAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  @override
  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

  Future<void> migrateFrom(LegacyCredentialSource localStorage) async {
    final legacy = localStorage.readLegacyCredentials();
    if (legacy.accessToken == null && legacy.refreshToken == null) return;

    if (legacy.accessToken case final token?) {
      await writeAccessToken(token);
    }
    if (legacy.refreshToken case final token?) {
      await writeRefreshToken(token);
    }
    await localStorage.deleteLegacyCredentials();
  }
}
