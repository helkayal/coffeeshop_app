import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/result.dart';
import '../../domain/usecases/get_home_slider.dart';
import 'promotions_state.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  final GetHomeSliderUseCase _getHomeSliderUseCase;

  PromotionsCubit(this._getHomeSliderUseCase) : super(const PromotionsInitial());

  Future<void> loadPromotions() async {
    emit(const PromotionsLoading());
    final result = await _getHomeSliderUseCase();
    switch (result) {
      case Success(:final data):
        emit(PromotionsLoaded(data));
      case Error(:final failure):
        emit(PromotionsError(failure.message));
    }
  }
}
