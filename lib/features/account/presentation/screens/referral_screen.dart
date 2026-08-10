import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/network_info_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../cubit/profile_cubit.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final _api = sl<ApiService>();
  final _applyCtrl = TextEditingController();
  String _code = '';
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;
  bool _applying = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _applyCtrl.dispose();
    super.dispose();
  }

  void _shareCode() {
    if (_code.isEmpty) return;
    Share.share('Use my referral code $_code to earn rewards!');
  }

  void _copyCode() {
    if (_code.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _code));
    AppSnackBar.show(
      context,
      'referral.code_copied'.tr(),
      type: SnackBarType.info,
    );
  }

  Future<void> _applyReferral() async {
    final code = _applyCtrl.text.trim();
    if (code.isEmpty) return;

    setState(() => _applying = true);

    try {
      await _api.post(ApiConstants.referralApply, data: {'code': code});

      if (!mounted) return;

      try {
        context.read<ProfileCubit>().loadProfile();
      } catch (_) {}

      _applyCtrl.clear();
      await _load();

      if (mounted) {
        AppSnackBar.show(
          context,
          'referral.applied_success'.tr(),
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (!mounted) return;
      String errorMsg = 'referral.apply_failed'.tr();
      if (e is DioException && e.response?.data is Map) {
        final msg = e.response?.data['message'];
        if (msg is String && msg.isNotEmpty) {
          errorMsg = msg;
        }
      }
      AppSnackBar.show(context, errorMsg, type: SnackBarType.error);
    } finally {
      if (mounted) {
        setState(() => _applying = false);
      }
    }
  }

  Future<void> _load() async {
    try {
      final data = await _api.get(ApiConstants.referral);
      final history = await _api.get(ApiConstants.referralHistory);
      if (mounted) {
        setState(() {
          _code = data['code'] as String? ?? '';
          _history = List<Map<String, dynamic>>.from(history as List);
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: cs.surface,
            body: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: cs.outlineVariant.withAlpha(128),
                        ),
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            color: cs.primary,
                            tooltip: 'Share',
                            onPressed: _shareCode,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: cs.primary.withAlpha(77),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      _code,
                                      style: tt.titleMedium?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2,
                                        color: cs.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18),
                                  color: cs.primary,
                                  onPressed: _copyCode,
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'referral.share_earn'.tr(),
                            textAlign: TextAlign.center,
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _sectionTitle(tt, 'referral.apply_title'.tr()),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _applyCtrl,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'referral.enter_code'.tr(),
                            filled: true,
                            fillColor: cs.surfaceContainerLow,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: cs.outlineVariant.withAlpha(128),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: cs.outlineVariant.withAlpha(128),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: _applying ? null : _applyReferral,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _applying
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('referral.apply'.tr()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _sectionTitle(tt, 'referral.history'.tr()),
                  const SizedBox(height: 16),
                  if (_history.isEmpty)
                    Text('referral.no_history'.tr(), style: tt.bodySmall)
                  else
                    ..._history.map((h) {
                      final name = h['referred_email'] as String? ??
                          h['referee_name'] as String? ??
                          h['referred_name'] as String? ??
                          h['email'] as String? ??
                          'User';
                      final points = h['points_earned'] as int? ?? 0;
                      final rawDate = h['created_at'] as String? ?? '';
                      final date = rawDate.length >= 10
                          ? rawDate.substring(0, 10)
                          : rawDate;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: cs.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: tt.bodyMedium?.copyWith(
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    date,
                                    style: tt.bodySmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+$points ${'loyalty.pts'.tr()}',
                              style: tt.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          );

    return BlocListener<ConnectivityCubit, ConnectivityState>(
      bloc: sl<ConnectivityCubit>(),
      listener: (_, state) {
        if (state is ConnectivityOnline) _reloadAfterReconnect();
      },
      child: body,
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
