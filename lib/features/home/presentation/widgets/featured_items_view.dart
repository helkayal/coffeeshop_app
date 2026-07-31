import 'dart:async';

import 'package:flutter/material.dart';

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

  static const _autoAdvanceDuration = Duration(seconds: 4);
  static const _pageCount = 5;

  static const _pages = <Widget>[
    FeaturedItemCard(
      imagePath: 'assets/images/cardamom_cose_latte.png',
      name: 'Cardamom Rose Latte',
      description:
          'Robust espresso, steamed oat milk, and house-made cardamom-rose syrup.',
      price: r'$7.25',
    ),
    PromoBanner(),
    FeaturedItemCard(
      imagePath: 'assets/images/cardamom_cose_latte.png',
      name: 'Cardamom Rose Latte',
      description:
          'Robust espresso, steamed oat milk, and house-made cardamom-rose syrup.',
      price: r'$7.25',
    ),
    PromoBanner(),
    PromoBanner(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoAdvanceDuration, (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _pageCount;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _startAutoAdvance();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.4;

    return SizedBox(
      height: cardHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pageCount,
            itemBuilder: (_, index) => _pages[index],
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: _buildIndicators(),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pageCount, (i) {
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
