import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/settings_usecases.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase _getSettings;
  final UpdateSettingsUseCase _updateSettings;

  SettingsCubit({
    required GetSettingsUseCase getSettings,
    required UpdateSettingsUseCase updateSettings,
  }) : _getSettings = getSettings,
       _updateSettings = updateSettings,
       super(const SettingsLoading());

  Future<void> loadSettings() async {
    final result = await _getSettings();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> toggleDarkMode() async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final updated = current.settings.copyWith(isDarkMode: !current.isDarkMode);
    emit(SettingsLoaded(updated));
    await _updateSettings(updated);
  }

  Future<void> setLocale(String locale) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final updated = current.settings.copyWith(locale: locale);
    emit(SettingsLoaded(updated)); // optimistic update
    await _updateSettings(updated);
  }

  Future<void> toggleNotifications() async {
    final current = state;
    if (current is! SettingsLoaded) return;
    final updated = current.settings.copyWith(
      notificationsOn: !current.notificationsOn,
    );
    emit(SettingsLoaded(updated));
    await _updateSettings(updated);
  }
}
