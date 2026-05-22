import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../features/home/presentation/cubit/home_cubit.dart';
import '../widgets/shopping_card.dart';
import '../widgets/loyalty_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.read<HomeCubit>().pushSecondary(
              const EditProfileRoute(),
            ),
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
          _sectionHeader(cs, tt, 'profile_screen.shopping'.tr()),
          const SizedBox(height: 16),
          ShoppingCard(
            icon: Icons.account_balance_wallet,
            label: 'profile_screen.wallet'.tr(),
          ),
          const SizedBox(height: 12),
          ShoppingCard(
            icon: Icons.payments,
            label: 'profile_screen.payment_methods'.tr(),
          ),
          const SizedBox(height: 12),
          ShoppingCard(
            icon: Icons.history,
            label: 'profile_screen.order_history'.tr(),
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
