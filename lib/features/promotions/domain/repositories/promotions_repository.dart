import '../../../../core/helpers/result.dart';
import '../entities/home_slider_data.dart';

abstract class PromotionsRepository {
  Future<Result<HomeSliderData>> getHomeSlider();
}
