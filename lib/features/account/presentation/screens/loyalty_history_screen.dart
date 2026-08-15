import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../domain/entities/loyalty_history_entry.dart';
import '../cubit/loyalty_history_cubit.dart';
import '../cubit/loyalty_history_state.dart';

class LoyaltyHistoryScreen extends StatefulWidget {
  const LoyaltyHistoryScreen({super.key});

  @override
  State<LoyaltyHistoryScreen> createState() => _LoyaltyHistoryScreenState();
}

class _LoyaltyHistoryScreenState extends State<LoyaltyHistoryScreen> {
  List<LoyaltyHistoryEntry> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await context.read<LoyaltyHistoryCubit>().load();
  }

  void _reloadAfterReconnect() {
    if (!mounted) return;
    setState(() => _loading = true);
    _load();
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

    return BlocListener<LoyaltyHistoryCubit, LoyaltyHistoryState>(
      listener: (_, state) {
        if (state is LoyaltyHistoryLoading) {
          setState(() => _loading = true);
        } else if (state is LoyaltyHistoryLoaded) {
          setState(() {
            _history = state.entries;
            _loading = false;
          });
        } else if (state is LoyaltyHistoryError) {
          setState(() => _loading = false);
        }
      },
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (_, state) {
          if (state is ConnectivityOnline) _reloadAfterReconnect();
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          body: RefreshIndicator(
            onRefresh: _load,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: cs.onSurfaceVariant.withAlpha(128),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'loyalty.no_transactions'.tr(),
                              style: tt.bodyLarge?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
                    itemCount: _history.length,
                    itemBuilder: (_, i) {
                      final t = _history[i];
                      final points = t.points;
                      final reason = t.reason;
                      final date = DateFormat.yMd(
                        context.locale.toString(),
                      ).format(t.createdAt);
                      final isPositive = points >= 0;

                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cs.outlineVariant.withAlpha(80),
                          ),
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
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getReasonTitle(reason),
                                    style: tt.bodyMedium?.copyWith(
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isPositive
                                    ? cs.primary.withAlpha(20)
                                    : cs.error.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${isPositive ? '+' : ''}$points ${'loyalty.pts'.tr()}',
                                style: tt.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isPositive ? cs.primary : cs.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
