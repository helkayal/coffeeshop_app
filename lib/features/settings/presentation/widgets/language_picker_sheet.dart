import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/settings_cubit.dart';

void showLanguagePicker(
  BuildContext context,
  SettingsCubit cubit,
  String currentLocale,
) {
  final cs = Theme.of(context).colorScheme;
  final tt = Theme.of(context).textTheme;

  showModalBottomSheet<void>(
    context: context,
    builder: (_) {
      return Padding(
        padding: AppInsets.a24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'settings.language'.tr(),
              style: tt.headlineMedium?.copyWith(fontSize: 20),
            ),
            AppSpacing.v24,
            _langTile(
              context,
              cubit,
              'en',
              'settings.english'.tr(),
              currentLocale,
              cs,
              tt,
            ),
            AppSpacing.v12,
            _langTile(
              context,
              cubit,
              'ar',
              'settings.arabic'.tr(),
              currentLocale,
              cs,
              tt,
            ),
            AppSpacing.v16,
          ],
        ),
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
      context.setLocale(Locale(locale));
      Navigator.of(context).pop();
    },
  );
}
