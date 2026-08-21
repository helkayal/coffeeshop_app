import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/home_slider_data.dart';
import '../../domain/repositories/promotions_repository.dart';
import '../datasources/promotions_remote_data_source.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteDataSource _remoteDataSource;

  PromotionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<HomeSliderData>> getHomeSlider() async {
    try {
      final model = await _remoteDataSource.getHomeSlider();
      return Success(model);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.promotions_load_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (e) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }
}
