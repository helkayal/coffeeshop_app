import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../cubit/home_cubit.dart';
import '../../../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../../../features/menu/presentation/cubit/menu_cubit.dart';
import '../../../../features/menu/presentation/screens/menu_screen.dart';
import '../../../../features/orders/presentation/screens/orders_screen.dart';
import '../../../../features/profile/presentation/screens/profile_screen.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => sl<MenuCubit>()),
      ],
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  AppAppBar(
                    title: 'app_name'.tr(),
                    actions: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ],
                  ),
                  Expanded(child: _bodyFor(currentIndex)),
                ],
              ),
            ),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) => context.read<HomeCubit>().selectTab(index),
            ),
          );
        },
      ),
    );
  }
}
