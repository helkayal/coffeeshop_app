import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/profile_avatar.dart';
import '../widgets/profile_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 96),
      child: Column(
        children: [
          const ProfileAvatar(),
          const SizedBox(height: 48),
          _sectionHeader(cs, tt, 'profile_screen.account'.tr()),
          const SizedBox(height: 16),
          ProfileField(
            label: 'profile_screen.full_name'.tr(),
            value: 'Ahmed Gamal',
          ),
          const SizedBox(height: 12),
          ProfileField(
            label: 'profile_screen.email'.tr(),
            value: 'ahmed.gamal@example.com',
          ),
          const SizedBox(height: 12),
          ProfileField(label: 'profile_screen.gender'.tr(), value: 'Male'),
          const SizedBox(height: 12),
          ProfileField(label: 'profile_screen.dob'.tr(), value: '01/15/1992'),
          const SizedBox(height: 12),
          ProfileField(
            label: 'profile_screen.location'.tr(),
            value: 'Cairo, Egypt',
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
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
    );
  }

  Widget _sectionHeader(ColorScheme cs, TextTheme tt, String text) {
    return Align(
      alignment: Alignment.centerLeft,
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
