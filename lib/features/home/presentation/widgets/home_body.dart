import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/adaptive_content.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
import 'explore_menu_button.dart';
import 'featured_items_view.dart';
import 'home_profile_section.dart';
import 'last_order_card.dart';
import 'section_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveContent(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(top: AppSpacing.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: AppInsets.h16,
              child: HomeProfileSection(),
            ),
            AppSpacing.v16,
            const FeaturedItemsView(),
            AppSpacing.v16,
            Padding(
              padding: AppInsets.h16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (_, state) {
                      if (state case OrdersLoaded(
                        latestOrder: final order?,
                      ) when order.items.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(
                              title: 'home_screen.your_last_order'.tr(),
                            ),
                            AppSpacing.v6,
                            LastOrderCard(),
                            AppSpacing.v16,
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const ExploreMenuButton(),
                  AppSpacing.v40,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
