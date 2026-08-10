import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/network_info_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/widgets/connection_error_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _networkInfo = sl<NetworkInfoService>();
  bool _checking = true;
  ConnectionStatus? _errorStatus;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _checking = true;
      _errorStatus = null;
    });

    final status = await _networkInfo.checkConnectivity();

    if (!mounted) return;

    if (status == ConnectionStatus.connected) {
      setState(() => _checking = false);
      context.read<AuthCubit>().refreshSession();
    } else {
      setState(() {
        _checking = false;
        _errorStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
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
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_checking) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_errorStatus == ConnectionStatus.noInternet) {
      return ConnectionErrorView(
        message: 'splash_screen.no_internet'.tr(),
        onRetry: _checkConnection,
      );
    }

    if (_errorStatus == ConnectionStatus.serverUnreachable) {
      return ConnectionErrorView(
        message: 'splash_screen.server_error'.tr(),
        onRetry: _checkConnection,
      );
    }

    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
}
