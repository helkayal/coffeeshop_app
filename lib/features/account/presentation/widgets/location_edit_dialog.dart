import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/widgets/app_dropdown.dart';

class LocationEditData {
  final String? state;
  final String? city;
  const LocationEditData({this.state, this.city});
}

class LocationEditDialog extends StatefulWidget {
  final LocationEditData initial;
  final LocationService locationService;
  final void Function(String? state, String? city) onSaved;

  const LocationEditDialog({
    super.key,
    required this.initial,
    required this.locationService,
    required this.onSaved,
  });

  @override
  State<LocationEditDialog> createState() => _LocationEditDialogState();
}

class _LocationEditDialogState extends State<LocationEditDialog> {
  late final _state = ValueNotifier<String?>(widget.initial.state);
  late final _city = ValueNotifier<String?>(widget.initial.city);
  List<String> _states = [];
  List<String> _cities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    widget.locationService.getStates().then((s) {
      if (mounted) setState(() { _states = s; _loading = false; });
    });
    if (widget.initial.state != null) {
      _loadCities(widget.initial.state!);
    }
  }

  Future<void> _loadCities(String state) async {
    setState(() => _loading = true);
    final cities = await widget.locationService.getCities(state);
    if (mounted) setState(() { _cities = cities; _loading = false; });
  }

  @override
  void dispose() {
    _state.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('profile_screen.location'.tr()),
      content: _loading && _states.isEmpty
          ? const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()))
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: _state,
                  builder: (_, state, _) => AppDropdown(
                    hint: 'locations.select_state'.tr(),
                    items: _states,
                    value: state,
                    useLocalization: false,
                    onChanged: (v) {
                      _state.value = v;
                      _city.value = null;
                      if (v != null) _loadCities(v);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<String?>(
                  valueListenable: _state,
                  builder: (_, s, _) =>
                      ValueListenableBuilder<String?>(
                        valueListenable: _city,
                        builder: (_, city, _) => AppDropdown(
                          hint: 'locations.select_city'.tr(),
                          items: _cities,
                          value: city,
                          useLocalization: false,
                          onChanged: (v) => _city.value = v,
                        ),
                      ),
                ),
              ],
            ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('cancel'.tr())),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSaved(_state.value, _city.value);
          },
          child: Text('save'.tr()),
        ),
      ],
    );
  }
}
