import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          'menu_screen.our_menu'.tr(),
          style: const TextStyle(
            fontFamily: 'EB Garamond',
            fontSize: 36,
            color: Color(0xFFECE0D6),
          ),
        ),
        const SizedBox(height: 16),
        Container(width: 48, height: 1, color: cs.primary.withAlpha(77)),
      ],
    );
  }
}
