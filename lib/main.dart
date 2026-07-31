import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'coffeeshop_app.dart';
import 'config/app_config.dart';
import 'core/services/service_locator.dart';
import 'core/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupServiceLocator();

  // Ensure Hive is ready (LocalStorageService.init() is called inside
  // setupServiceLocator, so the box is already open at this point).
  final _ = sl<LocalStorageService>();

  runApp(
    EasyLocalization(
      supportedLocales: AppConfig.supportedLocales,
      path: AppConfig.translationsPath,
      startLocale: AppConfig.defaultLocale,
      fallbackLocale: AppConfig.defaultLocale,
      child: const CoffeeShopApp(),
    ),
  );
}
