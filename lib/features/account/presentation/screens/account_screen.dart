import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../widgets/account_card.dart';
import '../widgets/loyalty_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final cubit = context.read<ShellCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => cubit.pushSecondary(const EditProfileRoute()),
            child: Container(
              padding: const EdgeInsets.all(16),
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
                    child: Image.asset(
                      'assets/images/male_placeholder.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Container(color: cs.surfaceContainerHighest),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ahmed Gamal',
                          style: tt.headlineMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
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
          const SizedBox(height: 40),
          const LoyaltyCard(),
          const SizedBox(height: 40),
          AccountCard(
            icon: Icons.account_balance_wallet, onTap: () => context.read<ShellCubit>().pushSecondary(const WalletRoute()),
            label: 'profile_screen.wallet'.tr(),
          ),
          const SizedBox(height: 12),
          AccountCard(
            icon: Icons.payments, onTap: () => context.read<ShellCubit>().pushSecondary(const PaymentMethodsRoute()),
            label: 'profile_screen.payment_methods'.tr(),
          ),
          const SizedBox(height: 12),
          AccountCard(
            icon: Icons.card_giftcard, onTap: () => context.read<ShellCubit>().pushSecondary(const ReferralRoute()),
            label: 'profile_screen.referral'.tr(),
          ),
          const SizedBox(height: 12),
          AccountCard(
            icon: Icons.history,
            label: 'profile_screen.order_history'.tr(),
            onTap: () => cubit.pushSecondary(const OrdersHistoryRoute()),
          ),
        ],
      ),
    );
  }
}
