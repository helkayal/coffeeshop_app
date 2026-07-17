import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';

class LoyaltyHistoryScreen extends StatefulWidget {
  const LoyaltyHistoryScreen({super.key});

  @override
  State<LoyaltyHistoryScreen> createState() => _LoyaltyHistoryScreenState();
}

class _LoyaltyHistoryScreenState extends State<LoyaltyHistoryScreen> {
  final _api = sl<ApiService>();
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.get(ApiConstants.loyaltyHistory);
      if (mounted) {
        setState(() {
          _history = List<Map<String, dynamic>>.from(data as List);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? Center(
                  child: Text('No loyalty transactions yet',
                      style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
                  itemCount: _history.length,
                  itemBuilder: (_, i) {
                    final t = _history[i];
                    final points = (t['points'] as num?)?.toInt() ?? 0;
                    final reason = t['reason'] as String? ?? '';
                    final date = (t['created_at'] as String? ?? '').substring(0, 10);
                    final isPositive = points >= 0;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Icon(
                          isPositive ? Icons.add_circle : Icons.remove_circle,
                          color: isPositive ? cs.primary : cs.error,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reason.replaceAll('_', ' '),
                                  style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
                              Text(date, style: tt.bodySmall),
                            ],
                          ),
                        ),
                        Text('${isPositive ? '+' : ''}$points pts',
                            style: tt.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isPositive ? cs.primary : cs.error)),
                      ]),
                    );
                  },
                ),
    );
  }
}
