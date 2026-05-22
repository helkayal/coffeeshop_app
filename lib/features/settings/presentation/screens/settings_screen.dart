import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state is SettingsLoaded && state.isDarkMode;
        final cubit = context.read<SettingsCubit>();

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
                SettingsRow(
                  icon: Icons.palette,
                  title: 'settings.appearance'.tr(),
                  subtitle: isDark
                      ? 'settings.dark_mode'.tr()
                      : 'settings.light_mode'.tr(),
                  onTap: cubit.toggleDarkMode,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (_) => cubit.toggleDarkMode(),
                    activeThumbColor: cs.primary,
                  ),
                ),
                SettingsRow(
                  icon: Icons.language,
                  title: 'settings.language'.tr(),
                  subtitle: state is SettingsLoaded && state.locale == 'ar'
                      ? 'العربية'
                      : 'settings.english'.tr(),
                  onTap: () => _showLanguagePicker(context, cubit,
                      state is SettingsLoaded ? state.locale : 'en'),
                ),
                SettingsRow(
                  icon: Icons.notifications,
                  title: 'settings.notifications'.tr(),
                  subtitle: 'settings.push_email'.tr(),
                ),
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
              child: SettingsRow(
                icon: Icons.info,
                title: 'settings.about'.tr(),
                subtitle: 'settings.version'.tr(),
              ),
            ),
          ]),
        );
      },
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    SettingsCubit cubit,
    String currentLocale,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('settings.language'.tr(),
                style: tt.headlineMedium?.copyWith(fontSize: 20)),
            const SizedBox(height: 24),
            _langTile(context, cubit, 'en', 'English', currentLocale, cs, tt),
            const SizedBox(height: 12),
            _langTile(context, cubit, 'ar', 'العربية', currentLocale, cs, tt),
            const SizedBox(height: 16),
          ]),
        );
      },
    );
  }

  Widget _langTile(
    BuildContext context,
    SettingsCubit cubit,
    String locale,
    String label,
    String current,
    ColorScheme cs,
    TextTheme tt,
  ) {
    final selected = locale == current;
    return ListTile(
      title: Text(label, style: tt.bodyMedium),
      trailing: selected ? Icon(Icons.check, color: cs.primary) : null,
      tileColor: selected ? cs.primary.withAlpha(26) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        cubit.setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _sectionHeader(ColorScheme cs, TextTheme tt, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(text,
          style: tt.labelLarge?.copyWith(
              fontSize: 10, color: cs.onSurfaceVariant, letterSpacing: 2)),
    );
  }
}
