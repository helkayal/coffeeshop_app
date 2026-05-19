import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../cubit/home_cubit.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

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
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  AppAppBar(
                    title: 'Coffee Shop',
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
