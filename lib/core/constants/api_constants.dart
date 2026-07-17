import 'dart:io';

class ApiConstants {
  static final String apiBaseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api/v1'
      : 'http://127.0.0.1:8000/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String tokenRefresh = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String socialLogin = '/auth/social';
  static const String verifyEmail = '/auth/verify-email';

  // Onboarding
  static const String onboarding = '/onboarding';

  // Menu
  static const String menu = '/menu';

  // Orders
  static const String orders = '/orders';

  // Cart
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';

  // Favorites
  static const String favorites = '/favorites';

  // Profile
  static const String profile = '/profile';
  static const String profileUpdate = '/profile/update';
  static const String profileAvatar = '/profile/avatar';
  static const String profileChangeEmail = '/profile/change-email';

  // Loyalty
  static const String loyalty = '/loyalty';
  static const String loyaltyHistory = '/loyalty/history';
  static const String loyaltyBenefits = '/loyalty/benefits';

  // Wallet
  static const String wallet = '/wallet';
  static const String walletTopup = '/wallet/topup';
  static const String walletTransactions = '/wallet/transactions';

  // Referral
  static const String referral = '/referral';
  static const String referralApply = '/referral/apply';
  static const String referralHistory = '/referral/history';

  // Payment methods
  static const String paymentMethods = '/payment-methods';

  // Settings
  static const String settings = '/settings';

  // Locations
  static const String locationsStates = '/locations/states';
  static const String locationsCities = '/locations/cities';
}
