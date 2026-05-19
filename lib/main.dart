import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'coffeeshop_app.dart';
import 'config/app_config.dart';
import 'core/routes/app_routes.dart';
import 'core/services/service_locator.dart';
import 'core/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupServiceLocator();

  final localDataSource = sl<AppLocalDataSource>();
  final initialRoute = localDataSource.isFirstRun()
      ? AppRoutes.onboarding
      : AppRoutes.login;

  runApp(
    EasyLocalization(
      supportedLocales: AppConfig.supportedLocales,
      path: AppConfig.translationsPath,
      fallbackLocale: AppConfig.defaultLocale,
      child: CoffeeShopApp(initialRoute: initialRoute),
    ),
  );
}
