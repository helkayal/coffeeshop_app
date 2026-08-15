import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_dropdown.dart';
import '../cubit/locations_cubit.dart';
import '../cubit/locations_state.dart';

class LocationSection extends StatelessWidget {
  final ValueNotifier<String?> stateNotifier;
  final ValueNotifier<String?> cityNotifier;
  final String? stateError;
  final String? cityError;

  const LocationSection({
    super.key,
    required this.stateNotifier,
    required this.cityNotifier,
    this.stateError,
    this.cityError,
  });

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
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ValueListenableBuilder<String?>(
                valueListenable: stateNotifier,
                builder: (_, selectedState, _) => AppDropdown(
                  hint: 'locations.select_state'.tr(),
                  items: states,
                  value: selectedState,
                  errorText: stateError,
                  useLocalization: false,
                  onChanged: (value) {
                    stateNotifier.value = value;
                    cityNotifier.value = null;
                    if (value != null) {
                      context.read<LocationsCubit>().loadCities(value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ValueListenableBuilder<String?>(
                valueListenable: cityNotifier,
                builder: (_, selectedCity, _) => AppDropdown(
                  hint: 'locations.select_city'.tr(),
                  items: cities,
                  value: selectedCity,
                  errorText: cityError,
                  useLocalization: false,
                  onChanged: (value) => cityNotifier.value = value,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
