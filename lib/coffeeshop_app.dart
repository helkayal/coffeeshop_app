import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'config/app_config.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class CoffeeShopApp extends StatelessWidget {
  final String initialRoute;

  const CoffeeShopApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app_name'.tr(),

      // Localization setup
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // Theme setup
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppConfig.defaultThemeMode,

      // Routing system
      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

