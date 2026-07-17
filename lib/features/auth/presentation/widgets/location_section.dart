import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_dropdown.dart';

class LocationSection extends StatefulWidget {
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
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  final _service = sl<LocationService>();
  List<String> _states = [];
  List<String> _cities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    final states = await _service.getStates();
    if (mounted) {
      setState(() {
        _states = states;
        _loading = false;
      });
    }
  }

  Future<void> _loadCities(String state) async {
    setState(() => _loading = true);
    final cities = await _service.getCities(state);
    if (mounted) {
      setState(() {
        _cities = cities;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _states.isEmpty) {
      _service.getStates().then((s) {
        if (mounted) {
          setState(() { _states = s; _loading = false; });
        }
      });
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ValueListenableBuilder<String?>(
            valueListenable: widget.stateNotifier,
            builder: (context, selectedState, _) => AppDropdown(
              hint: 'locations.select_state'.tr(),
              items: _states,
              value: selectedState,
              errorText: widget.stateError,
              useLocalization: false,
              onChanged: (value) {
                widget.stateNotifier.value = value;
                widget.cityNotifier.value = null;
                if (value != null) _loadCities(value);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ValueListenableBuilder<String?>(
            valueListenable: widget.stateNotifier,
            builder: (context, selectedState, _) =>
                ValueListenableBuilder<String?>(
                  valueListenable: widget.cityNotifier,
                  builder: (context, selectedCity, _) => AppDropdown(
                    hint: 'locations.select_city'.tr(),
                    items: _cities,
                    value: selectedCity,
                    errorText: widget.cityError,
                    useLocalization: false,
                    onChanged: (value) => widget.cityNotifier.value = value,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
