import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/promotions/domain/entities/highlighted_item.dart';
import 'package:coffeeshop_app/features/promotions/domain/entities/home_slider_data.dart';
import 'package:coffeeshop_app/features/promotions/domain/entities/promotion_banner.dart';
import 'package:coffeeshop_app/features/promotions/domain/repositories/promotions_repository.dart';
import 'package:coffeeshop_app/features/promotions/domain/usecases/get_home_slider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetHomeSliderUseCase', () {
    test('returns the home slider data from the repository', () async {
      final useCase = GetHomeSliderUseCase(
        _FakePromotionsRepository(result: const Success(_slider)),
      );

      final result = await useCase();

      final data = (result as Success<HomeSliderData>).data;
      expect(data.highlightedItems.single.id, 'h1');
      expect(data.promotions.single.id, 'p1');
    });

    test('propagates a repository failure', () async {
      final useCase = GetHomeSliderUseCase(
        _FakePromotionsRepository(
          result: const Error(ServerFailure('errors.promotions_load_failed')),
        ),
      );

      final result = await useCase();

      expect(
        (result as Error<HomeSliderData>).failure.message,
        'errors.promotions_load_failed',
      );
    });
  });

  group('HomeSliderData', () {
    test('reports empty only when both lists are empty', () {
      expect(const HomeSliderData(highlightedItems: [], promotions: []).isEmpty,
          isTrue);
      expect(_slider.isEmpty, isFalse);
    });
  });
}

const _slider = HomeSliderData(
  highlightedItems: [
    HighlightedItem(
      id: 'h1',
      title: 'Seasonal',
      description: 'New drinks',
      imageUrl: 'assets/h1.png',
      basePrice: '5.00',
      menuItemId: 'mi-1',
      categoryId: 'cat-1',
      categoryName: 'Coffee',
      displayOrder: 1,
    ),
  ],
  promotions: [
    PromotionBanner(
      id: 'p1',
      title: 'Happy Hour',
      description: '20% off',
      imageUrl: 'assets/p1.png',
      discountPercentage: 20,
      displayOrder: 2,
    ),
  ],
);

class _FakePromotionsRepository implements PromotionsRepository {
  _FakePromotionsRepository({required this.result});

  final Result<HomeSliderData> result;

  @override
  Future<Result<HomeSliderData>> getHomeSlider() async => result;
}
