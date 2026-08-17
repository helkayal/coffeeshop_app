import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_constants.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import 'banner_text_overlay.dart';

class PromoBanner extends StatelessWidget {
  final String? title;
  final String? description;
  final String? imageUrl;
  final int? discountPercentage;
  final String? menuItemId;
  final String? price;

  const PromoBanner({
    super.key,
    this.title,
    this.description,
    this.imageUrl,
    this.discountPercentage,
    this.menuItemId,
    this.price,
  });

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
    final url = imageUrl;
    final isNetwork =
        url != null &&
        (url.startsWith('http://') || url.startsWith('https://'));

    return ClipRRect(
      borderRadius: AppDesignConstants.radius2xl,
      child: Container(
        color: cs.surfaceContainerHighest,
        child: isNetwork
            ? Image.network(
                url,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildFallbackImage(),
              )
            : (url != null && url.isNotEmpty)
            ? Image.asset(
                url,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildFallbackImage(),
              )
            : _buildFallbackImage(),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      'assets/images/artisanal_coffee_brewing.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [Color(0xFF8B4513), Color(0xFFD4A574)],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(ColorScheme cs, TextTheme tt) {
    final badgeText = discountPercentage != null && discountPercentage! > 0
        ? 'home_screen.percent_off'.tr(
            namedArgs: {'percent': discountPercentage.toString()},
          )
        : 'home_screen.promo_badge'.tr();

    return Positioned(
      top: AppSpacing.s16,
      right: AppSpacing.s16,
      child: Transform.rotate(
        angle: 0.2,
        child: Container(
          padding: AppInsets.h16v8,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            badgeText,
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
    return Positioned(
      left: AppSpacing.s24,
      right: AppSpacing.s24,
      bottom: AppSpacing.s24,
      child: BannerTextOverlay(subtitle: description, title: title),
    );
  }
}
