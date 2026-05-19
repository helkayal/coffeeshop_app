import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Coffee Shop';

  // Localization
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];
  static const Locale defaultLocale = Locale('en');
  static const String translationsPath = 'assets/translations';

  // Theme
  static const ThemeMode defaultThemeMode = ThemeMode.dark;
}
