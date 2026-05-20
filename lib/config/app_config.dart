import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Coffee Shop';
  // static const String appName = 'كافيه السعاده';

  // Localization
  static const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];
  static const Locale defaultLocale = Locale('en');
  static const String translationsPath = 'assets/translations';

  // Theme
  static const ThemeMode defaultThemeMode = ThemeMode.light;
}
