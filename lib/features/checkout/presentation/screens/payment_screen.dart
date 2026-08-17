import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../account/presentation/cubit/profile_cubit.dart';
import '../../../account/presentation/cubit/wallet_cubit.dart';
import '../../../account/presentation/cubit/wallet_state.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
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
  double _walletBalance = 0;
  bool _walletLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().loadBalance();
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

    return BlocListener<WalletCubit, WalletState>(
      listener: (_, state) {
        if (state is WalletBalanceLoaded) {
          setState(() {
            _walletBalance = state.balance;
            _walletLoaded = true;
          });
        } else if (state is WalletError) {
          setState(() => _walletLoaded = true);
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is OrderPaymentPendingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('checkout.payment_pending'.tr())),
              );
              context.read<CartCubit>().loadCart();
            } else if (state is OrderResultState) {
              if (state is OrderCleanupWarningState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('checkout.cleanup_warning'.tr())),
                );
              }
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
                child: Text(
                  'checkout.empty_bag'.tr(),
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
              );
            }

            final isLoading = state is CartActionInProgress;
            final total = cart.subtotal;
            final canCover = _walletLoaded && _walletBalance >= total;
            final canConfirm = canCover && !isLoading;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: AppInsets.screenCompact,
                  child: Column(
                    children: [
                      AppSpacing.v16,
                      Text(
                        'checkout.complete_order'.tr(),
                        style: tt.headlineMedium?.copyWith(
                          fontSize: 36,
                          color: cs.onSurface,
                        ),
                      ),
                      AppSpacing.v8,
                      Text(
                        'checkout.secure_checkout'.tr(),
                        style: tt.bodySmall,
                      ),
                      AppSpacing.v40,
                      PaymentOrderSummary(items: cart.items, total: total),
                      AppSpacing.v24,
                      if (_walletLoaded)
                        _buildWalletBanner(cs, tt, total, canCover),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: AppInsets.a24,
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
                                  ? () => context.read<CartCubit>().placeOrder(
                                      paymentMethod: 'wallet',
                                    )
                                  : null,
                              icon: const Icon(Icons.check_circle, size: 20),
                              label: Text('checkout.confirm_order'.tr()),
                              style: FilledButton.styleFrom(
                                padding: AppInsets.v16,
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => _showTopUp(total - _walletBalance),
                              icon: const Icon(Icons.add_circle, size: 20),
                              label: Text(
                                'checkout.top_up_amount'.tr(
                                  namedArgs: {
                                    'amount': 'common.price'.tr(
                                      namedArgs: {
                                        'amount': (total - _walletBalance)
                                            .toStringAsFixed(0),
                                      },
                                    ),
                                  },
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                padding: AppInsets.v16,
                                backgroundColor: cs.error,
                                foregroundColor: cs.onError,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWalletBanner(
    ColorScheme cs,
    TextTheme tt,
    double total,
    bool canCover,
  ) {
    return Container(
      padding: AppInsets.a16,
      decoration: BoxDecoration(
        color: canCover ? cs.primary.withAlpha(26) : cs.error.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            canCover ? Icons.check_circle : Icons.info_outline,
            color: canCover ? cs.primary : cs.error,
            size: 20,
          ),
          AppSpacing.h12,
          Expanded(
            child: Text(
              canCover
                  ? 'checkout.wallet_covers_order'.tr(
                      namedArgs: {
                        'balance': 'common.price'.tr(
                          namedArgs: {
                            'amount': _walletBalance.toStringAsFixed(0),
                          },
                        ),
                      },
                    )
                  : 'checkout.wallet_needs_more'.tr(
                      namedArgs: {
                        'amount': 'common.price'.tr(
                          namedArgs: {
                            'amount': (total - _walletBalance).toStringAsFixed(
                              0,
                            ),
                          },
                        ),
                      },
                    ),
              style: tt.bodySmall?.copyWith(
                color: canCover ? cs.primary : cs.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
