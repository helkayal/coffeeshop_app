import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        'menu'.tr(),
        style: TextStyle(color: cs.primary, fontSize: 18),
      ),
    );
  }
}
