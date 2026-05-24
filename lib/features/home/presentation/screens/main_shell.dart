import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_config.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/routes/shell_router.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../features/checkout/presentation/cubit/cart_cubit.dart';
import '../../../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../../account/presentation/cubit/profile_cubit.dart';
import '../../../account/presentation/screens/account_screen.dart';
import '../../../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../../../features/menu/presentation/screens/menu_screen.dart';
import 'home_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _tabScreens = [
    HomeScreen(),
    MenuScreen(),
    FavoritesScreen(),
    AccountScreen(),
  ];

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
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  AppAppBar(
                    title: AppConfig.appName,
                    // Show back on every secondary screen EXCEPT OrderConfirmation
                    // (the user must not return to the Payment screen after placing an order).
                    leading: state.hasSecondary &&
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
                    child: Stack(
                      children: [
                        // Tab screens stay alive at all times.
                        // IndexedStack is never unmounted when a secondary opens —
                        // this is why taps always register immediately on return.
                        IndexedStack(
                          index: state.tabIndex,
                          children: _tabScreens,
                        ),
                        // Secondary screen overlays the tabs with an opaque
                        // Material surface. Material absorbs all touch events
                        // so the (invisible) tab widgets cannot be triggered.
                        if (state.hasSecondary)
                          Material(
                            color: Theme.of(context).colorScheme.surface,
                            child: ShellRouter.build(state.currentSecondary!),
                          ),
                      ],
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
