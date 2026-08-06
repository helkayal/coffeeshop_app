import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_constants.dart';
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
    final isNetwork = imageUrl != null &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'));

    return ClipRRect(
      borderRadius: AppDesignConstants.radius2xl,
      child: Container(
        color: cs.surfaceContainerHighest,
        child: isNetwork
            ? Image.network(
                imageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildFallbackImage(),
              )
            : (imageUrl != null && imageUrl!.isNotEmpty)
                ? Image.asset(
                    imageUrl!,
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
        ? '$discountPercentage% OFF'
        : 'home_screen.promo_badge'.tr();

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
      left: 24,
      right: 24,
      bottom: 24,
      child: BannerTextOverlay(
        subtitle: description,
        title: title,
      ),
    );
  }
}
