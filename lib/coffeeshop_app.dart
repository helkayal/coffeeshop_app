import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'config/app_config.dart';
import 'core/cubit/shell_cubit.dart';
import 'core/routes/app_routes.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';

class CoffeeShopApp extends StatelessWidget {
  final String initialRoute;

  const CoffeeShopApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ShellCubit()),
        BlocProvider(
          create: (_) => sl<SettingsCubit>()..loadSettings(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev != curr,
        builder: (context, settingsState) {
          final themeMode = settingsState is SettingsLoaded
              ? settingsState.themeMode
              : AppConfig.defaultThemeMode;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConfig.appName,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: initialRoute,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
