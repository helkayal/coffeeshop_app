import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_state.dart';
import '../widgets/category_chips.dart';
import '../widgets/menu_header.dart';
import '../widgets/product_list_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    // The cubit guards against redundant calls when data is already loaded.
    context.read<MenuCubit>().loadMenu();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) => switch (state) {
        MenuLoading() => const Center(child: CircularProgressIndicator()),
        MenuError(message: final msg) => Center(
          child: Text(msg, style: TextStyle(color: cs.onSurface)),
        ),
        MenuLoaded(
          products: final products,
          categories: final categories,
          selectedCategoryId: final selectedId,
        ) =>
          _buildLoaded(products, categories, selectedId),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildLoaded(
    List<Product> products,
    List<Category> categories,
    String? selectedId,
  ) {
    final isTablet = context.isTablet;

    final header = <Widget>[
      const MenuHeader(),
      AppSpacing.v24,
      CategoryChips(
        categories: categories,
        selectedId: selectedId,
        onSelected: (id) => context.read<MenuCubit>().selectCategory(id),
      ),
      AppSpacing.v24,
    ];

    if (isTablet) {
      // 2-column grid on tablet — more efficient use of horizontal space.
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: AppInsets.screenTop16Bottom0,
            sliver: SliverList(
              delegate: SliverChildListDelegate(header),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: AppSpacing.s16,
              right: AppSpacing.s16,
              bottom: AppSpacing.s96,
            ),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.s16,
                mainAxisSpacing: AppSpacing.s16,
                mainAxisExtent: 195,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) => ProductListItem(product: products[i]),
            ),
          ),
        ],
      );
    }

    // Single-column list on phone — unchanged.
    return SingleChildScrollView(
      padding: AppInsets.screenTop16Bottom0,
      child: Column(
        children: [
          ...header,
          for (final p in products)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s16),
              child: ProductListItem(product: p),
            ),
          AppSpacing.v96,
        ],
      ),
    );
  }
}
