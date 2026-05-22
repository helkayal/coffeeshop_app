import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _boxName = 'app_preferences';
  static const String _isFirstRunKey = 'is_first_run';
  static const String _authTokenKey = 'auth_token';
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

  // --- Auth token ---

  Future<void> setAuthToken(String token) async {
    await Hive.box(_boxName).put(_authTokenKey, token);
  }

  String? getAuthToken() =>
      Hive.box(_boxName).get(_authTokenKey) as String?;

  Future<void> clearAuthToken() async {
    await Hive.box(_boxName).delete(_authTokenKey);
  }

  // --- Cached user (stored as Map to survive restarts) ---

  Future<void> setCurrentUser(Map<String, dynamic> userJson) async {
    await Hive.box(_boxName).put(_cachedUserKey, userJson);
  }

  Map<String, dynamic>? getCurrentUser() {
    final raw = Hive.box(_boxName).get(_cachedUserKey);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<void> clearCurrentUser() async {
    await Hive.box(_boxName).delete(_cachedUserKey);
  }
}
