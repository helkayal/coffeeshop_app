import 'package:flutter/material.dart';

IconData modifierGroupIcon(String groupName) {
  final name = groupName.toLowerCase();
  return switch (name) {
    _ when name.contains('milk') => Icons.water_drop_outlined,
    _ when name.contains('size') => Icons.straighten_outlined,
    _ when name.contains('temperature') => Icons.thermostat_outlined,
    _ when name.contains('espresso') || name.contains('shot') =>
      Icons.coffee_outlined,
    _ when name.contains('sweet') => Icons.emoji_nature_outlined,
    _ when name.contains('bread') => Icons.bakery_dining_outlined,
    _ when name.contains('egg') => Icons.egg_outlined,
    _ when name.contains('toast') => Icons.breakfast_dining_outlined,
    _ when name.contains('add-on') || name.contains('extra') =>
      Icons.add_circle_outline,
    _ => Icons.tune,
  };
}

IconData modifierOptionIcon(String optionName) {
  final name = optionName.toLowerCase();
  return switch (name) {
    _ when name.contains('oat') => Icons.eco_outlined,
    _ when name.contains('almond') => Icons.spa_outlined,
    _ when name.contains('whole') || name.contains('milk') =>
      Icons.water_drop_outlined,
    _ when name.contains('decaf') => Icons.nights_stay_outlined,
    _ when name.contains('double') || name.contains('triple') =>
      Icons.flash_on_outlined,
    _ when name.contains('single') => Icons.coffee_outlined,
    _ when name.contains('large') || name.contains('medium') => Icons.height,
    _ when name.contains('small') || name.contains('regular') =>
      Icons.straighten_outlined,
    _ when name.contains('hot') => Icons.local_fire_department_outlined,
    _ when name.contains('iced') || name.contains('cold') =>
      Icons.ac_unit_outlined,
    _ when name.contains('sourdough') || name.contains('gluten') =>
      Icons.bakery_dining_outlined,
    _ when name.contains('poached') || name.contains('scrambled') =>
      Icons.egg_outlined,
    _ when name.contains('plain') => Icons.breakfast_dining_outlined,
    _ when name.contains('warmed') => Icons.whatshot_outlined,
    _ when name.contains('honey') || name.contains('agave') =>
      Icons.emoji_nature_outlined,
    _ when name.contains('vanilla') || name.contains('syrup') =>
      Icons.local_cafe_outlined,
    _ when name.contains('caramel') => Icons.emoji_nature_outlined,
    _ when name.contains('cinnamon') || name.contains('pumpkin') =>
      Icons.scatter_plot_outlined,
    _
        when name.contains('lavender') ||
            name.contains('rose') ||
            name.contains('mint') =>
      Icons.local_florist_outlined,
    _
        when name.contains('avocado') ||
            name.contains('salmon') ||
            name.contains('extra') =>
      Icons.add_outlined,
    _
        when name.contains('sugar') ||
            name.contains('salt') ||
            name.contains('cream') =>
      Icons.grain_outlined,
    _
        when name.contains('coconut') ||
            name.contains('lemonade') ||
            name.contains('orange') =>
      Icons.local_drink_outlined,
    _ => Icons.tune,
  };
}
