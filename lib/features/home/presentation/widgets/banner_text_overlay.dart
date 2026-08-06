import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BannerTextOverlay extends StatelessWidget {
  final String? subtitle;
  final String? title;

  const BannerTextOverlay({
    super.key,
    this.subtitle,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          subtitle ?? 'home_screen.limited_release'.tr(),
          style: tt.labelSmall?.copyWith(letterSpacing: 2, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          title ?? 'home_screen.autumn_blend'.tr(),
          style: tt.displaySmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
