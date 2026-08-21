import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/promotions/data/datasources/promotions_remote_data_source.dart';
import 'package:coffeeshop_app/features/promotions/data/models/home_slider_model.dart';
import 'package:coffeeshop_app/features/promotions/data/repositories/promotions_repository_impl.dart';
import 'package:coffeeshop_app/features/promotions/domain/entities/home_slider_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PromotionsRepositoryImpl.getHomeSlider', () {
    test('returns slider data mapped from the data source model', () async {
      final repository = PromotionsRepositoryImpl(
        _FakePromotionsRemoteDataSource(
          slider: HomeSliderModel.fromJson({
            'data': {
              'highlighted_items': [
                {
                  'id': 'h1',
                  'title': 'Seasonal',
                  'description': 'New drinks',
                  'image_url': 'assets/h1.png',
                  'base_price': '5.00',
                  'menu_item_id': 'mi-1',
                  'category_id': 'cat-1',
                  'category_name': 'Coffee',
                  'display_order': 2,
                },
              ],
              'promotions': [
                {
                  'id': 'p1',
                  'title': 'Happy Hour',
                  'description': '20% off',
                  'image_url': 'assets/p1.png',
                  'discount_percentage': 20,
                  'valid_from': '2026-08-01',
                  'valid_to': '2026-08-31',
                  'display_order': 1,
                },
              ],
            },
          }),
        ),
      );

      final result = await repository.getHomeSlider();

      final data = (result as Success<HomeSliderData>).data;
      final highlight = data.highlightedItems.single;
      expect(highlight.id, 'h1');
      expect(highlight.title, 'Seasonal');
      expect(highlight.imageUrl, 'assets/h1.png');
      expect(highlight.basePrice, '5.00');
      expect(highlight.menuItemId, 'mi-1');
      expect(highlight.categoryId, 'cat-1');
      expect(highlight.categoryName, 'Coffee');
      expect(highlight.displayOrder, 2);
      final banner = data.promotions.single;
      expect(banner.id, 'p1');
      expect(banner.discountPercentage, 20);
      expect(banner.validFrom, '2026-08-01');
      expect(banner.validTo, '2026-08-31');
      expect(banner.displayOrder, 1);
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = PromotionsRepositoryImpl(
        _FakePromotionsRemoteDataSource(
          slider: HomeSliderModel.fromJson({}),
          error: const ServerException('promotions_down'),
        ),
      );

      final result = await repository.getHomeSlider();

      final failure = (result as Error<HomeSliderData>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'promotions_down');
    });

    test(
      'falls back to the default key when the ServerException has no message',
      () async {
        final repository = PromotionsRepositoryImpl(
          _FakePromotionsRemoteDataSource(
          slider: HomeSliderModel.fromJson({}),
          error: const ServerException(),
        ),
        );

        final result = await repository.getHomeSlider();

        expect(
          (result as Error<HomeSliderData>).failure.message,
          'errors.promotions_load_failed',
        );
      },
    );

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = PromotionsRepositoryImpl(
        _FakePromotionsRemoteDataSource(
          slider: HomeSliderModel.fromJson({}),
          error: const ConnectionException('no network'),
        ),
      );

      final result = await repository.getHomeSlider();

      final failure = (result as Error<HomeSliderData>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = PromotionsRepositoryImpl(
        _FakePromotionsRemoteDataSource(
          slider: HomeSliderModel.fromJson({}),
          error: Exception('boom'),
        ),
      );

      final result = await repository.getHomeSlider();

      final failure = (result as Error<HomeSliderData>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });
}

class _FakePromotionsRemoteDataSource implements PromotionsRemoteDataSource {
  _FakePromotionsRemoteDataSource({required this.slider, this.error});

  final HomeSliderModel slider;
  final Exception? error;

  @override
  Future<HomeSliderModel> getHomeSlider() async {
    final e = error;
    if (e != null) throw e;
    return slider;
  }
}
