import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_config.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../features/checkout/presentation/screens/cart_screen.dart';
import '../../../../features/checkout/presentation/screens/payment_screen.dart';
import '../../../../features/customization/presentation/screens/customization_screen.dart';
import '../../../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../../../features/menu/presentation/screens/menu_screen.dart';
import '../../../../features/orders/presentation/screens/orders_screen.dart';
import '../../../../features/profile/presentation/screens/account_screen.dart';
import '../../../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../../../features/settings/presentation/screens/settings_screen.dart';
import '../cubit/home_cubit.dart';
import 'home_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _tabScreens = [
    HomeScreen(),
    MenuScreen(),
    OrdersScreen(),
    FavoritesScreen(),
    AccountScreen(),
  ];

  static Widget _buildSecondary(SecondaryRoute route) => switch (route) {
    CartRoute() => const CartScreen(),
    PaymentRoute() => const PaymentScreen(),
    CustomizationRoute() => const CustomizationScreen(),
    SettingsRoute() => const SettingsScreen(),
    EditProfileRoute() => const EditProfileScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MenuCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (prev, curr) =>
            prev.tabIndex != curr.tabIndex ||
            prev.hasSecondary != curr.hasSecondary ||
            prev.secondaryStack.length != curr.secondaryStack.length,
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(children: [
                AppAppBar(
                  title: AppConfig.appName,
                  leading: state.hasSecondary
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.read<HomeCubit>().popSecondary(),
                        )
                      : null,
                  actions: [
                    if (!state.hasSecondary && state.tabIndex == 4)
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.read<HomeCubit>().pushSecondary(const SettingsRoute()),
                        icon: const Icon(Icons.settings_outlined),
                      ),
                    if (state.currentSecondary is! CartRoute)
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.read<HomeCubit>().pushSecondary(const CartRoute()),
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
              ]),
            ),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: state.hasSecondary ? -1 : state.tabIndex,
              onTap: (index) => context.read<HomeCubit>().selectTab(index),
            ),
          );
        },
      ),
    );
  }
}
