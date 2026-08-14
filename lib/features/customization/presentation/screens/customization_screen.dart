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
  final bool fromFavorites;

  const CustomizationScreen({
    super.key,
    this.product,
    this.fromFavorites = false,
  });

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  final Map<String, OptionValue> _picked = {};
  final Map<String, List<OptionValue>> _toggled = {};
  final Map<String, String> _savedPickedIds = {};
  final Map<String, List<String>> _savedToggledIds = {};
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

    for (final e in _picked.entries) {
      _savedPickedIds[e.key] = e.value.id;
    }
    for (final e in _toggled.entries) {
      final ids = e.value.map((v) => v.id).toList()..sort();
      _savedToggledIds[e.key] = ids;
    }

    // Register back-navigation guard — only when opened from Favorites.
    if (widget.fromFavorites) {
      sl<ShellCubit>().onWillPopSecondary = _handleWillPop;
    }
  }

  @override
  void dispose() {
    if (sl.isRegistered<ShellCubit>() &&
        sl<ShellCubit>().onWillPopSecondary == _handleWillPop) {
      sl<ShellCubit>().onWillPopSecondary = null;
    }
    super.dispose();
  }

  Future<bool> _handleWillPop() async {
    if (widget.fromFavorites && _hasCustomizationChanged()) {
      final update = await _showUpdateFavoriteDialog();
      if (update == null) return false;
      if (update == true) {
        _saveFavoriteSelections();
      }
    }
    return true;
  }

  bool _hasCustomizationChanged() {
    for (final e in _picked.entries) {
      if (_savedPickedIds[e.key] != e.value.id) return true;
    }
    for (final e in _toggled.entries) {
      final currentIds = e.value.map((v) => v.id).toList()..sort();
      final savedIds = _savedToggledIds[e.key] ?? [];
      if (currentIds.length != savedIds.length) return true;
      for (int i = 0; i < currentIds.length; i++) {
        if (currentIds[i] != savedIds[i]) return true;
      }
    }
    return false;
  }

  Future<bool?> _showUpdateFavoriteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('customization.update_favorite_title'.tr()),
        content: Text('customization.update_favorite_msg'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('customization.discard'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('customization.save_updates'.tr()),
          ),
        ],
      ),
    );
  }

  void _saveFavoriteSelections() {
    final product = _product;
    if (product == null) return;
    final picked = <String, String>{};
    for (final e in _picked.entries) {
      picked[e.key] = e.value.id;
      _savedPickedIds[e.key] = e.value.id;
    }
    final toggled = <String, List<String>>{};
    for (final e in _toggled.entries) {
      final ids = e.value.map((v) => v.id).toList();
      toggled[e.key] = ids;
      _savedToggledIds[e.key] = List.from(ids)..sort();
    }
    sl<LocalStorageService>().saveFavoriteSelections(product.id, {
      'picked': picked,
      'toggled': toggled,
    });
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

  Future<void> _addToCart() async {
    final product = _product;
    if (product == null) return;

    if (widget.fromFavorites && _hasCustomizationChanged()) {
      final update = await _showUpdateFavoriteDialog();
      if (update == null) return;
      if (update == true) _saveFavoriteSelections();
    }

    if (!mounted) return;
    final cartCubit = context.read<CartCubit>();

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
      // Clear guard so popSecondary doesn't re-trigger dialog.
      sl<ShellCubit>().onWillPopSecondary = null;
      context.read<ShellCubit>().popSecondary();
    }
  }

  Future<void> _toggleFavorite() async {
    final product = _product;
    if (product == null) return;
    final cubit = context.read<FavoritesCubit>();
    final storage = sl<LocalStorageService>();

    final favState = cubit.state;
    final isFav =
        favState is FavoritesLoaded && favState.isFavorite(product.id);

    if (isFav) {
      if (_hasCustomizationChanged()) {
        final update = await _showUpdateFavoriteDialog();
        if (update == true) {
          _saveFavoriteSelections();
        } else {
          cubit.toggle(product.id);
          storage.clearFavoriteSelections(product.id);
        }
      } else {
        cubit.toggle(product.id);
        storage.clearFavoriteSelections(product.id);
      }
    } else {
      cubit.toggle(product.id);
      _saveFavoriteSelections();
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
