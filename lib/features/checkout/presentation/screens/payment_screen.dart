import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/payment_order_summary.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Stack(children: [
      SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 140),
        child: Column(children: [
          const SizedBox(height: 16),
          Text('checkout.complete_order'.tr(),
              style: tt.headlineMedium?.copyWith(fontSize: 36, color: cs.onSurface)),
          const SizedBox(height: 8),
          Text('checkout.secure_checkout'.tr(), style: tt.bodySmall),
          const SizedBox(height: 40),
          const PaymentOrderSummary(),
          const SizedBox(height: 24),
          const PaymentMethodSelector(),
        ]),
      ),
      Positioned(
        left: 0, right: 0, bottom: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [cs.surface.withAlpha(0), cs.surface],
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () =>
                  context.read<ShellCubit>().clearAndPush(const OrderConfirmationRoute()),
              icon: const Icon(Icons.check_circle, size: 20),
              label: Text('checkout.confirm_order'.tr()),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ),
        ),
      ),
    ]);
  }
}
