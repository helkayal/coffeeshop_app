import 'package:flutter/material.dart';

import '../../domain/entities/app_settings.dart';

sealed class SettingsState {
  const SettingsState();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  const SettingsLoaded(this.settings);

  bool get isDarkMode => settings.isDarkMode;
  String get locale => settings.locale;
  ThemeMode get themeMode =>
      settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
}
