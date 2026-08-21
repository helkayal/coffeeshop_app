import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/loyalty_history_entry.dart';
import '../cubit/loyalty_history_cubit.dart';
import '../cubit/loyalty_history_state.dart';

class LoyaltyHistoryScreen extends StatefulWidget {
  const LoyaltyHistoryScreen({super.key});

  @override
  State<LoyaltyHistoryScreen> createState() => _LoyaltyHistoryScreenState();
}

class _LoyaltyHistoryScreenState extends State<LoyaltyHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LoyaltyHistoryCubit>().load();
  }

  String _getReasonTitle(String reason) {
    switch (reason) {
      case 'purchase':
        return 'loyalty.reason_purchase'.tr();
      case 'top_up_package':
        return 'loyalty.reason_top_up_package'.tr();
      case 'referral':
        return 'loyalty.reason_referral'.tr();
      case 'review':
        return 'loyalty.reason_review'.tr();
      case 'birthday':
        return 'loyalty.reason_birthday'.tr();
      default:
        return reason.replaceAll('_', ' ');
    }
  }

  IconData _getReasonIcon(String reason) {
    switch (reason) {
      case 'purchase':
        return Icons.shopping_bag_outlined;
      case 'top_up_package':
        return Icons.card_giftcard;
      case 'referral':
        return Icons.share;
      case 'review':
        return Icons.star_outline;
      case 'birthday':
        return Icons.cake_outlined;
      default:
        return Icons.stars;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listener: (_, state) {
        if (state is ConnectivityOnline) {
          context.read<LoyaltyHistoryCubit>().load();
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: BlocBuilder<LoyaltyHistoryCubit, LoyaltyHistoryState>(
          builder: (context, state) => switch (state) {
            LoyaltyHistoryLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            LoyaltyHistoryLoaded(entries: final entries) => RefreshIndicator(
              onRefresh: () => context.read<LoyaltyHistoryCubit>().load(),
              child: entries.isEmpty
                  ? _buildEmpty(cs, tt)
                  : _buildList(cs, tt, entries),
            ),
            LoyaltyHistoryError(:final failureCode) => _buildError(
              cs,
              tt,
              failureCode,
            ),
          },
        ),
      ),
    );
  }

  Widget _buildEmpty(ColorScheme cs, TextTheme tt) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: AppInsets.a32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: cs.onSurfaceVariant.withAlpha(128),
              ),
              AppSpacing.v16,
              Text(
                'loyalty.no_transactions'.tr(),
                style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(ColorScheme cs, TextTheme tt, String failureCode) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: AppInsets.a32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: cs.error.withAlpha(128),
              ),
              AppSpacing.v16,
              Text(
                failureCode.tr(),
                style: tt.bodyLarge?.copyWith(color: cs.error),
                textAlign: TextAlign.center,
              ),
              AppSpacing.v16,
              FilledButton(
                onPressed: () => context.read<LoyaltyHistoryCubit>().load(),
                child: Text('splash_screen.try_again'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    ColorScheme cs,
    TextTheme tt,
    List<LoyaltyHistoryEntry> history,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s24,
        AppSpacing.s32,
        AppSpacing.s24,
        AppSpacing.s96,
      ),
      itemCount: history.length,
      itemBuilder: (_, index) {
        final entry = history[index];
        final points = entry.points;
        final reason = entry.reason;
        final date = DateFormat.yMd(
          context.locale.toString(),
        ).format(entry.createdAt);
        final isPositive = points >= 0;

        return Container(
          padding: AppInsets.a16,
          margin: const EdgeInsets.only(bottom: AppSpacing.s12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withAlpha(80)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPositive
                      ? cs.primary.withAlpha(26)
                      : cs.error.withAlpha(26),
                ),
                child: Icon(
                  _getReasonIcon(reason),
                  color: isPositive ? cs.primary : cs.error,
                  size: 22,
                ),
              ),
              AppSpacing.h14,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getReasonTitle(reason),
                      style: AppTextStyles.bodyMedium(
                        weight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    AppSpacing.v2,
                    Text(
                      date,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: AppInsets.h12v6,
                decoration: BoxDecoration(
                  color: isPositive
                      ? cs.primary.withAlpha(20)
                      : cs.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}$points ${'loyalty.pts'.tr()}',
                  style: AppTextStyles.labelCaps(
                    weight: FontWeight.w700,
                    color: isPositive ? cs.primary : cs.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
