import 'package:flutter/material.dart';

import '../../../menu/domain/entities/option_group.dart';
import '../../../menu/domain/entities/option_value.dart';
import 'modifier_icon.dart';

class ModifierGroupToggles extends StatefulWidget {
  final OptionGroup group;
  final void Function(List<OptionValue> selected) onChanged;
  final Set<int> initialSelected;

  const ModifierGroupToggles({
    super.key,
    required this.group,
    required this.onChanged,
    this.initialSelected = const {},
  });

  @override
  State<ModifierGroupToggles> createState() => _ModifierGroupTogglesState();
}

class _ModifierGroupTogglesState extends State<ModifierGroupToggles> {
  late final Set<int> _selectedIndices = Set.from(widget.initialSelected);

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
              Text(widget.group.name,
                  style: tt.headlineMedium?.copyWith(fontSize: 18, color: cs.onSurface)),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(widget.group.values.length, (i) {
            final option = widget.group.values[i];
            final selected = _selectedIndices.contains(i);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ToggleCard(
                option: option,
                isSelected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedIndices.remove(i);
                    } else {
                      _selectedIndices.add(i);
                    }
                  });
                  widget.onChanged(
                    _selectedIndices.map((idx) => widget.group.values[idx]).toList(),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final OptionValue option;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleCard({
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? cs.surfaceContainerHighest : cs.surfaceContainerLow.withAlpha(128),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant.withAlpha(102),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: cs.onSurfaceVariant),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(option.name,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
            ),
            Text(
              option.priceModifier == 0.0
                  ? 'Free'
                  : '+${option.priceModifier.toStringAsFixed(2)} EGP',
              style: tt.labelLarge?.copyWith(color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}
