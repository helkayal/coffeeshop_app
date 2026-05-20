import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_config.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../features/checkout/presentation/screens/cart_screen.dart';
import '../../../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../../../features/menu/presentation/screens/menu_screen.dart';
import '../../../../features/orders/presentation/screens/orders_screen.dart';
import '../../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../../features/settings/presentation/screens/settings_screen.dart';
import '../cubit/home_cubit.dart';
import 'home_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static Widget _bodyFor(int index) => switch (index) {
    0 => const HomeScreen(),
    1 => const MenuScreen(),
    2 => const OrdersScreen(),
    3 => const FavoritesScreen(),
    4 => const ProfileScreen(),
    _ => const HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MenuCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(
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
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => context.read<HomeCubit>().pushSecondary(const SettingsScreen()),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => context.read<HomeCubit>().pushSecondary(const CartScreen()),
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ],
                ),
                Expanded(
                  child: state.hasSecondary
                      ? state.currentSecondary!
                      : _bodyFor(state.tabIndex),
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
