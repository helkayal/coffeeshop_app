import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/settings_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader(cs, tt, 'settings.preferences'.tr()),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withAlpha(51)),
          ),
          child: Column(children: [
            SettingsRow(icon: Icons.palette, title: 'settings.appearance'.tr(), subtitle: 'settings.dark_mode'.tr()),
            SettingsRow(icon: Icons.language, title: 'settings.language'.tr(), subtitle: 'settings.english'.tr()),
            SettingsRow(icon: Icons.notifications, title: 'settings.notifications'.tr(), subtitle: 'settings.push_email'.tr()),
          ]),
        ),
        const SizedBox(height: 48),
        _sectionHeader(cs, tt, 'settings.support'.tr()),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withAlpha(51)),
          ),
          child: SettingsRow(icon: Icons.info, title: 'settings.about'.tr(), subtitle: 'settings.version'.tr()),
        ),
      ]),
    );
  }

  Widget _sectionHeader(ColorScheme cs, TextTheme tt, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(text, style: tt.labelLarge?.copyWith(fontSize: 10, color: cs.onSurfaceVariant, letterSpacing: 2)),
    );
  }
}
