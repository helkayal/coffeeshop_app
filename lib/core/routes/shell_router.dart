import 'package:flutter/material.dart';

import '../cubit/shell_cubit.dart';
import '../../features/account/presentation/screens/edit_profile_screen.dart';
import '../../features/account/presentation/screens/payment_methods_screen.dart';
import '../../features/account/presentation/screens/referral_screen.dart';
import '../../features/account/presentation/screens/view_benefits_screen.dart';
import '../../features/account/presentation/screens/wallet_screen.dart';
import '../../features/checkout/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/order_confirmation_screen.dart';
import '../../features/checkout/presentation/screens/payment_screen.dart';
import '../../features/customization/presentation/screens/customization_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// Maps every [SecondaryRoute] to its Widget.
///
/// Keeping this in core/routes/ means adding a new secondary screen
/// only touches this file — MainShell stays unchanged.
class ShellRouter {
  const ShellRouter._();

  static Widget build(SecondaryRoute route) => switch (route) {
        CartRoute() => const CartScreen(),
        PaymentRoute() => const PaymentScreen(),
        CustomizationRoute() => const CustomizationScreen(),
        SettingsRoute() => const SettingsScreen(),
        EditProfileRoute() => const EditProfileScreen(),
        OrdersHistoryRoute() => const OrdersScreen(),
        OrderConfirmationRoute() => const OrderConfirmationScreen(),
        ViewBenefitsRoute() => const ViewBenefitsScreen(),
        WalletRoute() => const WalletScreen(),
        ReferralRoute() => const ReferralScreen(),
        PaymentMethodsRoute() => const PaymentMethodsScreen(),
      };
}
