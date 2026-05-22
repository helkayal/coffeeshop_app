import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/section_header_label.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/language_picker_sheet.dart';
import '../widgets/settings_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state is SettingsLoaded && state.isDarkMode;
        final notifOn = state is SettingsLoaded && state.notificationsOn;
        final cubit = context.read<SettingsCubit>();
        final locale = state is SettingsLoaded ? state.locale : 'en';

        return SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionHeaderLabel(text: 'settings.preferences'.tr()),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withAlpha(51)),
              ),
              child: Column(children: [
                SettingsRow(
                  icon: Icons.palette, title: 'settings.appearance'.tr(),
                  subtitle: isDark ? 'settings.dark_mode'.tr() : 'settings.light_mode'.tr(),
                  onTap: cubit.toggleDarkMode,
                  trailing: Switch(value: isDark, onChanged: (_) => cubit.toggleDarkMode(), activeThumbColor: cs.primary),
                ),
                SettingsRow(
                  icon: Icons.language, title: 'settings.language'.tr(),
                  subtitle: locale == 'ar' ? 'العربية' : 'settings.english'.tr(),
                  onTap: () => showLanguagePicker(context, cubit, locale),
                ),
                SettingsRow(
                  icon: Icons.notifications, title: 'settings.notifications'.tr(),
                  subtitle: notifOn ? 'settings.notif_on'.tr() : 'settings.notif_off'.tr(),
                  trailing: Switch(value: notifOn, onChanged: (_) => cubit.toggleNotifications(), activeThumbColor: cs.primary),
                ),
              ]),
            ),
            const SizedBox(height: 48),
            SectionHeaderLabel(text: 'settings.support'.tr()),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withAlpha(51)),
              ),
              child: SettingsRow(icon: Icons.info, title: 'settings.about'.tr(), subtitle: 'settings.version'.tr()),
            ),
          ]),
        );
      },
    );
  }
}
