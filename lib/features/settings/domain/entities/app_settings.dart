class AppSettings {
  final bool isDarkMode;
  final String locale;
  final bool notificationsOn;

  const AppSettings({
    required this.isDarkMode,
    required this.locale,
    this.notificationsOn = true,
  });

  AppSettings copyWith({bool? isDarkMode, String? locale, bool? notificationsOn}) => AppSettings(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        locale: locale ?? this.locale,
        notificationsOn: notificationsOn ?? this.notificationsOn,
      );
}
