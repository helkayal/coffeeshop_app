import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/app_config.dart';
import 'core/cubit/connectivity_cubit.dart';
import 'core/cubit/shell_cubit.dart';
import 'core/routes/app_routes.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/locations_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthCubit lives at root so SplashScreen, LoginScreen, and
        // RegisterScreen all share the same instance throughout the auth flow.
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider.value(value: sl<ConnectivityCubit>()..check()),
        BlocProvider(create: (_) => sl<LocationsCubit>()..loadStates()),
        BlocProvider.value(value: sl<ShellCubit>()),
        BlocProvider(create: (_) => sl<SettingsCubit>()..loadSettings()),
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
            // SplashScreen is always the initial screen ('/').
            // It proactively refreshes the session and routes accordingly.
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
