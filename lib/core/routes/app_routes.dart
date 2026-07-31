import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../features/home/presentation/screens/main_shell.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/email_verification_screen.dart';
import '../../features/auth/presentation/screens/verify_email_args.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case verifyEmail:
        final args = settings.arguments;
        final String email;
        final bool autoResend;
        if (args is VerifyEmailArgs) {
          email = args.email;
          autoResend = args.autoResend;
        } else {
          email = args as String? ?? '';
          autoResend = false;
        }
        return MaterialPageRoute(
          builder: (_) => EmailVerificationScreen(
            email: email,
            autoResend: autoResend,
          ),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const MainShell());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'error_route_not_found'.tr(args: [settings.name ?? '']),
              ),
            ),
          ),
        );
    }
  }
}
