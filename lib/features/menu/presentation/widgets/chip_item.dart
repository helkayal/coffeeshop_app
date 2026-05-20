import 'package:flutter/material.dart';

class ChipItem extends StatelessWidget {
  final String label;
  final String? imagePath;
  final bool isSelected;
  final VoidCallback? onTap;

  const ChipItem({
    super.key,
    required this.label,
    this.imagePath,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: cs.outlineVariant),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surfaceContainerHighest,
            ),
            clipBehavior: Clip.antiAlias,
            child: imagePath != null
                ? Image.asset(imagePath!, fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(Icons.category, size: 20, color: cs.onSurfaceVariant))
                : Icon(Icons.grid_view_rounded, size: 20, color: cs.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          Text(label, style: tt.labelLarge?.copyWith(
              color: isSelected ? cs.onPrimary : cs.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
