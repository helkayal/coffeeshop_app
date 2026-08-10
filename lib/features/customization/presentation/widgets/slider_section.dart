import 'package:flutter/material.dart';

import '../../../menu/domain/entities/option_group.dart';
import '../../../menu/domain/entities/option_value.dart';

class SliderSection extends StatefulWidget {
  final OptionGroup group;
  final void Function(OptionValue selected) onChanged;
  final int initialIndex;

  const SliderSection({
    super.key,
    required this.group,
    required this.onChanged,
    this.initialIndex = 0,
  });

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, widget.group.values.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final values = widget.group.values;
    final steps = values.length;

    if (steps < 2) {
      // Fallback: if only one option, show as a simple selected text.
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Text(widget.group.name,
                style: tt.headlineMedium?.copyWith(fontSize: 18, color: cs.onSurface)),
            const Spacer(),
            Text(values.first.name,
                style: tt.bodyMedium?.copyWith(color: cs.primary)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.group.name,
              style: tt.headlineMedium?.copyWith(fontSize: 18, color: cs.onSurface)),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: cs.primary,
              inactiveTrackColor: cs.surfaceContainerHighest,
              thumbColor: cs.primary,
              overlayColor: cs.primary.withAlpha(51),
              tickMarkShape: const RoundSliderTickMarkShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _selectedIndex.toDouble(),
              min: 0,
              max: (steps - 1).toDouble(),
              divisions: steps - 1,
              onChanged: (v) {
                setState(() => _selectedIndex = v.round());
                widget.onChanged(values[_selectedIndex]);
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps, (i) {
              final selected = i == _selectedIndex;
              final priceText = values[i].priceModifier == 0.0
                  ? 'Included'
                  : '+${values[i].priceModifier.toStringAsFixed(2)} EGP';
              return Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        values[i].name,
                        style: tt.labelLarge?.copyWith(
                          color: selected ? cs.primary : cs.onSurfaceVariant,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        priceText,
                        style: tt.bodySmall?.copyWith(
                          color: selected ? cs.primary : cs.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
