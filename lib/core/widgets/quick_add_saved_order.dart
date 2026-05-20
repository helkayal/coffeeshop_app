import 'package:flutter/material.dart';

class QuickAddSavedOrder extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;

  const QuickAddSavedOrder({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withAlpha(51)),
      ),
      child: Row(children: [
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cs.surfaceContainerHighest,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(imagePath, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: cs.surfaceContainerHighest)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: tt.headlineMedium?.copyWith(fontSize: 18, color: cs.primary)),
            const SizedBox(height: 4),
            Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: tt.bodySmall),
          ]),
        ),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: cs.primary, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: cs.primary.withAlpha(51), blurRadius: 12)],
          ),
          child: IconButton(
            padding: EdgeInsets.zero, iconSize: 20, onPressed: () {},
            icon: Icon(Icons.add_shopping_cart, color: cs.onPrimary),
          ),
        ),
      ]),
    );
  }
}
