class AppSettings {
  final bool isDarkMode;
  final String locale; // e.g. 'en' or 'ar'

  const AppSettings({
    required this.isDarkMode,
    required this.locale,
  });

  AppSettings copyWith({bool? isDarkMode, String? locale}) => AppSettings(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        locale: locale ?? this.locale,
      );
}
