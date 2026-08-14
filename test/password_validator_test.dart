import 'package:flutter_test/flutter_test.dart';

import 'package:coffeeshop_app/core/helpers/password_validator.dart';

void main() {
  group('PasswordValidator.validate', () {
    test('returns required key for empty password', () {
      expect(
        PasswordValidator.validate(''),
        PasswordValidator.requiredErrorKey,
      );
    });

    test('returns min length key for short password', () {
      expect(
        PasswordValidator.validate('abc123'),
        PasswordValidator.minLengthErrorKey,
      );
    });

    test('returns numeric key for all-digit password', () {
      expect(
        PasswordValidator.validate('12345678'),
        PasswordValidator.numericErrorKey,
      );
    });

    test('returns similarity key when password contains email local part', () {
      expect(
        PasswordValidator.validate('john1234!', email: 'john@example.com'),
        PasswordValidator.similarityErrorKey,
      );
    });

    test('returns common key for known weak password', () {
      expect(
        PasswordValidator.validate('password123'),
        PasswordValidator.commonErrorKey,
      );
    });

    test('returns null for a strong password', () {
      expect(PasswordValidator.validate('StrongPass1!'), isNull);
    });
  });

  group('PasswordValidator.loadCommonPasswords', () {
    test('loads Django common passwords from the asset', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await PasswordValidator.loadCommonPasswords();

      // '1qaz2wsx' is in Django's list but not in the built-in subset.
      expect(
        PasswordValidator.validate('1qaz2wsx'),
        PasswordValidator.commonErrorKey,
      );
    });
  });

  group('PasswordValidator.validateConfirm', () {
    test('returns required key for empty confirm', () {
      expect(
        PasswordValidator.validateConfirm('StrongPass1!', ''),
        PasswordValidator.confirmRequiredErrorKey,
      );
    });

    test('returns mismatch key when passwords differ', () {
      expect(
        PasswordValidator.validateConfirm('StrongPass1!', 'OtherPass2!'),
        PasswordValidator.passwordsDoNotMatchErrorKey,
      );
    });

    test('returns null when passwords match', () {
      expect(
        PasswordValidator.validateConfirm('StrongPass1!', 'StrongPass1!'),
        isNull,
      );
    });
  });
}
