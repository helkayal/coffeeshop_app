import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/category.dart';

class CategoryChips extends StatelessWidget {
  final List<Category> categories;
  final String? selectedId;
  final void Function(String? id) onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          if (index == 0) {
            return _buildChip(
              context,
              cs,
              tt,
              'menu_screen.all'.tr(),
              null,
              selectedId == null,
              onTap: () => onSelected(null),
            );
          }

          final category = categories[index - 1];
          final isSelected = category.id == selectedId;
          return _buildChip(
            context,
            cs,
            tt,
            category.name,
            category.imagePath,
            isSelected,
            onTap: () => onSelected(isSelected ? null : category.id),
          );
        },
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
    String label,
    String? imagePath,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? (() {}),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.surfaceContainerHighest,
              ),
              clipBehavior: Clip.antiAlias,
              child: imagePath != null
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.category,
                        size: 20,
                        color: cs.onSurfaceVariant,
                      ),
                    )
                  : Icon(
                      Icons.grid_view_rounded,
                      size: 20,
                      color: cs.onSurfaceVariant,
                    ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: tt.labelLarge?.copyWith(
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
