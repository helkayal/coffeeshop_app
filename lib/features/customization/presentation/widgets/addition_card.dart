import 'package:flutter/material.dart';

class AdditionCard extends StatefulWidget {
  final String name;
  final String price;
  final IconData icon;

  const AdditionCard({super.key, required this.name, required this.price, required this.icon});

  @override
  State<AdditionCard> createState() => _AdditionCardState();
}

class _AdditionCardState extends State<AdditionCard> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _selected ? cs.surfaceContainer : cs.surfaceContainerLow.withAlpha(128),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: _selected ? cs.primary : cs.outlineVariant.withAlpha(102)),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surfaceContainerHighest,
            ),
            child: Icon(widget.icon, size: 20, color: cs.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(widget.name,
                style: tt.labelLarge?.copyWith(
                    fontSize: 14, color: cs.onSurface)),
          ),
          Text(widget.price, style: tt.bodySmall),
        ]),
      ),
    );
  }
}
