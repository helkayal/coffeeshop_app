import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class SectionHeaderLabel extends StatelessWidget {
  final String text;

  const SectionHeaderLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: AppTextStyles.labelMicro(color: cs.primary).copyWith(
          letterSpacing: 2,
          height: 1.0,
        ),
      ),
    );
  }
}
