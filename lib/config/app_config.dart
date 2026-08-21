import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Coffee Shop';

  // Localization
  static const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];
  static const Locale defaultLocale = Locale('en');
  static const String translationsPath = 'assets/translations';

  // Theme
  static const ThemeMode defaultThemeMode = ThemeMode.dark;

  // Loyalty Tiers
  static const double tier1Boundary = 180.0;
  static const double tier2Boundary = 500.0;
  static const double tier3Boundary = 1000.0;
}
