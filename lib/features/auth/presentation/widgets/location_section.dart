import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/egypt_locations.dart';
import '../../../../core/widgets/app_dropdown.dart';

class LocationSection extends StatelessWidget {
  final ValueNotifier<String?> stateNotifier;
  final ValueNotifier<String?> cityNotifier;

  const LocationSection({
    super.key,
    required this.stateNotifier,
    required this.cityNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<String?>(
            valueListenable: stateNotifier,
            builder: (context, selectedState, _) => AppDropdown(
              hint: 'locations.select_state'.tr(),
              items: EgyptLocations.states,
              value: selectedState,
              onChanged: (value) {
                stateNotifier.value = value;
                cityNotifier.value = null;
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ValueListenableBuilder<String?>(
            valueListenable: stateNotifier,
            builder: (context, selectedState, _) =>
                ValueListenableBuilder<String?>(
                  valueListenable: cityNotifier,
                  builder: (context, selectedCity, _) => AppDropdown(
                    hint: 'locations.select_city'.tr(),
                    items: selectedState != null
                        ? EgyptLocations.getCitiesForState(selectedState)
                        : [],
                    value: selectedCity,
                    onChanged: (value) => cityNotifier.value = value,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
