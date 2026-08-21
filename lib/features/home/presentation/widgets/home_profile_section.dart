import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../account/presentation/cubit/profile_cubit.dart';
import '../../../account/presentation/cubit/profile_state.dart';

class HomeProfileSection extends StatelessWidget {
  const HomeProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final name = switch (state) {
          ProfileLoaded(:final profile) =>
            '${profile.firstName} ${profile.lastName}',
          _ => 'common.not_available'.tr(),
        };
        final points = switch (state) {
          ProfileLoaded(:final loyaltyPoints) => loyaltyPoints.toStringAsFixed(
            0,
          ),
          _ => 'common.not_available'.tr(),
        };
        final avatarUrl = switch (state) {
          ProfileLoaded(:final profile) => profile.avatarUrl,
          _ => null,
        };
        final gender = switch (state) {
          ProfileLoaded(:final profile) => profile.gender,
          _ => null,
        };

        return Row(
          children: [
            _Avatar(avatarUrl: avatarUrl, gender: gender),
            AppSpacing.h12,
            _NameSection(name: name),
            _PointsSection(points: points),
          ],
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String? gender;
  const _Avatar({required this.avatarUrl, required this.gender});

  String? get _fullUrl => avatarUrl != null
      ? '${ApiConstants.apiBaseUrl.replaceAll('/api/v1', '')}$avatarUrl'
      : null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fullUrl = _fullUrl;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cs.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: fullUrl != null
          ? CachedNetworkImage(
              imageUrl: fullUrl,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => _placeholder(cs),
            )
          : _placeholder(cs),
    );
  }

  Widget _placeholder(ColorScheme cs) {
    final asset = gender == 'female'
        ? 'assets/images/female_placeholder.png'
        : 'assets/images/male_placeholder.png';
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Icon(Icons.person, color: cs.onSurfaceVariant),
    );
  }
}

class _NameSection extends StatelessWidget {
  final String name;
  const _NameSection({required this.name});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home_screen.welcome'.tr(),
            style: AppTextStyles.bodySmall(color: cs.onSurfaceVariant),
          ),
          AppSpacing.v2,
          Text(
            name,
            style: AppTextStyles.subtitleSm(
              weight: FontWeight.w700,
              color: cs.onSurface,
            ).copyWith(height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _PointsSection extends StatelessWidget {
  final String points;
  const _PointsSection({required this.points});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          points,
          style: AppTextStyles.bodyLarge(
            weight: FontWeight.w700,
            color: cs.primary,
          ),
        ),
        Text(
          'home_screen.points'.tr(),
          style: AppTextStyles.labelCaps(color: cs.onSurfaceVariant)
              .copyWith(letterSpacing: 2),
        ),
      ],
    );
  }
}
