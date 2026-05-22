class ApiConstants {
  static const String apiBaseUrl = 'https://api.coffeeshop.com/v1';

  // Auth
  static const String login    = '/auth/login';
  static const String register = '/auth/register';
  static const String logout   = '/auth/logout';
  static const String me       = '/auth/me';

  // Onboarding
  static const String onboardingQuestions = '/onboarding/questions';

  // Menu
  static const String products   = '/menu/products';
  static const String categories = '/menu/categories';

  // Cart
  static const String cart      = '/cart';
  static const String cartItems = '/cart/items';

  // Orders
  static const String orders = '/orders';

  // Favorites
  static const String favorites = '/favorites';

  // Profile / Loyalty
  static const String profile = '/profile';
  static const String loyalty = '/loyalty';
}
