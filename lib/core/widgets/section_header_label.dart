import 'package:flutter/material.dart';

class SectionHeaderLabel extends StatelessWidget {
  final String text;

  const SectionHeaderLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(text, style: tt.labelLarge?.copyWith(color: cs.primary, fontSize: 10, letterSpacing: 2)),
    );
  }
}
