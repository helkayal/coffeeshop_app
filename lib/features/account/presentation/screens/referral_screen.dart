import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/referral_cubit.dart';
import '../cubit/referral_state.dart';
import '../widgets/apply_referral_row.dart';
import '../widgets/referral_code_card.dart';
import '../widgets/referral_history_tile.dart';

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
                  ReferralCodeCard(
                    code: code,
                    onShare: () => _shareCode(code),
                    onCopy: () => _copyCode(code),
                  ),
                  AppSpacing.v32,
                  Text(
                    'referral.apply_title'.tr(),
                    style: AppTextStyles.subtitle(
                      weight: FontWeight.w700,
                      color: cs.onSurface,
                    ).copyWith(height: 1.3),
                  ),
                  AppSpacing.v16,
                  ApplyReferralRow(
                    controller: _applyCtrl,
                    isApplying: isApplying,
                    onApply: _applyReferral,
                  ),
                  AppSpacing.v40,
                  Text(
                    'referral.history'.tr(),
                    style: AppTextStyles.subtitle(
                      weight: FontWeight.w700,
                      color: cs.onSurface,
                    ).copyWith(height: 1.3),
                  ),
                  AppSpacing.v16,
                  if (history.isEmpty)
                    Text('referral.no_history'.tr(), style: tt.bodySmall)
                  else
                    ...history.map((h) => ReferralHistoryTile(item: h)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
