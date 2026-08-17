import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';

class OrderSummaryCard extends StatelessWidget {
  final String subtotal;
  final String shipping;
  final String total;
  final VoidCallback? onCheckout;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: AppInsets.a32,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppInsets.a24,
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: cs.outlineVariant.withAlpha(128)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: cs.onSurfaceVariant),
                    AppSpacing.h8,
                    Text(
                      'checkout.special_instructions'.tr(),
                      style: tt.headlineMedium?.copyWith(
                        fontSize: 20,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                AppSpacing.v12,
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'checkout.add_note'.tr(),
                    hintStyle: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v24,
          Text(
            'checkout.summary'.tr(),
            style: tt.headlineMedium?.copyWith(
              fontSize: 24,
              color: cs.onSurface,
            ),
          ),
          AppSpacing.v24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout.subtotal'.tr(),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(
                subtotal,
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          AppSpacing.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout.shipping'.tr(),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(
                shipping,
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          AppSpacing.v24,
          Divider(color: cs.outlineVariant.withAlpha(128)),
          AppSpacing.v24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout.total'.tr(),
                style: tt.headlineMedium?.copyWith(
                  fontSize: 20,
                  color: cs.onSurface,
                ),
              ),
              Text(
                total,
                style: tt.headlineMedium?.copyWith(
                  fontSize: 30,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed:
                  onCheckout ??
                  () => context.read<ShellCubit>().pushSecondary(
                    const PaymentRoute(),
                  ),
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: Text('checkout.proceed_to_checkout'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
