import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/entities/connection_status.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/connection_error_view.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConnectivityCubit>().check();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityOnline) {
              context.read<AuthCubit>().refreshSession();
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            switch (state) {
              case AuthAuthenticated():
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              case AuthSessionExpired():
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              default:
                break;
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = context.watch<ConnectivityCubit>().state;
    if (state is ConnectivityChecking || state is ConnectivityOnline) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (state is ConnectivityOffline &&
        state.status == ConnectionStatus.noInternet) {
      return ConnectionErrorView(
        message: 'splash_screen.no_internet'.tr(),
        onRetry: context.read<ConnectivityCubit>().retry,
      );
    }

    if (state is ConnectivityOffline &&
        state.status == ConnectionStatus.serverUnreachable) {
      return ConnectionErrorView(
        message: 'splash_screen.server_error'.tr(),
        onRetry: context.read<ConnectivityCubit>().retry,
      );
    }

    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
}
