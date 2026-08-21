/// Client-side card validation shared by the add-card and credit-card
/// sheets. Methods return localization keys (credit_card.*) or null when
/// the value is valid; callers translate the returned keys.
class CardValidator {
  const CardValidator._();

  static String? validateNumber(String number) {
    final normalized = number.trim().replaceAll(RegExp(r'\s+'), '');
    if (normalized.length != 16 || int.tryParse(normalized) == null) {
      return 'credit_card.invalid_number';
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.trim().isEmpty) return 'credit_card.name_required';
    return null;
  }

  /// Parses "MM/YY" or "MMYY" expiry text. Returns null for unparseable
  /// input, invalid months, or years before 2000 (after 2-digit
  /// normalization).
  static (int, int)? parseExpiry(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    int month, year;
    if (trimmed.contains('/')) {
      final parts = trimmed.split('/');
      month = int.tryParse(parts[0].trim()) ?? 0;
      year = int.tryParse(parts[1].trim()) ?? 0;
    } else if (trimmed.length == 4) {
      month = int.tryParse(trimmed.substring(0, 2)) ?? 0;
      year = int.tryParse(trimmed.substring(2)) ?? 0;
    } else {
      return null;
    }

    if (year < 100) year += 2000;
    if (month < 1 || month > 12 || year < 2000) return null;
    return (month, year);
  }

  /// Whether the card expires before the end of the current month.
  /// Two-digit years are normalized to the 2000s.
  static bool isExpired(int month, int year, {DateTime? now}) {
    final current = now ?? DateTime.now();
    var normalizedYear = year;
    if (normalizedYear < 100) normalizedYear += 2000;
    final expiryDate = DateTime(normalizedYear, month + 1, 0);
    final currentMonthEnd = DateTime(current.year, current.month + 1, 0);
    return expiryDate.isBefore(currentMonthEnd);
  }

  /// Infers the card brand from the leading digit of the number.
  static String detectBrand(String number) {
    if (number.startsWith('5') || number.startsWith('2')) return 'Mastercard';
    if (number.startsWith('3')) return 'Amex';
    if (number.startsWith('6')) return 'Discover';
    return 'Visa';
  }
}
