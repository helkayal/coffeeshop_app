import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_constants.dart';
import 'banner_text_overlay.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Stack(
      children: [
        _buildImage(cs),
        _buildBadge(cs, tt),
        _buildGradient(),
        _buildTextContent(),
      ],
    );
  }

  Widget _buildImage(ColorScheme cs) {
    return ClipRRect(
      borderRadius: AppDesignConstants.radius2xl,
      child: Container(
        color: cs.surfaceContainerHighest,
        child: Image.asset(
          'assets/images/artisanal_coffee_brewing.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8B4513), Color(0xFFD4A574)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(ColorScheme cs, TextTheme tt) {
    return Positioned(
      top: 16,
      right: 16,
      child: Transform.rotate(
        angle: 0.2,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '20% OFF',
            style: tt.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: cs.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppDesignConstants.radius2xl,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xCC000000)],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return const Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: BannerTextOverlay(),
    );
  }
}
