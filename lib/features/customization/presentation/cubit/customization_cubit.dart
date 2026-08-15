import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../menu/domain/entities/product.dart';
import '../../domain/entities/saved_customization.dart';
import '../../domain/usecases/customization_usecases.dart';
import 'customization_state.dart';

class CustomizationCubit extends Cubit<CustomizationState> {
  final GetSavedCustomizationUseCase _getSaved;
  final SaveCustomizationUseCase _save;
  final ClearCustomizationUseCase _clear;
  final BuildSavedCartItemUseCase _buildCartItem;

  CustomizationCubit({
    required GetSavedCustomizationUseCase getSaved,
    required SaveCustomizationUseCase save,
    required ClearCustomizationUseCase clear,
    required BuildSavedCartItemUseCase buildCartItem,
  }) : _getSaved = getSaved,
       _save = save,
       _clear = clear,
       _buildCartItem = buildCartItem,
       super(const CustomizationIdle());

  Future<void> load(String productId) async {
    final result = await _getSaved(productId);
    result.fold(
      (failure) => emit(CustomizationError(failure.message)),
      (saved) => emit(CustomizationLoaded(saved)),
    );
  }

  Future<bool> save(String productId, SavedCustomization customization) async {
    final result = await _save(productId, customization);
    return result.fold(
      (failure) {
        emit(CustomizationError(failure.message));
        return false;
      },
      (_) {
        emit(CustomizationLoaded(customization));
        return true;
      },
    );
  }

  Future<void> clear(String productId) async {
    final result = await _clear(productId);
    result.fold(
      (failure) => emit(CustomizationError(failure.message)),
      (_) => emit(const CustomizationLoaded(null)),
    );
  }

  Future<void> buildQuickAdd(Product product) async {
    final result = await _buildCartItem(product);
    result.fold(
      (failure) => emit(CustomizationError(failure.message)),
      (item) => emit(CustomizationQuickAddReady(item)),
    );
  }
}
