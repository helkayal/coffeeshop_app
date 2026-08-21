import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../../menu/domain/entities/option_group.dart';
import '../../../menu/domain/entities/product.dart';
import '../cubit/customization_cubit.dart';
import '../cubit/customization_state.dart';
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
  late final ShellCubit _shellCubit;

  Product? get _product => widget.product;

  @override
  void initState() {
    super.initState();
    _shellCubit = context.read<ShellCubit>();
    final product = _product;
    if (product != null) {
      context.read<CustomizationCubit>().startBuilder(product);
    }
    if (widget.fromFavorites) {
      _shellCubit.onWillPopSecondary = _handleWillPop;
    }
  }

  @override
  void dispose() {
    if (_shellCubit.onWillPopSecondary == _handleWillPop) {
      _shellCubit.onWillPopSecondary = null;
    }
    super.dispose();
  }

  Future<bool> _handleWillPop() async {
    final state = context.read<CustomizationCubit>().state;
    if (widget.fromFavorites &&
        state is CustomizationBuilder &&
        state.hasChanged) {
      final update = await _showUpdateFavoriteDialog();
      if (update == null) return false;
      if (update == true) {
        final product = _product;
        if (product != null && mounted) {
          await context.read<CustomizationCubit>().saveSelections(product.id);
        }
      }
    }
    return true;
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

  Future<void> _addToCart(CustomizationBuilder state) async {
    final product = _product;
    if (product == null) return;

    if (widget.fromFavorites && state.hasChanged) {
      final update = await _showUpdateFavoriteDialog();
      if (update == null) return;
      if (update == true && mounted) {
        await context.read<CustomizationCubit>().saveSelections(product.id);
      }
    }

    if (!mounted) return;
    context.read<CartCubit>().addItem(state.buildCartItem());
    if (context.mounted) {
      _shellCubit.onWillPopSecondary = null;
      _shellCubit.popSecondary();
    }
  }

  Future<void> _toggleFavorite(CustomizationBuilder state) async {
    final product = _product;
    if (product == null) return;
    final favoritesCubit = context.read<FavoritesCubit>();
    final customizationCubit = context.read<CustomizationCubit>();

    final favState = favoritesCubit.state;
    final isFav =
        favState is FavoritesLoaded && favState.isFavorite(product.id);

    if (isFav) {
      if (state.hasChanged) {
        final update = await _showUpdateFavoriteDialog();
        if (update == true) {
          await customizationCubit.saveSelections(product.id);
        } else {
          favoritesCubit.toggle(product.id);
          await customizationCubit.clear(product.id);
        }
      } else {
        favoritesCubit.toggle(product.id);
        await customizationCubit.clear(product.id);
      }
    } else {
      favoritesCubit.toggle(product.id);
      await customizationCubit.saveSelections(product.id);
    }
  }

  int _singleIndex(CustomizationBuilder state, OptionGroup group) {
    final picked = state.picked[group.id];
    if (picked == null) return 0;
    return group.values.indexOf(picked).clamp(0, group.values.length - 1);
  }

  Set<int> _multiIndices(CustomizationBuilder state, OptionGroup group) {
    final selected = state.toggled[group.id] ?? const [];
    final indices = <int>{};
    for (final value in selected) {
      final index = group.values.indexOf(value);
      if (index >= 0) indices.add(index);
    }
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final product = _product;

    if (product == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        body: Center(child: Text('verification.product_not_available'.tr())),
      );
    }

    return BlocBuilder<CustomizationCubit, CustomizationState>(
      builder: (context, state) => switch (state) {
        CustomizationBuilder() => _buildContent(cs, state),
        CustomizationError(:final failureCode) => Scaffold(
          backgroundColor: cs.surface,
          body: Center(
            child: Text(
              failureCode.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.error,
              ),
            ),
          ),
        ),
        _ => Scaffold(
          backgroundColor: cs.surface,
          body: const Center(child: CircularProgressIndicator()),
        ),
      },
    );
  }

  Widget _buildContent(ColorScheme cs, CustomizationBuilder state) {
    final cubit = context.read<CustomizationCubit>();
    final product = state.product;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: AppInsets.b120,
            child: Column(
              children: [
                _buildHero(cs, product),
                ...state.sortedGroups.map((group) {
                  if (group.isMulti) {
                    return ModifierGroupToggles(
                      group: group,
                      initialSelected: _multiIndices(state, group),
                      onChanged: (v) => cubit.selectMulti(group, v),
                    );
                  }
                  if (group.isSlider) {
                    return SliderSection(
                      group: group,
                      initialIndex: _singleIndex(state, group),
                      onChanged: (v) => cubit.selectSingle(group, v),
                    );
                  }
                  return ModifierGroupPicker(
                    group: group,
                    initialIndex: _singleIndex(state, group),
                    onChanged: (v) => cubit.selectSingle(group, v),
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
                final isFav =
                    favState is FavoritesLoaded &&
                    favState.isFavorite(product.id);
                return BottomActionBar(
                  total: 'common.price'.tr(
                    namedArgs: {'amount': state.total.toStringAsFixed(2)},
                  ),
                  isFavorite: isFav,
                  onFavorite: () => _toggleFavorite(state),
                  onComplete: () => _addToCart(state),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(ColorScheme cs, Product product) {
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
            start: AppSpacing.s24,
            bottom: AppSpacing.s24,
            end: AppSpacing.s24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.display(
                    weight: FontWeight.w400,
                    color: cs.onSurface,
                  ).copyWith(height: 1.3),
                ),
                AppSpacing.v4,
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
