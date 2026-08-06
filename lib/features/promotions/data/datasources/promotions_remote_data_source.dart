import '../models/home_slider_model.dart';

abstract class PromotionsRemoteDataSource {
  Future<HomeSliderModel> getHomeSlider();
}
