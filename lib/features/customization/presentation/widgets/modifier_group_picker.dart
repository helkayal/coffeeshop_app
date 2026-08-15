import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../menu/domain/entities/option_group.dart';
import '../../../menu/domain/entities/option_value.dart';
import 'modifier_icon.dart';

class ModifierGroupPicker extends StatefulWidget {
  final OptionGroup group;
  final void Function(OptionValue selected) onChanged;
  final int initialIndex;

  const ModifierGroupPicker({
    super.key,
    required this.group,
    required this.onChanged,
    this.initialIndex = 0,
  });

  @override
  State<ModifierGroupPicker> createState() => _ModifierGroupPickerState();
}

class _ModifierGroupPickerState extends State<ModifierGroupPicker> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.group.values.isNotEmpty) {
      _selectedIndex = widget.initialIndex.clamp(
        0,
        widget.group.values.length - 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final groupIcon = modifierGroupIcon(widget.group.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(groupIcon, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                widget.group.name,
                style: tt.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: cs.onSurface,
                ),
              ),
              if (widget.group.required) ...[
                const SizedBox(width: 8),
                Text(
                  'customization.required'.tr(),
                  style: tt.labelLarge?.copyWith(
                    fontSize: 10,
                    color: cs.primary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(widget.group.values.length, (i) {
              final option = widget.group.values[i];
              final selected = i == _selectedIndex;
              return _OptionCircle(
                option: option,
                isSelected: selected,
                onTap: () {
                  setState(() => _selectedIndex = i);
                  widget.onChanged(option);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OptionCircle extends StatelessWidget {
  final OptionValue option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCircle({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final icon = modifierOptionIcon(option.name);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? cs.primary.withAlpha(26)
                  : cs.surfaceContainerHighest,
              border: Border.all(
                color: isSelected ? cs.primary : cs.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color: isSelected ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            option.name,
            style: tt.bodySmall?.copyWith(
              color: isSelected ? cs.primary : cs.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            option.priceModifier == 0.0
                ? 'Included'
                : 'common.price'.tr(
                    namedArgs: {
                      'amount': '+${option.priceModifier.toStringAsFixed(2)}',
                    },
                  ),
            style: tt.bodySmall?.copyWith(
              fontSize: 11,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
