import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/profile_field.dart';
import '../widgets/shopping_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 96),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 128, height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.primary.withAlpha(51), width: 4),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/images/male_placeholder.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Container(color: cs.surfaceContainerHighest)),
              ),
              Positioned(
                bottom: 0, right: -4,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Icon(Icons.edit, size: 16, color: cs.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          _sectionHeader(cs, tt, 'profile_screen.account'.tr()),
          const SizedBox(height: 16),
          ProfileField(label: 'profile_screen.full_name'.tr(), value: 'Ahmed Gamal'),
          const SizedBox(height: 12),
          ProfileField(label: 'profile_screen.email'.tr(), value: 'ahmed.gamal@example.com'),
          const SizedBox(height: 12),
          ProfileField(label: 'profile_screen.gender'.tr(), value: 'Male'),
          const SizedBox(height: 12),
          ProfileField(label: 'profile_screen.dob'.tr(), value: '01/15/1992'),
          const SizedBox(height: 12),
          ProfileField(label: 'profile_screen.location'.tr(), value: 'Cairo, Egypt'),
          const SizedBox(height: 48),
          _sectionHeader(cs, tt, 'profile_screen.shopping'.tr()),
          const SizedBox(height: 16),
          ShoppingCard(icon: Icons.history, label: 'profile_screen.order_history'.tr()),
          const SizedBox(height: 12),
          ShoppingCard(icon: Icons.payments, label: 'profile_screen.payment_methods'.tr()),
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
                    borderRadius: BorderRadius.circular(12)),
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
      child: Text(text,
          style: tt.labelLarge?.copyWith(
              color: cs.primary, fontSize: 10, letterSpacing: 2)),
    );
  }
}
