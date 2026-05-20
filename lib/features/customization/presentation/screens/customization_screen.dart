import 'package:flutter/material.dart';

import '../../../../core/widgets/app_app_bar.dart';
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

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const AppAppBar(title: 'Coffee Shop', leading: BackButton()),
      body: Stack(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(children: [
            _buildHero(cs, tt),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
              child: Column(children: [
                const OptionGroup(
                  title: 'The Base', requiredLabel: 'Required',
                  options: [
                    OptionData('Oat', '+ \$1.00', Icons.eco, true),
                    OptionData('Almond', '+ \$1.00', Icons.spa),
                    OptionData('Whole', 'Included', Icons.water_drop),
                  ],
                ),
                const SizedBox(height: 48),
                const SliderSection(title: 'Sweetness', steps: 5,
                    labels: ['None', 'Light', 'Standard', 'Extra', 'Heavy'], initial: 2),
                const SizedBox(height: 48),
                const SliderSection(title: 'Espresso Intensity', steps: 4,
                    labels: ['Single', 'Double', 'Triple', 'Quad'], initial: 1),
                const SizedBox(height: 48),
                _buildAdditions(tt),
              ]),
            ),
          ]),
        ),
        const Positioned(
          left: 0, right: 0, bottom: 0,
          child: BottomActionBar(total: r'$6.50'),
        ),
      ]),
    );
  }

  Widget _buildHero(ColorScheme cs, TextTheme tt) {
    return SizedBox(
      height: 320,
      child: Stack(children: [
        Container(color: cs.surfaceContainerHighest),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF18120D)],
              ),
            ),
          ),
        ),
        Positioned(
          left: 24, right: 24, bottom: 24,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('Iced Oat Cortado', style: tt.headlineMedium?.copyWith(fontSize: 36, color: cs.onSurface)),
            const SizedBox(height: 8),
            Text('A meticulous blend of our house espresso, cut with chilled oat milk.', style: tt.bodySmall),
          ]),
        ),
      ]),
    );
  }

  Widget _buildAdditions(TextTheme tt) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text('Curated Additions', style: tt.headlineMedium?.copyWith(fontSize: 24)),
      ),
      const AdditionCard(name: 'Vanilla Bean Dust', price: '+ \$0.50', icon: Icons.grain),
      const SizedBox(height: 16),
      const AdditionCard(name: 'Lavender Syrup', price: '+ \$0.75', icon: Icons.local_florist),
      const SizedBox(height: 16),
      const AdditionCard(name: 'Honey Drizzle', price: '+ \$0.50', icon: Icons.emoji_nature),
      const SizedBox(height: 16),
      const AdditionCard(name: 'Cinnamon Dust', price: '+ \$0.25', icon: Icons.scatter_plot),
    ]);
  }
}
