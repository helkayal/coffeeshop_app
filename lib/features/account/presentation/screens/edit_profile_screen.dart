import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/user_profile.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state is ProfileLoaded ? state.profile : null;
        final fullName = profile != null
            ? '${profile.firstName} ${profile.lastName}'
            : '...';
        final email = profile?.email ?? '...';
        final gender = profile?.gender == 'female'
            ? 'auth.female'.tr()
            : 'auth.male'.tr();
        final dob = profile?.dateOfBirth ?? '...';
        final location = profile != null && profile.state != null
            ? '${profile.state!}, ${profile.city ?? ''}'
            : '...';
        final fullAvatarUrl = profile?.avatarUrl != null
            ? '${ApiConstants.apiBaseUrl.replaceAll('/api/v1', '')}${profile!.avatarUrl}'
            : null;

        return Scaffold(
          backgroundColor: cs.surface,
          body: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 40, 24, 96),
            child: Column(
            children: [
              ProfileAvatar(
                avatarUrl: fullAvatarUrl,
                gender: profile?.gender,
                showEditButton: true,
                onEditTap: () => _pickAndUploadAvatar(context),
              ),
              const SizedBox(height: 48),
              _sectionHeader(cs, tt, 'profile_screen.account'.tr()),
              const SizedBox(height: 16),
              ProfileField(
                label: 'profile_screen.full_name'.tr(),
                value: fullName,
                onEdit: () => _editName(context, profile),
              ),
              const SizedBox(height: 12),
              ProfileField(
                label: 'profile_screen.email'.tr(),
                value: email,
              ),
              const SizedBox(height: 12),
              ProfileField(
                label: 'profile_screen.gender'.tr(),
                value: gender,
                onEdit: () => _editGender(context, profile),
              ),
              const SizedBox(height: 12),
              ProfileField(
                label: 'profile_screen.dob'.tr(),
                value: dob,
                onEdit: () => _editDob(context, profile),
              ),
              const SizedBox(height: 12),
              ProfileField(
                label: 'profile_screen.location'.tr(),
                value: location,
                onEdit: () => _editLocation(context, profile),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _signOut(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.error,
                    side: BorderSide(color: cs.error.withAlpha(77)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: Text('profile_screen.sign_out'.tr()),
                ),
              ),
            ],
            ),
          ),
        );
      },
    );
  }

  // ── Avatar ───────────────────────────────────────────────────────────────

  Future<void> _pickAndUploadAvatar(BuildContext context) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null && context.mounted) {
      context.read<ProfileCubit>().uploadAvatar(picked.path);
    }
  }

  // ── Name ─────────────────────────────────────────────────────────────────

  void _editName(BuildContext context, UserProfile? profile) {
    if (profile == null) return;
    final fn = TextEditingController(text: profile.firstName);
    final ln = TextEditingController(text: profile.lastName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('profile_screen.full_name'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: fn,
              hintText: 'auth.first_name'.tr(),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: ln,
              hintText: 'auth.last_name'.tr(),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('cancel'.tr())),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              final updated = UserProfileModel(
                id: profile.id,
                firstName: fn.text.trim(),
                lastName: ln.text.trim(),
                email: profile.email,
                gender: profile.gender,
                state: profile.state,
                city: profile.city,
                dateOfBirth: profile.dateOfBirth,
                avatarUrl: profile.avatarUrl,
              );
              context.read<ProfileCubit>().updateProfile(updated);
            },
            child: Text('save'.tr()),
          ),
        ],
      ),
    );
  }

  // ── Gender ───────────────────────────────────────────────────────────────

  void _editGender(BuildContext context, UserProfile? profile) {
    if (profile == null) return;
    var selected = profile.gender ?? 'male';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setDialogState) => AlertDialog(
          title: Text('profile_screen.gender'.tr()),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setDialogState(() => selected = v ?? selected),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['male', 'female'].map((g) {
                return RadioListTile<String>(
                  value: g,
                  title: Text('auth.$g'.tr()),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('cancel'.tr())),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                final updated = UserProfileModel(
                  id: profile.id,
                  firstName: profile.firstName,
                  lastName: profile.lastName,
                  email: profile.email,
                  gender: selected,
                  state: profile.state,
                  city: profile.city,
                  dateOfBirth: profile.dateOfBirth,
                  avatarUrl: profile.avatarUrl,
                );
                context.read<ProfileCubit>().updateProfile(updated);
              },
              child: Text('save'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  // ── Date of birth ────────────────────────────────────────────────────────

  void _editDob(BuildContext context, UserProfile? profile) {
    if (profile == null) return;
    final initial = profile.dateOfBirth != null
        ? DateTime.tryParse(profile.dateOfBirth!) ?? DateTime(2000)
        : DateTime(2000);

    showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'auth.date_of_birth'.tr(),
    ).then((picked) {
      if (picked != null && context.mounted) {
        final dob =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        final updated = UserProfileModel(
          id: profile.id,
          firstName: profile.firstName,
          lastName: profile.lastName,
          email: profile.email,
          gender: profile.gender,
          state: profile.state,
          city: profile.city,
          dateOfBirth: dob,
          avatarUrl: profile.avatarUrl,
        );
        context.read<ProfileCubit>().updateProfile(updated);
      }
    });
  }

  // ── Location ─────────────────────────────────────────────────────────────

  void _editLocation(BuildContext context, UserProfile? profile) {
    if (profile == null) return;
    final locService = sl<LocationService>();
    final stateKey = profile.state;
    final cityKey = profile.city ?? '';

    showDialog(
      context: context,
      builder: (_) => _LocationDialog(
        initial: LocationEditData(
          state: stateKey,
          city: cityKey.isNotEmpty ? cityKey : null,
        ),
        locationService: locService,
        onSaved: (state, city) {
          final updated = UserProfileModel(
            id: profile.id,
            firstName: profile.firstName,
            lastName: profile.lastName,
            email: profile.email,
            gender: profile.gender,
            state: state,
            city: city,
            dateOfBirth: profile.dateOfBirth,
            avatarUrl: profile.avatarUrl,
          );
          context.read<ProfileCubit>().updateProfile(updated);
        },
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _signOut(BuildContext context) {
    sl<AuthCubit>().logout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  Widget _sectionHeader(ColorScheme cs, TextTheme tt, String text) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: tt.labelLarge?.copyWith(
          color: cs.primary,
          fontSize: 10,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

// Inline model helper for building updates without importing the model file.
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.gender,
    super.state,
    super.city,
    super.avatarUrl,
    super.dateOfBirth,
  });
}

// ── Location edit dialog ──────────────────────────────────────────────────

class LocationEditData {
  final String? state;
  final String? city;
  const LocationEditData({this.state, this.city});
}

class _LocationDialog extends StatefulWidget {
  final LocationEditData initial;
  final LocationService locationService;
  final void Function(String? state, String? city) onSaved;

  const _LocationDialog({
    required this.initial,
    required this.locationService,
    required this.onSaved,
  });

  @override
  State<_LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<_LocationDialog> {
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
