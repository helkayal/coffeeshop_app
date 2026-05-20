import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String variant;
  final String price;
  final int quantity;

  const CartItem({
    super.key,
    required this.imagePath,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 96, height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: cs.surfaceContainerHighest,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(imagePath, fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: cs.surfaceContainerHighest)),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(name, style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
                ),
                Text(price, style: tt.bodyLarge?.copyWith(fontSize: 18, color: cs.primary, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 4),
            Text(variant, style: tt.bodySmall),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: cs.surfaceContainerLowest,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.remove, size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 16),
                Text('$quantity', style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
                const SizedBox(width: 16),
                Icon(Icons.add, size: 18, color: cs.onSurfaceVariant),
              ]),
            ),
          ],
        ),
      ),
    ]);
  }
}
