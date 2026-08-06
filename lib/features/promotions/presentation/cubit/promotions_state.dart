import '../../domain/entities/home_slider_data.dart';

sealed class PromotionsState {
  const PromotionsState();
}

class PromotionsInitial extends PromotionsState {
  const PromotionsInitial();
}

class PromotionsLoading extends PromotionsState {
  const PromotionsLoading();
}

class PromotionsLoaded extends PromotionsState {
  final HomeSliderData data;

  const PromotionsLoaded(this.data);
}

class PromotionsError extends PromotionsState {
  final String message;

  const PromotionsError(this.message);
}
