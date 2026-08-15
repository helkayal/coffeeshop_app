import 'package:flutter/material.dart';

class QuickAddOptions extends StatelessWidget {
  final List<String> options;

  const QuickAddOptions({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh.withAlpha(128),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withAlpha(26)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...options.map(
            (option) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: cs.outlineVariant.withAlpha(77)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option,
                    style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.add_circle, size: 18, color: cs.primary),
                ],
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 16,
              onPressed: () {},
              icon: Icon(Icons.shopping_cart, color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}
