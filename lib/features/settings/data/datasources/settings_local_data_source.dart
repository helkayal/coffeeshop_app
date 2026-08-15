import 'package:hive_flutter/hive_flutter.dart';

import '../../../../config/app_config.dart';
import '../../domain/entities/app_settings.dart';

class SettingsLocalDataSource {
  static const String _boxName = 'settings';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _localeKey = 'locale';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  AppSettings getSettings() {
    final box = Hive.box(_boxName);
    final isDark = AppConfig.defaultThemeMode.toString() == 'ThemeMode.dark';
    return AppSettings(
      isDarkMode: box.get(_isDarkModeKey, defaultValue: isDark) as bool,
      locale:
          box.get(
                _localeKey,
                defaultValue: AppConfig.defaultLocale.languageCode,
              )
              as String,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box(_boxName);
    await box.put(_isDarkModeKey, settings.isDarkMode);
    await box.put(_localeKey, settings.locale);
  }
}
