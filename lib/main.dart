import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'coffeeshop_app.dart';
import 'config/app_config.dart';
import 'core/helpers/password_validator.dart';
import 'core/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupServiceLocator();
  await PasswordValidator.loadCommonPasswords();

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
