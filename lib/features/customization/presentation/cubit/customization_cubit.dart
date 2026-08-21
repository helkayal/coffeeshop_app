import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../menu/domain/entities/option_group.dart';
import '../../../menu/domain/entities/option_value.dart';
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

  /// Starts the customization builder for [product], seeding selections
  /// from the saved customization when one exists.
  Future<void> startBuilder(Product product) async {
    final result = await _getSaved(product.id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CustomizationError(failure.message)),
      (saved) => emit(_buildState(product, saved)),
    );
  }

  CustomizationBuilder _buildState(Product product, SavedCustomization? saved) {
    final picked = <String, OptionValue>{};
    final toggled = <String, List<OptionValue>>{};
    var total = product.basePrice;

    for (final group in product.optionGroups) {
      if (group.isMulti) {
        final ids = saved?.toggledOptionIds[group.id] ?? const <String>[];
        final selected = group.values
            .where((value) => ids.contains(value.id))
            .toList();
        for (final value in selected) {
          total += value.priceModifier;
        }
        toggled[group.id] = selected;
      } else {
        OptionValue? option;
        final savedId = saved?.pickedOptionIds[group.id];
        if (savedId != null) {
          option = group.values.cast<OptionValue?>().firstWhere(
            (value) => value?.id == savedId,
            orElse: () => null,
          );
        }
        option ??= group.values.isNotEmpty ? group.values.first : null;
        if (option != null) {
          picked[group.id] = option;
          total += option.priceModifier;
        }
      }
    }

    return CustomizationBuilder(
      product: product,
      picked: picked,
      toggled: toggled,
      savedPickedIds: picked.map((key, value) => MapEntry(key, value.id)),
      savedToggledIds: toggled.map(
        (key, value) =>
            MapEntry(key, (value.map((v) => v.id).toList()..sort())),
      ),
      total: total,
    );
  }

  void selectSingle(OptionGroup group, OptionValue value) {
    final current = state;
    if (current is! CustomizationBuilder) return;
    final old = current.picked[group.id];
    emit(
      current.copyWith(
        picked: {...current.picked, group.id: value},
        total: current.total - (old?.priceModifier ?? 0) + value.priceModifier,
      ),
    );
  }

  void selectMulti(OptionGroup group, List<OptionValue> values) {
    final current = state;
    if (current is! CustomizationBuilder) return;
    var delta = 0.0;
    for (final value in values) {
      delta += value.priceModifier;
    }
    for (final old in current.toggled[group.id] ?? const <OptionValue>[]) {
      delta -= old.priceModifier;
    }
    emit(
      current.copyWith(
        toggled: {...current.toggled, group.id: values},
        total: current.total + delta,
      ),
    );
  }

  /// Persists the current selections as the saved customization and marks
  /// them as the new baseline. Returns true on success.
  Future<bool> saveSelections(String productId) async {
    final current = state;
    if (current is! CustomizationBuilder) return false;

    final customization = SavedCustomization(
      pickedOptionIds: current.picked.map(
        (key, value) => MapEntry(key, value.id),
      ),
      toggledOptionIds: current.toggled.map(
        (key, value) => MapEntry(key, value.map((v) => v.id).toList()),
      ),
    );

    final result = await _save(productId, customization);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(CustomizationError(failure.message));
        return false;
      },
      (_) {
        emit(
          current.withSavedSnapshot(
            savedPickedIds: current.picked.map(
              (key, value) => MapEntry(key, value.id),
            ),
            savedToggledIds: current.toggled.map(
              (key, value) =>
                  MapEntry(key, (value.map((v) => v.id).toList()..sort())),
            ),
          ),
        );
        return true;
      },
    );
  }

  Future<void> clear(String productId) async {
    final previous = state;
    final result = await _clear(productId);
    if (isClosed) return;
    result.fold(
      (failure) {
        // Clearing is best-effort from the favorite-toggle flow: keep the
        // builder intact so the screen does not jump to an error view.
        if (previous is! CustomizationBuilder) {
          emit(CustomizationError(failure.message));
        }
      },
      (_) {
        // With an active builder, leave its saved snapshot untouched —
        // clearing storage must not mark the current selections as changed.
        if (previous is! CustomizationBuilder) {
          emit(const CustomizationLoaded(null));
        }
      },
    );
  }

  Future<void> buildQuickAdd(Product product) async {
    final result = await _buildCartItem(product);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CustomizationError(failure.message)),
      (item) => emit(CustomizationQuickAddReady(item)),
    );
  }
}
