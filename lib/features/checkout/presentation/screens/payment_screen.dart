import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../account/presentation/cubit/profile_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/payment_order_summary.dart';
import '../widgets/top_up_sheet.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _api = sl<ApiService>();
  double _walletBalance = 0;
  bool _walletLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    try {
      final data = await _api.get(ApiConstants.wallet);
      if (mounted) {
        final bal = data['coffee_cash'] ?? data['balance'];
        setState(() {
          _walletBalance =
              bal is double ? bal : double.tryParse(bal?.toString() ?? '0') ?? 0;
          _walletLoaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _walletLoaded = true);
    }
  }

  Future<void> _showTopUp(double needed) async {
    final newBalance = await TopUpSheet.show(
      context,
      requiredAmount: needed,
      onAddPaymentMethod: () {
        context.read<ShellCubit>().pushSecondary(const PaymentMethodsRoute());
      },
    );
    if (newBalance != null && mounted) {
      setState(() => _walletBalance = newBalance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            context.read<OrdersCubit>().loadOrders();
            context.read<ProfileCubit>().refreshLoyalty();
            context.read<ShellCubit>().clearAndPush(
                  OrderConfirmationRoute(orderId: state.orderId),
                );
          }
        },
        builder: (context, state) {
          final cart = state is CartLoaded
              ? state.cart
              : (state is CartActionInProgress ? (state).cart : null);

          if (cart == null || cart.isEmpty) {
            return Center(
              child: Text('checkout.empty_bag'.tr(),
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            );
          }

          final isLoading = state is CartActionInProgress;
          final total = cart.subtotal;
          final canCover = _walletLoaded && _walletBalance >= total;
          final canConfirm = canCover && !isLoading;

          return Stack(children: [
            SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 140),
              child: Column(children: [
                const SizedBox(height: 16),
                Text('checkout.complete_order'.tr(),
                    style: tt.headlineMedium?.copyWith(
                        fontSize: 36, color: cs.onSurface)),
                const SizedBox(height: 8),
                Text('checkout.secure_checkout'.tr(), style: tt.bodySmall),
                const SizedBox(height: 40),
                PaymentOrderSummary(
                  items: cart.items,
                  total: total,
                ),
                const SizedBox(height: 24),
                if (_walletLoaded)
                  _buildWalletBanner(cs, tt, total, canCover),
              ]),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
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
                  child: canCover
                      ? FilledButton.icon(
                          onPressed: canConfirm
                              ? () => context
                                  .read<CartCubit>()
                                  .placeOrder(paymentMethod: 'wallet')
                              : null,
                          icon: const Icon(Icons.check_circle, size: 20),
                          label: Text('checkout.confirm_order'.tr()),
                          style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16)),
                        )
                      : FilledButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _showTopUp(total - _walletBalance),
                          icon: const Icon(Icons.add_circle, size: 20),
                          label: Text(
                              'Top Up ${(total - _walletBalance).toStringAsFixed(0)} EGP'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: cs.error,
                            foregroundColor: cs.onError,
                          ),
                        ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Widget _buildWalletBanner(
      ColorScheme cs, TextTheme tt, double total, bool canCover) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: canCover ? cs.primary.withAlpha(26) : cs.error.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(
          canCover ? Icons.check_circle : Icons.info_outline,
          color: canCover ? cs.primary : cs.error,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            canCover
                ? 'Wallet cash (${_walletBalance.toStringAsFixed(0)} EGP) covers this order'
                : 'Insufficient wallet balance — need ${(total - _walletBalance).toStringAsFixed(0)} EGP more',
            style: tt.bodySmall?.copyWith(
              color: canCover ? cs.primary : cs.error,
            ),
          ),
        ),
      ]),
    );
  }
}
