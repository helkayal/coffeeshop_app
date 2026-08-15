import 'package:hive_flutter/hive_flutter.dart';

import '../security/credential_storage.dart';

class LocalStorageService implements LegacyCredentialSource {
  static const String _boxName = 'app_preferences';
  static const String _isFirstRunKey = 'is_first_run';
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _cachedUserKey = 'cached_user';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  // --- First-run ---

  bool isFirstRun() {
    final box = Hive.box(_boxName);
    return box.get(_isFirstRunKey, defaultValue: true) as bool;
  }

  Future<void> setFirstRunCompleted() async {
    final box = Hive.box(_boxName);
    await box.put(_isFirstRunKey, false);
  }

  @override
  ({String? accessToken, String? refreshToken}) readLegacyCredentials() {
    final box = Hive.box(_boxName);
    return (
      accessToken: box.get(_authTokenKey) as String?,
      refreshToken: box.get(_refreshTokenKey) as String?,
    );
  }

  @override
  Future<void> deleteLegacyCredentials() async {
    await Hive.box(_boxName).deleteAll([_authTokenKey, _refreshTokenKey]);
  }

  // --- Cached user ---

  Future<void> cacheUser(Map<String, dynamic> userJson) async {
    await Hive.box(_boxName).put(_cachedUserKey, userJson);
  }

  Map<String, dynamic>? getCachedUser() {
    final raw = Hive.box(_boxName).get(_cachedUserKey);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<void> clearCachedUser() async {
    await Hive.box(_boxName).delete(_cachedUserKey);
  }

  // --- Pending avatar (set during register, uploaded after login) ---

  static const String _pendingAvatarKey = 'pending_avatar_path';

  Future<void> setPendingAvatarPath(String path) async {
    await Hive.box(_boxName).put(_pendingAvatarKey, path);
  }

  String? getPendingAvatarPath() =>
      Hive.box(_boxName).get(_pendingAvatarKey) as String?;

  Future<void> clearPendingAvatarPath() async {
    await Hive.box(_boxName).delete(_pendingAvatarKey);
  }

  // --- Favorite modifier selections (keyed by product ID) ---

  static const String _favSelectionsKey = 'favorite_selections';

  Future<void> saveFavoriteSelections(
    String productId,
    Map<String, dynamic> selections,
  ) async {
    final box = Hive.box(_boxName);
    final all = _getFavSelectionsRaw();
    all[productId] = selections;
    await box.put(_favSelectionsKey, all);
  }

  Map<String, dynamic>? getFavoriteSelections(String productId) {
    final all = _getFavSelectionsRaw();
    final entry = all[productId];
    if (entry is Map) return _castMap(entry);
    return null;
  }

  Map<String, dynamic> _castMap(Map map) {
    return map.map((k, v) => MapEntry(k.toString(), _convert(v)));
  }

  dynamic _convert(dynamic v) {
    if (v is Map) return _castMap(v);
    if (v is List) return v.map(_convert).toList();
    return v;
  }

  Future<void> clearFavoriteSelections(String productId) async {
    final all = _getFavSelectionsRaw();
    all.remove(productId);
    await Hive.box(_boxName).put(_favSelectionsKey, all);
  }

  Map<dynamic, dynamic> _getFavSelectionsRaw() {
    final raw = Hive.box(_boxName).get(_favSelectionsKey);
    if (raw is Map) return Map.from(raw);
    return {};
  }

  // --- Payment methods ---

  static const String _cardsKey = 'saved_cards';
  static const String _walletPhoneKey = 'wallet_phone';
  static const String _defaultPaymentMethodKey = 'default_payment_method';

  String? getDefaultPaymentMethod() =>
      Hive.box(_boxName).get(_defaultPaymentMethodKey) as String?;

  Future<void> setDefaultPaymentMethod(String method) async {
    await Hive.box(_boxName).put(_defaultPaymentMethodKey, method);
  }

  Future<void> clearDefaultPaymentMethod() async {
    await Hive.box(_boxName).delete(_defaultPaymentMethodKey);
  }

  List<Map<String, dynamic>> getSavedCards() {
    final raw = Hive.box(_boxName).get(_cardsKey);
    if (raw is List) {
      return raw.map((e) => _castMap(e as Map)).toList();
    }
    return [];
  }

  Future<void> setSavedCards(List<Map<String, dynamic>> cards) async {
    await Hive.box(_boxName).put(_cardsKey, cards);
  }

  Future<void> saveCard(Map<String, dynamic> card) async {
    final cards = getSavedCards();
    cards.insert(0, card);
    await Hive.box(_boxName).put(_cardsKey, cards);
  }

  Future<void> removeCard(int index) async {
    final cards = getSavedCards();
    if (index < cards.length) {
      cards.removeAt(index);
      await Hive.box(_boxName).put(_cardsKey, cards);
    }
  }

  String? getWalletPhone() =>
      Hive.box(_boxName).get(_walletPhoneKey) as String?;

  Future<void> setWalletPhone(String phone) async {
    await Hive.box(_boxName).put(_walletPhoneKey, phone);
  }
}
