import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_constants.dart';

class FeaturedItemImage extends StatelessWidget {
  final String imagePath;
  final Color color;
  const FeaturedItemImage({
    super.key,
    required this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(AppDesignConstants.borderRadius2xl),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color,
        child: isNetwork
            ? Image.network(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackAsset(),
              )
            : (imagePath.isNotEmpty)
            ? Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackAsset(),
              )
            : _fallbackAsset(),
      ),
    );
  }

  Widget _fallbackAsset() {
    return Image.asset(
      'assets/images/cardamom_cose_latte.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(color: color),
    );
  }
}
