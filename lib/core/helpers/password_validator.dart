import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Client-side password validation that mirrors Django's built-in validators:
///
/// 1. MinimumLengthValidator     – at least 8 characters
/// 2. NumericPasswordValidator   – not entirely numeric
/// 3. UserAttributeSimilarityValidator – not too similar to email or name
/// 4. CommonPasswordValidator    – not a commonly known weak password
///
/// [validate] and [validateConfirm] return localization keys (validation.*)
/// — callers must translate them with `.tr()` before showing them.
///
/// The common-password check uses Django's full 20 000-entry list, loaded
/// from `assets/common_passwords.txt` via [loadCommonPasswords] at app
/// startup, so it matches the backend exactly. Until then (and if loading
/// fails) a small built-in subset is used as a fallback.
class PasswordValidator {
  const PasswordValidator._();

  /// Loads Django's common-password list into memory.
  ///
  /// Called once at app startup. Falls back to the built-in subset if the
  /// asset cannot be loaded.
  static Future<void> loadCommonPasswords() async {
    try {
      final data =
          await rootBundle.loadString('assets/common_passwords.txt');
      final words = data
          .split('\n')
          .map((w) => w.trim().toLowerCase())
          .where((w) => w.isNotEmpty);
      _commonPasswords = {..._commonPasswords, ...words};
    } catch (e) {
      debugPrint('PasswordValidator: failed to load common passwords: $e');
    }
  }

  // ── Localization keys (reusable across login + register + reset) ────────
  static const String requiredErrorKey = 'validation.password_required';
  static const String minLengthErrorKey = 'validation.password_min_length';
  static const String numericErrorKey = 'validation.password_numeric';
  static const String similarityErrorKey = 'validation.password_similar';
  static const String commonErrorKey = 'validation.password_common';
  static const String confirmRequiredErrorKey =
      'validation.confirm_password_required';
  static const String passwordsDoNotMatchErrorKey =
      'validation.passwords_do_not_match';

  /// Validates [password] against all rules.
  ///
  /// Returns the localization key of the first failing rule,
  /// or `null` if the password passes all checks.
  ///
  /// [email], [firstName], and [lastName] are used for the similarity check.
  static String? validate(
    String password, {
    String email = '',
    String firstName = '',
    String lastName = '',
  }) {
    if (password.isEmpty) return requiredErrorKey;

    // Rule 1 – minimum length
    if (password.length < 8) return minLengthErrorKey;

    // Rule 2 – not entirely numeric
    if (RegExp(r'^\d+$').hasMatch(password)) return numericErrorKey;

    // Rule 3 – not too similar to user attributes
    if (_checkSimilarity(
      password,
      email: email,
      firstName: firstName,
      lastName: lastName,
    )) {
      return similarityErrorKey;
    }

    // Rule 4 – not a common password
    if (_isCommonPassword(password)) return commonErrorKey;

    return null;
  }

  /// Validates the confirm field against [password].
  ///
  /// Returns the localization key of the failing rule,
  /// or `null` if the confirmation is valid.
  static String? validateConfirm(String password, String confirm) {
    if (confirm.isEmpty) return confirmRequiredErrorKey;
    if (confirm != password) return passwordsDoNotMatchErrorKey;
    return null;
  }

  // ── Similarity check ────────────────────────────────────────────────────
  // Mirrors Django's UserAttributeSimilarityValidator (max_similarity = 0.7).
  // We check if any attribute part (split by separators) appears as a
  // contiguous substring of the password (case-insensitive), which covers
  // the most common failure cases without a full SequenceMatcher port.

  static bool _checkSimilarity(
    String password, {
    required String email,
    required String firstName,
    required String lastName,
  }) {
    final pw = password.toLowerCase();

    // Extract meaningful parts from each attribute.
    final emailLocal = email.split('@').first; // local part before @
    final parts = [
      ...emailLocal.split(RegExp(r'[._+\-]')),
      ...firstName.split(RegExp(r'[\s._+\-]')),
      ...lastName.split(RegExp(r'[\s._+\-]')),
    ].where((p) => p.length >= 4).toList(); // ignore very short fragments

    for (final part in parts) {
      if (pw.contains(part.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  // ── Common password list ────────────────────────────────────────────────
  // Starts as a built-in subset (also covering app-specific entries such as
  // 'coffeeshop' that Django's list doesn't include) and grows with the full
  // list loaded from the asset at startup.

  static bool _isCommonPassword(String password) =>
      _commonPasswords.contains(password.toLowerCase());

  static Set<String> _commonPasswords = {..._builtInCommonPasswords};

  static const _builtInCommonPasswords = <String>{
    'password', 'password1', 'password123', '123456', '12345678',
    '123456789', '1234567890', 'qwerty', 'qwerty123', 'abc123',
    'iloveyou', 'admin', 'letmein', 'welcome', 'monkey', '1234567',
    'dragon', 'master', 'sunshine', 'princess', 'football', 'shadow',
    'superman', 'michael', 'baseball', 'solo', 'trustno1', 'hello',
    'charlie', 'donald', 'password2', 'qwertyuiop', 'starwars',
    'login', 'hello123', 'pass', 'test', 'test123', 'mypassword',
    'computer', 'coffee', 'coffeeshop', 'qazwsx', 'asd123',
  };
}
