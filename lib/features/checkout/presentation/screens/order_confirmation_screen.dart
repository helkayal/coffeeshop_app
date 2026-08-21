import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/cart_item.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/order_receipt_card.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final state = context.read<CartCubit>().state;
    final items = state is OrderResultState ? state.items : <CartItem>[];
    final total = state is OrderResultState ? state.total : 0.0;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        padding: AppInsets.screen,
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 72, color: cs.primary),
            AppSpacing.v24,
            Text(
              'checkout.order_complete'.tr(),
              style: AppTextStyles.headlineMd(
                weight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            AppSpacing.v8,
            Text('checkout.order_complete_sub'.tr(), style: tt.bodySmall),
            AppSpacing.v40,
            OrderReceiptCard(orderId: orderId, items: items, total: total),
          ],
        ),
      ),
    );
  }
}
