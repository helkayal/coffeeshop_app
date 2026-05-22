import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'config/app_config.dart';
import 'core/cubit/shell_cubit.dart';
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
    return BlocProvider(
      create: (_) => ShellCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: AppConfig.defaultThemeMode,
        initialRoute: initialRoute,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
