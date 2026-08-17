import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/account_card.dart';
import '../widgets/loyalty_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final cubit = context.read<ShellCubit>();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final name = switch (state) {
          ProfileLoaded(:final profile) =>
            '${profile.firstName} ${profile.lastName}',
          _ => 'common.not_available'.tr(),
        };
        final avatarUrl = switch (state) {
          ProfileLoaded(:final profile) => profile.avatarUrl,
          _ => null,
        };
        final points = switch (state) {
          ProfileLoaded(:final loyaltyPoints) => loyaltyPoints,
          _ => 0.0,
        };
        final gender = switch (state) {
          ProfileLoaded(:final profile) => profile.gender,
          _ => null,
        };
        final cacheBuster = switch (state) {
          ProfileLoaded(:final avatarCacheBuster) => avatarCacheBuster,
          _ => 0,
        };
        final fullAvatarUrl = avatarUrl != null
            ? '${ApiConstants.apiBaseUrl.replaceAll('/api/v1', '')}$avatarUrl${cacheBuster > 0 ? '?t=$cacheBuster' : ''}'
            : null;

        return SingleChildScrollView(
          padding: AppInsets.screen,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => cubit.pushSecondary(const EditProfileRoute()),
                child: Container(
                  padding: AppInsets.a16,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outlineVariant.withAlpha(128)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cs.primary.withAlpha(77),
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: fullAvatarUrl != null
                            ? CachedNetworkImage(
                                imageUrl: fullAvatarUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, _, _) =>
                                    _placeholderAvatar(cs, gender),
                              )
                            : _placeholderAvatar(cs, gender),
                      ),
                      AppSpacing.h16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: tt.headlineMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                            ),
                            AppSpacing.v2,
                            Text(
                              'profile_screen.view_profile'.tr(),
                              style: tt.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
              AppSpacing.v40,
              LoyaltyCard(points: points),
              AppSpacing.v40,
              AccountCard(
                icon: Icons.account_balance_wallet,
                onTap: () => cubit.pushSecondary(const WalletRoute()),
                label: 'profile_screen.wallet'.tr(),
              ),
              AppSpacing.v12,
              AccountCard(
                icon: Icons.payments,
                onTap: () => cubit.pushSecondary(const PaymentMethodsRoute()),
                label: 'profile_screen.payment_methods'.tr(),
              ),
              AppSpacing.v12,
              AccountCard(
                icon: Icons.card_giftcard,
                onTap: () => cubit.pushSecondary(const ReferralRoute()),
                label: 'profile_screen.referral'.tr(),
              ),
              AppSpacing.v12,
              AccountCard(
                icon: Icons.history,
                label: 'profile_screen.order_history'.tr(),
                onTap: () => cubit.pushSecondary(const OrdersHistoryRoute()),
              ),
              AppSpacing.v40,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    sl<AuthCubit>().logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (_) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.error,
                    side: BorderSide(color: cs.error.withAlpha(77)),
                    padding: AppInsets.v14,
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
      },
    );
  }

  Widget _placeholderAvatar(ColorScheme cs, String? gender) {
    final asset = gender == 'female'
        ? 'assets/images/female_placeholder.png'
        : 'assets/images/male_placeholder.png';
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(color: cs.surfaceContainerHighest),
    );
  }
}
