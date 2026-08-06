/// Client-side password validation that mirrors Django's built-in validators:
///
/// 1. MinimumLengthValidator     – at least 8 characters
/// 2. NumericPasswordValidator   – not entirely numeric
/// 3. UserAttributeSimilarityValidator – not too similar to email or name
/// 4. CommonPasswordValidator    – not a commonly known weak password
class PasswordValidator {
  const PasswordValidator._();

  // ── Public error strings (reusable across login + register) ─────────────
  static const String requiredError = 'Password is required';
  static const String minLengthError = 'Password must be at least 8 characters';
  static const String numericError = "Password can't be entirely numeric";
  static const String similarityError =
      'Password is too similar to your personal information';
  static const String commonError = 'Password is too common';

  /// Validates [password] against all rules.
  ///
  /// Returns a human-readable error string on the first failing rule,
  /// or `null` if the password passes all checks.
  ///
  /// [email], [firstName], and [lastName] are used for the similarity check.
  static String? validate(
    String password, {
    String email = '',
    String firstName = '',
    String lastName = '',
  }) {
    if (password.isEmpty) return requiredError;

    // Rule 1 – minimum length
    if (password.length < 8) return minLengthError;

    // Rule 2 – not entirely numeric
    if (RegExp(r'^\d+$').hasMatch(password)) return numericError;

    // Rule 3 – not too similar to user attributes
    final similarityMsg = _checkSimilarity(
      password,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    if (similarityMsg != null) return similarityError;

    // Rule 4 – not a common password
    if (_isCommonPassword(password)) return commonError;

    return null;
  }

  // ── Similarity check ────────────────────────────────────────────────────
  // Mirrors Django's UserAttributeSimilarityValidator (max_similarity = 0.7).
  // We check if any attribute part (split by separators) appears as a
  // contiguous substring of the password (case-insensitive), which covers
  // the most common failure cases without a full SequenceMatcher port.

  static String? _checkSimilarity(
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
        return 'Password is too similar to your personal information';
      }
    }
    return null;
  }

  // ── Common password list ────────────────────────────────────────────────
  // A representative subset of Django's 20 000-entry common-passwords list.
  // Covers the most frequently submitted weak passwords.

  static bool _isCommonPassword(String password) =>
      _commonPasswords.contains(password.toLowerCase());

  static const _commonPasswords = <String>{
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
