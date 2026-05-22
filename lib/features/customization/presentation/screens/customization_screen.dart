import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/addition_card.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/option_group.dart';
import '../widgets/slider_section.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Stack(children: [
      SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(children: [
          _buildHero(context, cs, tt),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
            child: Column(children: [
              OptionGroup(
                title: 'customization.the_base'.tr(),
                requiredLabel: 'customization.required'.tr(),
                options: const [
                  OptionData('Oat', '+ \$1.00', Icons.eco),
                  OptionData('Almond', '+ \$1.00', Icons.spa),
                  OptionData('Whole', 'Included', Icons.water_drop),
                ],
              ),
              const SizedBox(height: 48),
              SliderSection(title: 'customization.sweetness'.tr(), steps: 5, labels: ['customization.sweetness_none','customization.sweetness_light','customization.sweetness_standard','customization.sweetness_extra','customization.sweetness_heavy'].map((k) => k.tr()).toList(), initial: 2),
              const SizedBox(height: 48),
              SliderSection(title: 'customization.espresso_intensity'.tr(), steps: 4, labels: ['customization.intensity_single','customization.intensity_double','customization.intensity_triple','customization.intensity_quad'].map((k) => k.tr()).toList(), initial: 1),
              const SizedBox(height: 48),
              _buildAdditions(tt),
            ]),
          ),
        ]),
      ),
      const PositionedDirectional(start: 0, end: 0, bottom: 0, child: BottomActionBar(total: r'$6.50')),
    ]);
  }

  Widget _buildHero(BuildContext context, ColorScheme cs, TextTheme tt) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(children: [
        Positioned.fill(
          child: Image.asset('assets/menu_images/customization_hero_image.png', fit: BoxFit.fill,
              errorBuilder: (_, _, _) => Container(color: cs.surfaceContainerHighest)),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xFF18120D)]),
            ),
          ),
        ),
        Positioned(
          left: 24, right: 24, bottom: 24,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('customization.iced_oat_cortado'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 36, color: cs.onSurface)),
            const SizedBox(height: 8),
            Text('customization.iced_oat_desc'.tr(), style: tt.bodySmall),
          ]),
        ),
      ]),
    );
  }

  Widget _buildAdditions(TextTheme tt) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text('customization.curated_additions'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 24)),
      ),
      AdditionCard(name: 'customization.vanilla_bean_dust'.tr(), price: '+ \$0.50', icon: Icons.grain),
      const SizedBox(height: 16),
      AdditionCard(name: 'customization.lavender_syrup'.tr(), price: '+ \$0.75', icon: Icons.local_florist),
      const SizedBox(height: 16),
      AdditionCard(name: 'customization.honey_drizzle'.tr(), price: '+ \$0.50', icon: Icons.emoji_nature),
      const SizedBox(height: 16),
      AdditionCard(name: 'customization.cinnamon_dust'.tr(), price: '+ \$0.25', icon: Icons.scatter_plot),
    ]);
  }
}
