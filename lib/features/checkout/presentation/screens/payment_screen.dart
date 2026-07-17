import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/payment_order_summary.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _api = sl<ApiService>();
  String _selectedMethod = '';
  bool _useWalletCash = true;
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
        final bal = data['balance'];
        setState(() {
          _walletBalance = bal is double ? bal : double.tryParse(bal?.toString() ?? '0') ?? 0;
          _walletLoaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _walletLoaded = true);
    }
  }

  void _onMethodChanged(bool usePoints, String method) {
    setState(() {
      _useWalletCash = usePoints;
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is OrderPlaced) {
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

        bool canConfirm;
        if (_useWalletCash && _walletBalance >= total) {
          // Wallet covers the full amount — can confirm.
          canConfirm = true;
        } else if (_useWalletCash && _walletBalance < total) {
          // Wallet doesn't cover — need a payment method for the remainder.
          final storage = sl<LocalStorageService>();
          canConfirm = switch (_selectedMethod) {
            'card' => storage.getSavedCards().isNotEmpty,
            'wallet' => (storage.getWalletPhone() ?? '').isNotEmpty,
            'applepay' => true,
            _ => false,
          };
        } else {
          final storage = sl<LocalStorageService>();
          canConfirm = switch (_selectedMethod) {
            'card' => storage.getSavedCards().isNotEmpty,
            'wallet' => (storage.getWalletPhone() ?? '').isNotEmpty,
            'applepay' => true,
            _ => false,
          };
        }
        canConfirm = canConfirm && !isLoading;

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
              if (_walletLoaded && _useWalletCash)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _walletBalance >= total
                          ? cs.primary.withAlpha(26)
                          : cs.error.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      Icon(
                        _walletBalance >= total
                            ? Icons.check_circle
                            : Icons.info_outline,
                        color: _walletBalance >= total ? cs.primary : cs.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _walletBalance >= total
                              ? 'Wallet cash (${_walletBalance.toStringAsFixed(0)} EGP) covers this order'
                              : 'Wallet cash (${_walletBalance.toStringAsFixed(0)} EGP) — need ${(total - _walletBalance).toStringAsFixed(0)} EGP more',
                          style: tt.bodySmall?.copyWith(
                            color: _walletBalance >= total
                                ? cs.primary
                                : cs.error,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              PaymentMethodSelector(onChanged: _onMethodChanged),
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
                child: FilledButton.icon(
                  onPressed: canConfirm
                      ? () => context.read<CartCubit>().placeOrder(
                            paymentMethod:
                                _useWalletCash ? 'wallet' : _selectedMethod,
                          )
                      : null,
                  icon: const Icon(Icons.check_circle, size: 20),
                  label: Text('checkout.confirm_order'.tr()),
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
