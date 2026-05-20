import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCheckbox;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCheckbox = false,
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
          border: Border.all(color: isSelected ? cs.primary.withAlpha(128) : cs.outlineVariant.withAlpha(77)),
        ),
        child: Row(children: [
          Icon(icon, size: 22, color: cs.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
          ),
          Icon(
            isCheckbox
                ? (isSelected ? Icons.check_box : Icons.check_box_outline_blank)
                : (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
            color: isSelected ? cs.primary : cs.onSurfaceVariant,
          ),
        ]),
      ),
    );
  }
}
