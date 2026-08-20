import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A side [NavigationRail] for tablet layouts, styled to match
/// [AppBottomNavBar] (glassmorphism surface, primary-tinted active state).
class AppNavRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavRail({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface.withAlpha(242),
            border: Border(
              right: BorderSide(
                color: cs.outlineVariant.withAlpha(153),
                width: 1,
              ),
            ),
          ),
          child: NavigationRail(
            selectedIndex: currentIndex < 0 ? null : currentIndex,
            onDestinationSelected: onTap,
            backgroundColor: Colors.transparent,
            useIndicator: true,
            indicatorColor: cs.primary.withAlpha(26),
            selectedIconTheme: IconThemeData(color: cs.primary, size: 28),
            unselectedIconTheme: IconThemeData(color: cs.onSurfaceVariant, size: 28),
            selectedLabelTextStyle: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelTextStyle: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 13,
            ),
            labelType: NavigationRailLabelType.all,
            minWidth: 88,
            groupAlignment: 0,
            leading: AppSpacing.v16,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: Text('home'.tr()),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.coffee_outlined),
                selectedIcon: const Icon(Icons.coffee),
                label: Text('menu'.tr()),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.favorite_outline),
                selectedIcon: const Icon(Icons.favorite),
                label: Text('favorite'.tr()),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: Text('account'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
