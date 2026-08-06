import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/entities/user_profile.dart';
import '../cubit/profile_cubit.dart';
import 'location_edit_dialog.dart';

class ProfileEditDialogs {
  const ProfileEditDialogs._();

  static void editName(BuildContext context, UserProfile profile) {
    final fn = TextEditingController(text: profile.firstName);
    final ln = TextEditingController(text: profile.lastName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('cancel'.tr())),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
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

  static void editGender(BuildContext context, UserProfile profile) {
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('cancel'.tr())),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
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

  static void editDob(BuildContext context, UserProfile profile) {
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

  static void editLocation(BuildContext context, UserProfile profile) {
    final locService = sl<LocationService>();
    final stateKey = profile.state;
    final cityKey = profile.city ?? '';

    showDialog(
      context: context,
      builder: (_) => LocationEditDialog(
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
}
