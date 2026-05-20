import 'package:flutter/material.dart';

class SliderSection extends StatefulWidget {
  final String title;
  final int steps;
  final List<String> labels;
  final int initial;

  const SliderSection({super.key, required this.title, required this.steps, required this.labels, required this.initial});

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(widget.title, style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
      ),
      SliderTheme(
        data: SliderThemeData(
          trackHeight: 4,
          activeTrackColor: cs.primary,
          inactiveTrackColor: cs.surfaceContainerHighest,
          thumbColor: cs.primary,
          overlayColor: cs.primary.withAlpha(51),
        ),
        child: Slider(
          min: 0,
          max: (widget.steps - 1).toDouble(),
          divisions: widget.steps - 1,
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.steps, (i) {
            final isSelected = i == _value.round();
            return Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(widget.labels[i],
                    style: tt.bodySmall?.copyWith(
                        color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
              ),
            );
          })),
    ]);
  }
}
