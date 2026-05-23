import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_config.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../features/checkout/presentation/cubit/cart_cubit.dart';
import '../../../../features/checkout/presentation/screens/cart_screen.dart';
import '../../../../features/checkout/presentation/screens/order_confirmation_screen.dart';
import '../../../../features/checkout/presentation/screens/payment_screen.dart';
import '../../../../features/customization/presentation/screens/customization_screen.dart';
import '../../../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../../../features/menu/presentation/screens/menu_screen.dart';
import '../../../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../../../features/orders/presentation/screens/orders_screen.dart';
import '../../../account/presentation/cubit/profile_cubit.dart';
import '../../../account/presentation/screens/account_screen.dart';
import '../../../account/presentation/screens/edit_profile_screen.dart';
import '../../../account/presentation/screens/view_benefits_screen.dart';
import '../../../account/presentation/screens/wallet_screen.dart';
import '../../../../features/settings/presentation/screens/settings_screen.dart';
import 'home_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _tabScreens = [
    HomeScreen(),
    MenuScreen(),
    FavoritesScreen(),
    AccountScreen(),
  ];

  static Widget _buildSecondary(SecondaryRoute route) => switch (route) {
    CartRoute() => const CartScreen(),
    PaymentRoute() => const PaymentScreen(),
    CustomizationRoute() => const CustomizationScreen(),
    SettingsRoute() => const SettingsScreen(),
    EditProfileRoute() => const EditProfileScreen(),
    OrdersHistoryRoute() => const OrdersScreen(),
    OrderConfirmationRoute() => const OrderConfirmationScreen(),
    ViewBenefitsRoute() => const ViewBenefitsScreen(),
    WalletRoute() => const WalletScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MenuCubit>()),
        BlocProvider(create: (_) => sl<CartCubit>()..loadCart()),
        BlocProvider(create: (_) => sl<OrdersCubit>()..loadOrders()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..loadFavorites()),
        BlocProvider(create: (_) => sl<ProfileCubit>()..loadProfile()),
      ],
      child: BlocBuilder<ShellCubit, ShellState>(
        buildWhen: (prev, curr) =>
            prev.tabIndex != curr.tabIndex ||
            prev.hasSecondary != curr.hasSecondary ||
            prev.secondaryStack.length != curr.secondaryStack.length,
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  AppAppBar(
                    title: AppConfig.appName,
                    // Show back on every secondary screen EXCEPT OrderConfirmation
                    // (the user must not return to the Payment screen after placing an order).
                    leading:
                        state.hasSecondary &&
                            state.currentSecondary is! OrderConfirmationRoute
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () =>
                                context.read<ShellCubit>().popSecondary(),
                          )
                        : null,
                    actions: [
                      // Settings gear: only on the Account tab with nothing open on top.
                      if (!state.hasSecondary && state.tabIndex == 3)
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => context
                              .read<ShellCubit>()
                              .pushSecondary(const SettingsRoute()),
                          icon: const Icon(Icons.settings_outlined),
                        ),
                      // Cart icon: hide whenever ANY secondary screen is open.
                      // (Settings, EditProfile, Customisation etc. don't need it.)
                      if (!state.hasSecondary)
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => context
                              .read<ShellCubit>()
                              .pushSecondary(const CartRoute()),
                          icon: const Icon(Icons.shopping_cart_outlined),
                        ),
                    ],
                  ),
                  Expanded(
                    child: state.hasSecondary
                        ? _buildSecondary(state.currentSecondary!)
                        : IndexedStack(
                            index: state.tabIndex,
                            children: _tabScreens,
                          ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: state.hasSecondary ? -1 : state.tabIndex,
              onTap: (index) => context.read<ShellCubit>().selectTab(index),
            ),
          );
        },
      ),
    );
  }
}
