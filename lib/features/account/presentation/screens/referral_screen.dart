import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    const code = 'COFFEE50';

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant.withAlpha(128)),
          ),
          child: Column(children: [
            Icon(Icons.share, size: 48, color: cs.primary),
            const SizedBox(height: 16),
            Text('referral.your_code'.tr(), style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant, letterSpacing: 2, fontSize: 10)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
              child: Text(code, style: tt.headlineMedium?.copyWith(fontSize: 28, letterSpacing: 6, fontWeight: FontWeight.w800, color: cs.onSurface)),
            ),
            const SizedBox(height: 16),
            Text('referral.share_earn'.tr(), style: tt.bodySmall),
            const SizedBox(height: 4),
            Text('referral.reward'.tr(), style: tt.bodyLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.w700)),
          ]),
        ),
        const SizedBox(height: 40),
        _sectionTitle(tt, 'referral.history'.tr()),
        const SizedBox(height: 16),
        _referralTile(cs, tt, 'Ahmed M.', '+50', '12/05/2025'),
        _referralTile(cs, tt, 'Sara K.', '+50', '08/05/2025'),
        _referralTile(cs, tt, 'Omar H.', '+50', '01/04/2025'),
        _referralTile(cs, tt, 'Laila G.', '+50', '15/03/2025'),
      ]),
    );
  }

  Widget _referralTile(ColorScheme cs, TextTheme tt, String name, String points, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(shape: BoxShape.circle, color: cs.primary.withAlpha(26)),
          child: Icon(Icons.person, color: cs.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: tt.bodyMedium?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w500)),
            Text(date, style: tt.bodySmall),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: cs.primary.withAlpha(26), borderRadius: BorderRadius.circular(8)),
          child: Text(points, style: tt.labelLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(text, style: tt.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700));
  }
}
