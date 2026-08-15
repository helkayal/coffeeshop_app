import 'package:coffeeshop_app/core/security/credential_storage.dart';
import 'package:coffeeshop_app/core/services/secure_credential_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('migrates legacy credentials then deletes plaintext values', () async {
    final legacy = _FakeLegacySource('access', 'refresh');
    final storage = SecureCredentialStorage();

    await storage.migrateFrom(legacy);

    expect(await storage.readAccessToken(), 'access');
    expect(await storage.readRefreshToken(), 'refresh');
    expect(legacy.deleted, isTrue);
  });

  test('clear removes both secure credentials', () async {
    final storage = SecureCredentialStorage();
    await storage.writeAccessToken('access');
    await storage.writeRefreshToken('refresh');

    await storage.clear();

    expect(await storage.readAccessToken(), isNull);
    expect(await storage.readRefreshToken(), isNull);
  });
}

class _FakeLegacySource implements LegacyCredentialSource {
  final String? accessToken;
  final String? refreshToken;
  bool deleted = false;

  _FakeLegacySource(this.accessToken, this.refreshToken);

  @override
  ({String? accessToken, String? refreshToken}) readLegacyCredentials() =>
      (accessToken: accessToken, refreshToken: refreshToken);

  @override
  Future<void> deleteLegacyCredentials() async => deleted = true;
}
