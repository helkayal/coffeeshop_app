import 'package:flutter/material.dart';

import 'option_circle.dart';

class OptionData {
  final String name;
  final String priceLabel;
  final IconData icon;
  final bool selected;

  const OptionData(this.name, this.priceLabel, this.icon, [this.selected = false]);
}

class OptionGroup extends StatelessWidget {
  final String title;
  final String requiredLabel;
  final List<OptionData> options;

  const OptionGroup({super.key, required this.title, required this.requiredLabel, required this.options});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
          Text(requiredLabel, style: tt.labelLarge?.copyWith(fontSize: 10, color: cs.onSurfaceVariant, letterSpacing: 2)),
        ]),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: options.map((o) => OptionCircle(data: o)).toList()),
    ]);
  }
}
