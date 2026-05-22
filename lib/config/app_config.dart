import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Coffee Shop';
  // static const String appName = 'كافيه السعاده';

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
  static const Color tier1Color = Color(0xFF0000FF);
  static const Color tier2Color = Color(0xFF696E74);
  static const Color tier3Color = Color(0xFFFF891C);
  static const Color tier4Color = Color(0xFF707BE3);
}
