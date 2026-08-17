import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../auth/presentation/cubit/locations_cubit.dart';
import '../../../auth/presentation/cubit/locations_state.dart';

class LocationEditData {
  final String? state;
  final String? city;
  const LocationEditData({this.state, this.city});
}

class LocationEditDialog extends StatefulWidget {
  final LocationEditData initial;
  final void Function(String? state, String? city) onSaved;

  const LocationEditDialog({
    super.key,
    required this.initial,
    required this.onSaved,
  });

  @override
  State<LocationEditDialog> createState() => _LocationEditDialogState();
}

class _LocationEditDialogState extends State<LocationEditDialog> {
  late final _state = ValueNotifier<String?>(widget.initial.state);
  late final _city = ValueNotifier<String?>(widget.initial.city);
  @override
  void initState() {
    super.initState();
    if (widget.initial.state case final state?) {
      context.read<LocationsCubit>().loadCities(state);
    } else {
      context.read<LocationsCubit>().loadStates();
    }
  }

  @override
  void dispose() {
    _state.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsCubit, LocationsState>(
      builder: (context, locationState) {
        final states = switch (locationState) {
          LocationsLoaded(:final states) => states,
          LocationsLoading(:final states) => states,
          _ => const <String>[],
        };
        final cities = locationState is LocationsLoaded
            ? locationState.cities
            : const <String>[];
        return AlertDialog(
          title: Text('profile_screen.location'.tr()),
          content: locationState is LocationsLoading && states.isEmpty
              ? const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: _state,
                      builder: (_, state, _) => AppDropdown(
                        hint: 'locations.select_state'.tr(),
                        items: states,
                        value: state,
                        useLocalization: false,
                        onChanged: (v) {
                          _state.value = v;
                          _city.value = null;
                          if (v != null) {
                            context.read<LocationsCubit>().loadCities(v);
                          }
                        },
                      ),
                    ),
                    AppSpacing.v12,
                    ValueListenableBuilder<String?>(
                      valueListenable: _state,
                      builder: (_, s, _) => ValueListenableBuilder<String?>(
                        valueListenable: _city,
                        builder: (_, city, _) => AppDropdown(
                          hint: 'locations.select_city'.tr(),
                          items: cities,
                          value: city,
                          useLocalization: false,
                          onChanged: (v) => _city.value = v,
                        ),
                      ),
                    ),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr()),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onSaved(_state.value, _city.value);
              },
              child: Text('save'.tr()),
            ),
          ],
        );
      },
    );
  }
}
