abstract interface class CredentialStorage {
  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<void> writeAccessToken(String token);

  Future<void> writeRefreshToken(String token);

  Future<void> clear();
}

abstract interface class LegacyCredentialSource {
  ({String? accessToken, String? refreshToken}) readLegacyCredentials();

  Future<void> deleteLegacyCredentials();
}
