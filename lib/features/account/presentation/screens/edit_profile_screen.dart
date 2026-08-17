import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_edit_dialogs.dart';
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
            : 'common.not_available'.tr();
        final email = profile?.email ?? 'common.not_available'.tr();
        final gender = switch (profile?.gender) {
          'female' => 'auth.female'.tr(),
          'male' => 'auth.male'.tr(),
          _ => 'common.not_available'.tr(),
        };
        final dob = profile?.dateOfBirth ?? 'common.not_available'.tr();
        final location = switch (profile?.state) {
          final state? when state.isNotEmpty =>
            profile?.city != null && profile!.city!.isNotEmpty
                ? '$state, ${profile.city}'
                : state,
          _ => 'common.not_available'.tr(),
        };
        final cacheBuster = state is ProfileLoaded
            ? state.avatarCacheBuster
            : 0;
        final fullAvatarUrl = switch (profile?.avatarUrl) {
          final avatarUrl? =>
            '${ApiConstants.apiBaseUrl.replaceAll('/api/v1', '')}$avatarUrl${cacheBuster > 0 ? '?t=$cacheBuster' : ''}',
          null => null,
        };

        return Scaffold(
          backgroundColor: cs.surface,
          body: SingleChildScrollView(
            padding: AppInsets.screenTop40,
            child: Column(
              children: [
                ProfileAvatar(
                  avatarUrl: fullAvatarUrl,
                  gender: profile?.gender,
                  showEditButton: true,
                  onEditTap: () => _pickAndUploadAvatar(context),
                ),
                AppSpacing.v48,
                _sectionHeader(cs, tt, 'profile_screen.account'.tr()),
                AppSpacing.v16,
                ProfileField(
                  label: 'profile_screen.full_name'.tr(),
                  value: fullName,
                  onEdit: profile == null
                      ? null
                      : () => ProfileEditDialogs.editName(context, profile),
                ),
                AppSpacing.v12,
                ProfileField(label: 'profile_screen.email'.tr(), value: email),
                AppSpacing.v12,
                ProfileField(
                  label: 'profile_screen.gender'.tr(),
                  value: gender,
                  onEdit: profile == null
                      ? null
                      : () => ProfileEditDialogs.editGender(context, profile),
                ),
                AppSpacing.v12,
                ProfileField(
                  label: 'profile_screen.dob'.tr(),
                  value: dob,
                  onEdit: profile == null
                      ? null
                      : () => ProfileEditDialogs.editDob(context, profile),
                ),
                AppSpacing.v12,
                ProfileField(
                  label: 'profile_screen.location'.tr(),
                  value: location,
                  onEdit: profile == null
                      ? null
                      : () => ProfileEditDialogs.editLocation(context, profile),
                ),
                AppSpacing.v48,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _signOut(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.error,
                      side: BorderSide(color: cs.error.withAlpha(77)),
                      padding: AppInsets.v16,
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

  Future<void> _pickAndUploadAvatar(BuildContext context) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null && context.mounted) {
      context.read<ProfileCubit>().uploadAvatar(picked.path);
    }
  }

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
