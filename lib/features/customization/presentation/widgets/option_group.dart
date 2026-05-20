import 'package:flutter/material.dart';

import 'option_circle.dart';

class OptionData {
  final String name;
  final String priceLabel;
  final IconData icon;

  const OptionData(this.name, this.priceLabel, this.icon);
}

class OptionGroup extends StatefulWidget {
  final String title;
  final String requiredLabel;
  final List<OptionData> options;

  const OptionGroup({
    super.key,
    required this.title,
    required this.requiredLabel,
    required this.options,
  });

  @override
  State<OptionGroup> createState() => _OptionGroupState();
}

class _OptionGroupState extends State<OptionGroup> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.title, style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
          Text(widget.requiredLabel,
              style: tt.labelLarge?.copyWith(fontSize: 10, color: cs.onSurfaceVariant, letterSpacing: 2)),
        ]),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.options.length, (i) {
          return OptionCircle(
            data: widget.options[i],
            isSelected: i == _selectedIndex,
            onTap: () => setState(() => _selectedIndex = i),
          );
        }),
      ),
    ]);
  }
}
