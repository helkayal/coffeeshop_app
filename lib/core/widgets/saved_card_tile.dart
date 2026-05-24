import 'package:flutter/material.dart';

class SavedCardTile extends StatelessWidget {
  final String mask;
  final String expiry;
  final bool isDefault;
  final VoidCallback? onTap;

  const SavedCardTile({
    super.key,
    required this.mask,
    required this.expiry,
    this.isDefault = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant.withAlpha(77)),
        ),
        child: Row(children: [
          Icon(Icons.credit_card, color: cs.primary, size: 24),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(mask, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
            Text(expiry, style: tt.bodySmall),
          ]),
          const Spacer(),
          if (isDefault) Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: cs.primary.withAlpha(26), borderRadius: BorderRadius.circular(6)),
            child: Text('Default', style: tt.bodySmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          Icon(isDefault ? Icons.check_circle : Icons.radio_button_unchecked, color: isDefault ? cs.primary : cs.onSurfaceVariant, size: 20),
        ]),
      ),
    );
  }
}
