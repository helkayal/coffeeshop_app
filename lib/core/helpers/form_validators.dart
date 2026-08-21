import 'password_validator.dart';

/// Shared form-field validation for auth screens. Methods return
/// localization keys (validation.*) or null when the value is valid;
/// callers translate the returned keys.
class FormValidators {
  const FormValidators._();

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static bool isValidEmail(String email) =>
      _emailPattern.hasMatch(email.trim());

  /// Returns a validation key for an invalid email, or null when valid.
  static String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return 'validation.email_required';
    if (!_emailPattern.hasMatch(trimmed)) return 'validation.email_invalid';
    return null;
  }

  /// Login password check: presence + minimum length + numeric-only.
  static String? validateLoginPassword(String password) {
    if (password.isEmpty) return 'validation.password_required';
    if (password.length < 8) return 'validation.password_min_length';
    if (RegExp(r'^\d+$').hasMatch(password)) {
      return PasswordValidator.numericErrorKey;
    }
    return null;
  }
}
