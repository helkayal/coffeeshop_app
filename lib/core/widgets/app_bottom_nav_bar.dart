import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_design_constants.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xF218120D),
            border: Border(
              top: BorderSide(color: Color(0x99514537), width: 1),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home, label: 'Home', isActive: currentIndex == 0, onTap: () => onTap(0)),
              _NavItem(icon: Icons.coffee, label: 'Menu', isActive: currentIndex == 1, onTap: () => onTap(1)),
              _NavItem(icon: Icons.receipt_long, label: 'Orders', isActive: currentIndex == 2, onTap: () => onTap(2)),
              _NavItem(icon: Icons.favorite, label: 'Favorite', isActive: currentIndex == 3, onTap: () => onTap(3)),
              _NavItem(icon: Icons.person, label: 'Profile', isActive: currentIndex == 4, onTap: () => onTap(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final color = isActive ? cs.primary : cs.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? cs.primary.withAlpha(26) : Colors.transparent,
          borderRadius: AppDesignConstants.radiusMedium,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 3),
            Text(label, style: tt.labelLarge?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
