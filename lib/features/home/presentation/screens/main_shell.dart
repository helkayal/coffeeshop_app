import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/routes/shell_router.dart';
import '../../../../core/services/network_info_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/connection_error_view.dart';
import '../../../../features/checkout/presentation/cubit/cart_cubit.dart';
import '../../../../features/checkout/presentation/cubit/cart_state.dart';
import '../../../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../../account/presentation/cubit/payment_methods_cubit.dart';
import '../../../account/presentation/cubit/profile_cubit.dart';
import '../../../account/presentation/cubit/referral_cubit.dart';
import '../../../account/presentation/cubit/wallet_cubit.dart';
import '../../../account/presentation/screens/account_screen.dart';
import '../../../promotions/presentation/cubit/promotions_cubit.dart';
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
        BlocProvider.value(value: sl<ConnectivityCubit>()),
        BlocProvider(
          create: (_) => sl<PromotionsCubit>()..loadPromotions(),
        ),
        BlocProvider(create: (_) => sl<MenuCubit>()..loadMenu()),
        BlocProvider(create: (_) => sl<CartCubit>()..loadCart()),
        BlocProvider(create: (_) => sl<OrdersCubit>()..loadOrders()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..loadFavorites()),
        BlocProvider(create: (_) => sl<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (_) => sl<WalletCubit>()),
        BlocProvider(create: (_) => sl<PaymentMethodsCubit>()),
        BlocProvider(create: (_) => sl<ReferralCubit>()),
      ],
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (context, state) {
          if (state is ConnectivityOnline) {
            _reloadAll(context);
          }
        },
        child: BlocBuilder<ShellCubit, ShellState>(
          builder: (context, shellState) {
            return Stack(
              children: [
                Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        AppAppBar(
                          title: 'app_name'.tr(),
                          leading: shellState.hasSecondary &&
                                  shellState.currentSecondary
                                      is! OrderConfirmationRoute
                              ? IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => context
                                      .read<ShellCubit>()
                                      .popSecondaryWithCheck(),
                                )
                              : null,
                          actions: [
                            if (!shellState.hasSecondary &&
                                shellState.tabIndex == 3)
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => context
                                    .read<ShellCubit>()
                                    .pushSecondary(const SettingsRoute()),
                                icon: const Icon(Icons.settings_outlined),
                              ),
                            if (!shellState.hasSecondary)
                              BlocBuilder<CartCubit, CartState>(
                                builder: (_, cartState) {
                                  final count = switch (cartState) {
                                    CartLoaded(:final cart) => cart.itemCount,
                                    CartActionInProgress(:final cart) =>
                                      cart.itemCount,
                                    _ => 0,
                                  };
                                  return IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => context
                                        .read<ShellCubit>()
                                        .pushSecondary(const CartRoute()),
                                    icon: Badge(
                                      isLabelVisible: count > 0,
                                      label: Text('$count',
                                          style:
                                              const TextStyle(fontSize: 10)),
                                      child: const Icon(
                                          Icons.shopping_cart_outlined),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              IndexedStack(
                                index: shellState.tabIndex,
                                children: _tabScreens,
                              ),
                              if (shellState.hasSecondary)
                                Material(
                                  color:
                                      Theme.of(context).colorScheme.surface,
                                  child: ShellRouter.build(
                                      shellState.currentSecondary!),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: AppBottomNavBar(
                    currentIndex:
                        shellState.hasSecondary ? -1 : shellState.tabIndex,
                    onTap: (index) =>
                        context.read<ShellCubit>().selectTab(index),
                  ),
                ),
                // Full-screen offline overlay — covers Scaffold AND bottom nav.
                BlocBuilder<ConnectivityCubit, ConnectivityState>(
                  builder: (context, connState) {
                    if (connState is! ConnectivityOffline) {
                      return const SizedBox.shrink();
                    }
                    final message = connState.status ==
                            ConnectionStatus.noInternet
                        ? 'splash_screen.no_internet'.tr()
                        : 'splash_screen.server_error'.tr();
                    return ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: ConnectionErrorView(
                        message: message,
                        onRetry: () =>
                            context.read<ConnectivityCubit>().retry(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Re-fires all data loads when connectivity is restored.
  void _reloadAll(BuildContext context) {
    context.read<PromotionsCubit>().loadPromotions();
    context.read<MenuCubit>().reload();
    context.read<CartCubit>().loadCart();
    context.read<OrdersCubit>().loadOrders();
    context.read<FavoritesCubit>().loadFavorites();
    context.read<ProfileCubit>().loadProfile();
  }
}
