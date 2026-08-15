import '../../../checkout/domain/entities/cart_item.dart';
import '../../domain/entities/saved_customization.dart';

sealed class CustomizationState {
  const CustomizationState();
}

final class CustomizationIdle extends CustomizationState {
  const CustomizationIdle();
}

final class CustomizationLoaded extends CustomizationState {
  final SavedCustomization? customization;

  const CustomizationLoaded(this.customization);
}

final class CustomizationQuickAddReady extends CustomizationState {
  final CartItem item;

  const CustomizationQuickAddReady(this.item);
}

final class CustomizationError extends CustomizationState {
  final String failureCode;

  const CustomizationError(this.failureCode);
}
