import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/referral_history_entry.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/referral_cubit.dart';
import '../cubit/referral_state.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final _applyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ReferralCubit>().loadReferral();
  }

  @override
  void dispose() {
    _applyCtrl.dispose();
    super.dispose();
  }

  void _shareCode(String code) {
    if (code.isEmpty) return;
    Share.share('referral.share_text'.tr(namedArgs: {'code': code}));
  }

  void _copyCode(String code) {
    if (code.isEmpty) return;
    Clipboard.setData(ClipboardData(text: code));
    AppSnackBar.show(
      context,
      'referral.code_copied'.tr(),
      type: SnackBarType.success,
    );
  }

  void _applyReferral() {
    final code = _applyCtrl.text.trim();
    if (code.isEmpty) return;
    context.read<ReferralCubit>().applyReferral(code);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocConsumer<ReferralCubit, ReferralState>(
      listener: (context, state) {
        if (state is ReferralApplySuccess) {
          _applyCtrl.clear();
          context.read<ProfileCubit>().loadProfile();
          AppSnackBar.show(
            context,
            'referral.applied_success'.tr(),
            type: SnackBarType.success,
          );
        } else if (state is ReferralApplyError) {
          AppSnackBar.show(context, state.message, type: SnackBarType.error);
        }
      },
      builder: (context, state) {
        if (state is ReferralLoading || state is ReferralInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        final code = state is ReferralLoaded ? state.code : '';
        final history = state is ReferralLoaded ? state.history : [];
        final isApplying = state is ReferralLoaded && state.isApplying;

        return BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (_, connState) {
            if (connState is ConnectivityOnline) {
              context.read<ReferralCubit>().loadReferral();
            }
          },
          child: Scaffold(
            backgroundColor: cs.surface,
            body: SingleChildScrollView(
              padding: AppInsets.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReferralCodeCard(
                    code: code,
                    onShare: () => _shareCode(code),
                    onCopy: () => _copyCode(code),
                  ),
                  AppSpacing.v32,
                  Text(
                    'referral.apply_title'.tr(),
                    style: tt.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.v16,
                  _ApplyReferralRow(
                    controller: _applyCtrl,
                    isApplying: isApplying,
                    onApply: _applyReferral,
                  ),
                  AppSpacing.v40,
                  Text(
                    'referral.history'.tr(),
                    style: tt.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.v16,
                  if (history.isEmpty)
                    Text('referral.no_history'.tr(), style: tt.bodySmall)
                  else
                    ...history.map((h) => _ReferralHistoryTile(item: h)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReferralCodeCard extends StatelessWidget {
  final String code;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  const _ReferralCodeCard({
    required this.code,
    required this.onShare,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Container(
        width: double.infinity,
        padding: AppInsets.a20,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant.withAlpha(128)),
        ),
        child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              color: cs.primary,
              tooltip: 'referral.share'.tr(),
              onPressed: onShare,
            ),
            AppSpacing.v12,
            Container(
              padding: AppInsets.h16v10,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.primary.withAlpha(77)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        code,
                        style: tt.titleMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.h8,
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    color: cs.primary,
                    onPressed: onCopy,
                    constraints: const BoxConstraints(),
                    padding: AppInsets.zero,
                  ),
                ],
              ),
            ),
            AppSpacing.v12,
            Text(
              'referral.share_earn'.tr(),
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplyReferralRow extends StatelessWidget {
  final TextEditingController controller;
  final bool isApplying;
  final VoidCallback onApply;

  const _ApplyReferralRow({
    required this.controller,
    required this.isApplying,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'referral.enter_code'.tr(),
              filled: true,
              fillColor: cs.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cs.outlineVariant.withAlpha(128)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cs.outlineVariant.withAlpha(128)),
              ),
            ),
          ),
        ),
        AppSpacing.h12,
        FilledButton(
          onPressed: isApplying ? null : onApply,
          style: FilledButton.styleFrom(
            padding: AppInsets.h24v16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isApplying
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
    );
  }
}

class _ReferralHistoryTile extends StatelessWidget {
  final ReferralHistoryEntry item;

  const _ReferralHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final date = DateFormat.yMd(
      context.locale.toString(),
    ).format(item.createdAt);

    return Container(
      padding: AppInsets.a16,
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: cs.primary, size: 24),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.referredEmail,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            'loyalty.points_value'.tr(
              namedArgs: {'points': '+${item.pointsEarned}'},
            ),
            style: tt.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}
