import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/category.dart';
import 'chip_item.dart';

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
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          if (index == 0) {
            return ChipItem(
              label: 'menu_screen.all'.tr(),
              isSelected: selectedId == null,
              onTap: () => onSelected(null),
            );
          }
          final category = categories[index - 1];
          final isSelected = category.id == selectedId;
          return ChipItem(
            label: category.name,
            isSelected: isSelected,
            onTap: () => onSelected(isSelected ? null : category.id),
          );
        },
      ),
    );
  }
}
