import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../checkout/domain/entities/cart_item.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../../menu/domain/entities/option_group.dart';
import '../../../menu/domain/entities/option_value.dart';
import '../../../menu/domain/entities/product.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/modifier_group_picker.dart';
import '../widgets/modifier_group_toggles.dart';
import '../widgets/slider_section.dart';

class CustomizationScreen extends StatefulWidget {
  final Product? product;
  const CustomizationScreen({super.key, this.product});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  final Map<String, OptionValue> _picked = {};
  final Map<String, List<OptionValue>> _toggled = {};
  double _total = 0;

  Product? get _product => widget.product;

  @override
  void initState() {
    super.initState();
    _total = _product?.basePrice ?? 0;
    final p = _product;
    if (p == null) return;

    final saved = sl<LocalStorageService>().getFavoriteSelections(p.id);

    for (final group in p.optionGroups) {
      if (_isMulti(group)) {
        final toggledMap = saved?['toggled'];
        final savedIds = (toggledMap is Map ? toggledMap[group.id] : null);
        if (savedIds is List) {
          final selected = <OptionValue>[];
          for (final v in group.values) {
            if (savedIds.contains(v.id)) {
              selected.add(v);
              _total += v.priceModifier;
            }
          }
          _toggled[group.id] = selected;
        }
      } else {
        final pickedMap = saved?['picked'];
        final savedId = (pickedMap is Map ? pickedMap[group.id] : null) as String?;
        OptionValue? opt;
        if (savedId != null) {
          opt = group.values.cast<OptionValue?>().firstWhere(
            (v) => v?.id == savedId,
            orElse: () => null,
          );
        }
        opt ??= (group.values.isNotEmpty ? group.values.first : null);
        if (opt != null) {
          _picked[group.id] = opt;
          _total += opt.priceModifier;
        }
      }
    }
  }

  bool _isMulti(OptionGroup group) {
    final name = group.name.toLowerCase();
    return name.contains('extra') || name.contains('add-on');
  }

  bool _isSlider(OptionGroup group) {
    final name = group.name.toLowerCase();
    return name.contains('temperature') ||
        name.contains('sweet') ||
        name.contains('size');
  }

  List<OptionGroup> _sortedGroups(List<OptionGroup> groups) {
    final multi = <OptionGroup>[];
    final rest = <OptionGroup>[];
    for (final g in groups) {
      (_isMulti(g) ? multi : rest).add(g);
    }
    return [...rest, ...multi];
  }

  void _onSingleChanged(OptionGroup group, OptionValue value) {
    final old = _picked[group.id];
    setState(() {
      if (old != null) _total -= old.priceModifier;
      _picked[group.id] = value;
      _total += value.priceModifier;
    });
  }

  void _onMultiChanged(OptionGroup group, List<OptionValue> values) {
    final old = _toggled[group.id] ?? [];
    setState(() {
      for (final v in old) {
        _total -= v.priceModifier;
      }
      for (final v in values) {
        _total += v.priceModifier;
      }
      _toggled[group.id] = values;
    });
  }

  void _addToCart() {
    final cartCubit = context.read<CartCubit>();
    final product = _product;
    if (product == null) return;

    final parts = <String>[];
    for (final g in _sortedGroups(product.optionGroups)) {
      if (_isMulti(g)) {
        for (final v in _toggled[g.id] ?? []) {
          parts.add(v.name);
        }
      } else {
        final picked = _picked[g.id];
        if (picked != null) parts.add(picked.name);
      }
    }

    final modifierIds = <String>[
      ..._picked.values.map((v) => v.id),
      ..._toggled.values.expand((list) => list.map((v) => v.id)),
    ];

    final item = CartItem(
      id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      name: product.name,
      imagePath: product.imagePath ?? '',
      variant: parts.join(' • '),
      unitPrice: _total,
      quantity: 1,
      modifierIds: modifierIds,
    );

    cartCubit.addItem(item);
    if (context.mounted) {
      context.read<ShellCubit>().popSecondary();
    }
  }

  void _toggleFavorite() {
    final product = _product;
    if (product == null) return;
    final cubit = context.read<FavoritesCubit>();
    final storage = sl<LocalStorageService>();

    // Check current favorite state from the cubit.
    final favState = cubit.state;
    final isFav = favState is FavoritesLoaded && favState.isFavorite(product.id);

    cubit.toggle(product.id);

    if (isFav) {
      // Unfavoriting — clear saved selections.
      storage.clearFavoriteSelections(product.id);
    } else {
      // Favoriting — save current selections.
      final picked = <String, String>{};
      for (final e in _picked.entries) {
        picked[e.key] = e.value.id;
      }
      final toggled = <String, List<String>>{};
      for (final e in _toggled.entries) {
        toggled[e.key] = e.value.map((v) => v.id).toList();
      }
      storage.saveFavoriteSelections(product.id, {
        'picked': picked,
        'toggled': toggled,
      });
    }
  }

  int _initialIndex(OptionGroup group) {
    final picked = _picked[group.id];
    if (picked == null) return 0;
    return group.values.indexOf(picked).clamp(0, group.values.length - 1);
  }

  Set<int> _initialToggleIndices(OptionGroup group) {
    final selected = _toggled[group.id] ?? [];
    final indices = <int>{};
    for (final v in selected) {
      final i = group.values.indexOf(v);
      if (i >= 0) indices.add(i);
    }
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final product = _product;

    if (product == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        body: Center(child: Text('verification.product_not_available'.tr())),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                _buildHero(cs, tt, product),
                // Multi-select groups (Extras, Add-Ons) go below the rest.
                ..._sortedGroups(product.optionGroups).map((group) {
                  if (_isMulti(group)) {
                    return ModifierGroupToggles(
                      group: group,
                      initialSelected: _initialToggleIndices(group),
                      onChanged: (v) => _onMultiChanged(group, v),
                    );
                  }
                  if (_isSlider(group)) {
                    return SliderSection(
                      group: group,
                      initialIndex: _initialIndex(group),
                      onChanged: (v) => _onSingleChanged(group, v),
                    );
                  }
                  return ModifierGroupPicker(
                    group: group,
                    initialIndex: _initialIndex(group),
                    onChanged: (v) => _onSingleChanged(group, v),
                  );
                }),
              ],
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, favState) {
                final isFav = favState is FavoritesLoaded &&
                    favState.isFavorite(product.id);
                return BottomActionBar(
                  total: '${_total.toStringAsFixed(2)} EGP',
                  isFavorite: isFav,
                  onFavorite: _toggleFavorite,
                  onComplete: _addToCart,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(ColorScheme cs, TextTheme tt, Product product) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: product.imagePath ?? '',
            fit: BoxFit.cover,
            errorWidget: (_, _, _) =>
                Container(color: cs.surfaceContainerHighest),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, cs.surface],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: 24,
            bottom: 24,
            end: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.name,
                    style: tt.headlineMedium?.copyWith(
                        fontSize: 36, color: cs.onSurface)),
                const SizedBox(height: 4),
                Text(product.description,
                    style:
                        tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
