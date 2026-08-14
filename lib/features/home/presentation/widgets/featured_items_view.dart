import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../promotions/domain/entities/home_slider_data.dart';
import '../../../promotions/presentation/cubit/promotions_cubit.dart';
import '../../../promotions/presentation/cubit/promotions_state.dart';
import 'featured_item_card.dart';
import 'promo_banner.dart';

class FeaturedItemsView extends StatefulWidget {
  const FeaturedItemsView({super.key});

  @override
  State<FeaturedItemsView> createState() => _FeaturedItemsViewState();
}

class _FeaturedItemsViewState extends State<FeaturedItemsView> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  int _itemCount = 0;

  static const _autoAdvanceDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance(int totalPages) {
    if (totalPages <= 0) return;
    _timer?.cancel();
    _timer = Timer.periodic(_autoAdvanceDuration, (_) {
      if (!mounted || totalPages <= 0) return;
      final nextPage = (_currentPage + 1) % totalPages;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int page, int totalPages) {
    setState(() => _currentPage = page);
    _startAutoAdvance(totalPages);
  }

  List<Widget> _buildPages(HomeSliderData data) {
    final pages = <Widget>[];
    final highlights = data.highlightedItems;
    final promos = data.promotions;

    final maxLength = highlights.length > promos.length
        ? highlights.length
        : promos.length;

    for (var i = 0; i < maxLength; i++) {
      if (i < highlights.length) {
        final h = highlights[i];
        pages.add(
          FeaturedItemCard(
            imagePath: h.imageUrl,
            name: h.title,
            description: h.description,
            price: '${h.basePrice} EGP',
            menuItemId: h.menuItemId,
          ),
        );
      }
      if (i < promos.length) {
        final p = promos[i];
        pages.add(
          PromoBanner(
            title: p.title,
            description: p.description,
            imageUrl: p.imageUrl,
            discountPercentage: p.discountPercentage,
          ),
        );
      }
    }

    return pages;
  }

  Widget _buildCarousel(List<Widget> pages) {
    if (_itemCount != pages.length) {
      _itemCount = pages.length;
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoAdvance(_itemCount);
      });
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (page) => _onPageChanged(page, pages.length),
          itemCount: pages.length,
          itemBuilder: (_, index) => pages[index],
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: _buildIndicators(pages.length),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.4;

    return SizedBox(
      height: cardHeight,
      child: BlocBuilder<PromotionsCubit, PromotionsState>(
        builder: (context, state) {
          switch (state) {
            case PromotionsInitial() || PromotionsLoading():
              return const Center(child: CircularProgressIndicator());
            case PromotionsError(:final message):
              return Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            case PromotionsLoaded(:final data):
              final pages = _buildPages(data);
              if (pages.isEmpty) {
                _timer?.cancel();
                _itemCount = 0;
                return const SizedBox.shrink();
              }
              return _buildCarousel(pages);
          }
        },
      ),
    );
  }

  Widget _buildIndicators(int count) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive ? cs.primary : cs.outlineVariant,
          ),
        );
      }),
    );
  }
}
