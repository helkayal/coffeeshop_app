import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/network_info_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../features/checkout/presentation/widgets/payment_option.dart';
import '../../../../features/checkout/presentation/widgets/wallet_sheet.dart';
import '../widgets/add_card_form_sheet.dart';
import '../widgets/saved_card_tile.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _api = sl<ApiService>();
  final _storage = sl<LocalStorageService>();
  List<Map<String, dynamic>> _cards = [];
  String _selected = '';
  String? _walletPhone;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.get(ApiConstants.paymentMethods);
      if (mounted) {
        setState(() {
          _cards = List<Map<String, dynamic>>.from(data as List);
          _walletPhone = _storage.getWalletPhone();
          final savedMethod = _storage.getDefaultPaymentMethod();
          if (savedMethod != null && savedMethod.isNotEmpty) {
            _selected = savedMethod;
          } else {
            final defaultCard = _cards.firstWhere(
              (c) => c['is_default'] == true,
              orElse: () => <String, dynamic>{},
            );
            _selected = defaultCard['id'] as String? ?? '';
          }
          _loading = false;
        });
      }
    } on ConnectionException catch (_) {
      if (mounted) {
        sl<ConnectivityCubit>().markOffline(ConnectionStatus.serverUnreachable);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _reloadAfterReconnect() {
    if (!mounted) return;
    setState(() => _loading = true);
    _load();
  }

  Future<void> _addCard({
    required String cardLast4,
    required String expiryMonth,
    required String expiryYear,
    required String cardholderName,
    required String cardBrand,
  }) async {
    try {
      await _api.post(
        ApiConstants.paymentMethods,
        data: {
          'card_last4': cardLast4,
          'expiry_month': expiryMonth,
          'expiry_year': expiryYear,
          'card_brand': cardBrand,
          'cardholder_name': cardholderName,
        },
      );
      await _load();
    } on ConnectionException catch (_) {
      if (mounted) {
        sl<ConnectivityCubit>().markOffline(ConnectionStatus.serverUnreachable);
      }
    } catch (e) {
      if (!mounted) return;
      String errorMsg = 'credit_card.load_error'.tr();
      if (e is ServerException && e.message != null && e.message!.isNotEmpty) {
        errorMsg = e.message!;
      } else if (e is DioException && e.response?.data is Map) {
        final msg = e.response?.data['message'];
        if (msg is String && msg.isNotEmpty) {
          errorMsg = msg;
        }
      }
      AppSnackBar.show(context, errorMsg, type: SnackBarType.error);
    }
  }

  Future<void> _deleteCard(String id) async {
    try {
      if (_selected == id) {
        await _storage.clearDefaultPaymentMethod();
        setState(() => _selected = '');
      }
      await _api.delete('${ApiConstants.paymentMethods}/$id');
      await _load();
    } on ConnectionException catch (_) {
      if (mounted) {
        sl<ConnectivityCubit>().markOffline(ConnectionStatus.serverUnreachable);
      }
    } catch (e) {
      if (!mounted) return;
      String errorMsg = 'credit_card.load_error'.tr();
      if (e is ServerException && e.message != null && e.message!.isNotEmpty) {
        errorMsg = e.message!;
      }
      AppSnackBar.show(context, errorMsg, type: SnackBarType.error);
    }
  }

  Future<void> _setDefault(String id) async {
    try {
      await _storage.setDefaultPaymentMethod(id);
      await _api.patch('${ApiConstants.paymentMethods}/$id');
      if (mounted) {
        setState(() {
          for (var card in _cards) {
            card['is_default'] = (card['id'] == id);
          }
        });
      }
    } on ConnectionException catch (_) {
      if (mounted) {
        sl<ConnectivityCubit>().markOffline(ConnectionStatus.serverUnreachable);
      }
    } catch (e) {
      if (!mounted) return;
      String errorMsg = 'credit_card.load_error'.tr();
      if (e is ServerException && e.message != null && e.message!.isNotEmpty) {
        errorMsg = e.message!;
      }
      AppSnackBar.show(context, errorMsg, type: SnackBarType.error);
    }
  }

  Future<void> _editWalletPhone() async {
    final updated = await WalletSheet.show(context);
    if (updated == true && mounted) {
      setState(() {
        _walletPhone = _storage.getWalletPhone();
      });
    }
  }

  void _showAddCardSheet() {
    final last4Ctrl = TextEditingController();
    final monthCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => AddCardFormSheet(
        last4Ctrl: last4Ctrl,
        monthCtrl: monthCtrl,
        yearCtrl: yearCtrl,
        nameCtrl: nameCtrl,
        onSave: (last4, month, year, name, brand) {
          Navigator.pop(ctx);
          _addCard(
            cardLast4: last4,
            expiryMonth: month,
            expiryYear: year,
            cardholderName: name,
            cardBrand: brand,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return BlocListener<ConnectivityCubit, ConnectivityState>(
      bloc: sl<ConnectivityCubit>(),
      listener: (_, state) {
        if (state is ConnectivityOnline) _reloadAfterReconnect();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(tt, 'payment_methods.saved_cards'.tr()),
              const SizedBox(height: 16),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_cards.isEmpty)
                Text('payment_methods.no_saved_cards'.tr(), style: tt.bodySmall)
              else
                ..._cards.map((card) {
                  final cardId = card['id'] as String;
                  final selected = _selected == cardId;
                  final expiryStr = 'credit_card.expires_at'.tr(
                    args: ['${card['expiry_month']}/${card['expiry_year']}'],
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SavedCardTile(
                      mask: '•••• ${card['card_last4']}',
                      expiry: expiryStr,
                      isDefault: selected,
                      onTap: () {
                        if (selected) {
                          _storage.clearDefaultPaymentMethod();
                          setState(() => _selected = '');
                        } else {
                          setState(() => _selected = cardId);
                          _setDefault(cardId);
                        }
                      },
                      onDelete: () => _deleteCard(cardId),
                    ),
                  );
                }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showAddCardSheet,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('payment_methods.add_new_card'.tr()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _sectionTitle(tt, 'payment_methods.other_methods'.tr()),
              const SizedBox(height: 16),
              PaymentOption(
                icon: Icons.account_balance_wallet,
                label: 'payment_methods.coffee_cash_wallet'.tr(),
                subtitle: _walletPhone != null && _walletPhone!.isNotEmpty
                    ? _walletPhone
                    : null,
                isSelected: _selected == 'wallet',
                showDefaultBadge: _selected == 'wallet',
                onEdit: _walletPhone != null && _walletPhone!.isNotEmpty
                    ? _editWalletPhone
                    : null,
                onTap: () async {
                  setState(() => _selected = 'wallet');
                  await _storage.setDefaultPaymentMethod('wallet');
                  final phone = _storage.getWalletPhone();
                  if (phone == null || phone.trim().isEmpty) {
                    await _editWalletPhone();
                  }
                },
              ),
              const SizedBox(height: 8),
              PaymentOption(
                icon: Icons.phone_iphone,
                label: 'payment_methods.apple_pay'.tr(),
                isSelected: _selected == 'applepay',
                showDefaultBadge: _selected == 'applepay',
                onTap: () async {
                  await _storage.setDefaultPaymentMethod('applepay');
                  if (mounted) setState(() => _selected = 'applepay');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(
      text,
      style: tt.headlineMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
