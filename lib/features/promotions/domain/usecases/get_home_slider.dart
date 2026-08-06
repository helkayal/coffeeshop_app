import '../../../../core/helpers/result.dart';
import '../entities/home_slider_data.dart';
import '../repositories/promotions_repository.dart';

class GetHomeSliderUseCase {
  final PromotionsRepository _repository;

  GetHomeSliderUseCase(this._repository);

  Future<Result<HomeSliderData>> call() {
    return _repository.getHomeSlider();
  }
}
