import 'package:flutter/material.dart';

/// Returns a Material icon appropriate for the modifier group name.
IconData modifierGroupIcon(String groupName) {
  final lower = groupName.toLowerCase();
  if (lower.contains('milk')) return Icons.water_drop_outlined;
  if (lower.contains('size')) return Icons.straighten_outlined;
  if (lower.contains('temperature')) return Icons.thermostat_outlined;
  if (lower.contains('espresso') || lower.contains('shot')) return Icons.coffee_outlined;
  if (lower.contains('sweet')) return Icons.emoji_nature_outlined;
  if (lower.contains('bread')) return Icons.bakery_dining_outlined;
  if (lower.contains('egg')) return Icons.egg_outlined;
  if (lower.contains('toast')) return Icons.breakfast_dining_outlined;
  if (lower.contains('add-on') || lower.contains('extra')) return Icons.add_circle_outline;
  return Icons.tune;
}

/// Returns a Material icon for an individual option name.
IconData modifierOptionIcon(String optionName) {
  final lower = optionName.toLowerCase();
  if (lower.contains('oat')) return Icons.eco_outlined;
  if (lower.contains('almond')) return Icons.spa_outlined;
  if (lower.contains('whole') || lower.contains('milk')) return Icons.water_drop_outlined;
  if (lower.contains('decaf')) return Icons.nights_stay_outlined;
  if (lower.contains('double') || lower.contains('triple')) return Icons.flash_on_outlined;
  if (lower.contains('single')) return Icons.coffee_outlined;
  if (lower.contains('large') || lower.contains('medium')) return Icons.height;
  if (lower.contains('small') || lower.contains('regular')) return Icons.straighten_outlined;
  if (lower.contains('hot')) return Icons.local_fire_department_outlined;
  if (lower.contains('iced') || lower.contains('cold')) return Icons.ac_unit_outlined;
  if (lower.contains('sourdough') || lower.contains('gluten')) return Icons.bakery_dining_outlined;
  if (lower.contains('poached') || lower.contains('scrambled')) return Icons.egg_outlined;
  if (lower.contains('plain')) return Icons.breakfast_dining_outlined;
  if (lower.contains('warmed')) return Icons.whatshot_outlined;
  if (lower.contains('honey') || lower.contains('agave')) return Icons.emoji_nature_outlined;
  if (lower.contains('vanilla') || lower.contains('syrup')) return Icons.local_cafe_outlined;
  if (lower.contains('caramel')) return Icons.emoji_nature_outlined;
  if (lower.contains('cinnamon') || lower.contains('pumpkin')) return Icons.scatter_plot_outlined;
  if (lower.contains('lavender') || lower.contains('rose') || lower.contains('mint')) return Icons.local_florist_outlined;
  if (lower.contains('avocado') || lower.contains('salmon') || lower.contains('extra')) return Icons.add_outlined;
  if (lower.contains('sugar') || lower.contains('salt') || lower.contains('cream')) return Icons.grain_outlined;
  if (lower.contains('coconut') || lower.contains('lemonade') || lower.contains('orange')) return Icons.local_drink_outlined;
  return Icons.tune;
}
