import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant.withAlpha(77))),
        ),
        child: Row(children: [
          Icon(icon, size: 22, color: cs.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: tt.bodyMedium?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle, style: tt.bodySmall),
            ]),
          ),
          Icon(Icons.chevron_right, color: cs.outlineVariant, size: 20),
        ]),
      ),
    );
  }
}
