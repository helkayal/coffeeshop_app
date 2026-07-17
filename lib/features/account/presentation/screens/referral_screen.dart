import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';

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

  Future<void> _applyReferral() async {
    final code = _applyCtrl.text.trim();
    if (code.isEmpty) return;
    try {
      await _api.post(ApiConstants.referralApply, data: {'code': code});
      _applyCtrl.clear();
      await _load();
    } catch (_) {}
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
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant.withAlpha(128)),
          ),
          child: Column(children: [
            Icon(Icons.share, size: 48, color: cs.primary),
            const SizedBox(height: 16),
            Text('referral.your_code'.tr(),
                style: tt.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant, letterSpacing: 2, fontSize: 10)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(_code,
                  style: tt.headlineMedium?.copyWith(
                      fontSize: 28, letterSpacing: 6,
                      fontWeight: FontWeight.w800, color: cs.onSurface)),
            ),
            const SizedBox(height: 16),
            Text('referral.share_earn'.tr(), style: tt.bodySmall),
            const SizedBox(height: 4),
            Text('referral.reward'.tr(),
                style: tt.bodyLarge?.copyWith(
                    color: cs.primary, fontWeight: FontWeight.w700)),
          ]),
        ),
        const SizedBox(height: 40),
        _sectionTitle(tt, 'Apply a Referral Code'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _applyCtrl,
              decoration: InputDecoration(
                hintText: 'Enter referral code',
                filled: true,
                fillColor: cs.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: _applyReferral,
            child: const Text('Apply'),
          ),
        ]),
        const SizedBox(height: 40),
        _sectionTitle(tt, 'referral.history'.tr()),
        const SizedBox(height: 16),
        if (_history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text('No referrals yet', style: tt.bodySmall),
            ),
          )
        else
          ..._history.map((r) => _referralTile(
            cs, tt,
            r['referred_email'] as String? ?? '',
            '+${r['points_earned'] ?? 0}',
            (r['created_at'] as String? ?? '').substring(0, 10),
          )),
      ]),
    ),
  );
  }

  Widget _referralTile(
      ColorScheme cs, TextTheme tt, String name, String points, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: cs.primary.withAlpha(26)),
          child: Icon(Icons.person, color: cs.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface, fontWeight: FontWeight.w500)),
            Text(date, style: tt.bodySmall),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: cs.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8)),
          child: Text(points,
              style: tt.labelLarge?.copyWith(
                  color: cs.primary, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(text,
        style: tt.headlineMedium?.copyWith(
            fontSize: 20, fontWeight: FontWeight.w700));
  }
}
