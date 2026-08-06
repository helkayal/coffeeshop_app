import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/home_slider_model.dart';
import 'promotions_remote_data_source.dart';

class PromotionsRemoteDataSourceImpl implements PromotionsRemoteDataSource {
  final ApiService _apiService;

  PromotionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<HomeSliderModel> getHomeSlider() async {
    final response = await _apiService.get(ApiConstants.promotions);
    return HomeSliderModel.fromJson(response as Map<String, dynamic>);
  }
}
