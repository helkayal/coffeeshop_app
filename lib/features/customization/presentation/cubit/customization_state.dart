import '../../../checkout/domain/entities/cart_item.dart';
import '../../../menu/domain/entities/option_group.dart';
import '../../../menu/domain/entities/option_value.dart';
import '../../../menu/domain/entities/product.dart';
import '../../domain/entities/saved_customization.dart';

sealed class CustomizationState {
  const CustomizationState();
}

final class CustomizationIdle extends CustomizationState {
  const CustomizationIdle();
}

/// Interactive builder state for the customization screen: current
/// selections, the saved snapshot they are compared against, and the
/// running total.
final class CustomizationBuilder extends CustomizationState {
  final Product product;
  final Map<String, OptionValue> picked;
  final Map<String, List<OptionValue>> toggled;
  final Map<String, String> savedPickedIds;
  final Map<String, List<String>> savedToggledIds;
  final double total;

  const CustomizationBuilder({
    required this.product,
    required this.picked,
    required this.toggled,
    required this.savedPickedIds,
    required this.savedToggledIds,
    required this.total,
  });

  bool get hasChanged {
    for (final entry in picked.entries) {
      if (savedPickedIds[entry.key] != entry.value.id) return true;
    }
    for (final entry in toggled.entries) {
      final currentIds = entry.value.map((v) => v.id).toList()..sort();
      final savedIds = savedToggledIds[entry.key] ?? const <String>[];
      if (currentIds.length != savedIds.length) return true;
      for (int i = 0; i < currentIds.length; i++) {
        if (currentIds[i] != savedIds[i]) return true;
      }
    }
    return false;
  }

  /// Single-select groups first, multi-select ("extra"/"add-on") last.
  List<OptionGroup> get sortedGroups {
    final multi = <OptionGroup>[];
    final rest = <OptionGroup>[];
    for (final group in product.optionGroups) {
      (group.isMulti ? multi : rest).add(group);
    }
    return [...rest, ...multi];
  }

  CartItem buildCartItem() {
    final parts = <String>[];
    for (final group in sortedGroups) {
      if (group.isMulti) {
        for (final value in toggled[group.id] ?? const <OptionValue>[]) {
          parts.add(value.name);
        }
      } else {
        final pickedValue = picked[group.id];
        if (pickedValue != null) parts.add(pickedValue.name);
      }
    }

    final modifierIds = <String>[
      ...picked.values.map((v) => v.id),
      ...toggled.values.expand((list) => list.map((v) => v.id)),
    ];

    return CartItem(
      id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      name: product.name,
      imagePath: product.imagePath ?? '',
      variant: parts.join(' • '),
      unitPrice: total,
      quantity: 1,
      modifierIds: modifierIds,
    );
  }

  CustomizationBuilder copyWith({
    Map<String, OptionValue>? picked,
    Map<String, List<OptionValue>>? toggled,
    Map<String, String>? savedPickedIds,
    Map<String, List<String>>? savedToggledIds,
    double? total,
  }) => CustomizationBuilder(
    product: product,
    picked: picked ?? this.picked,
    toggled: toggled ?? this.toggled,
    savedPickedIds: savedPickedIds ?? this.savedPickedIds,
    savedToggledIds: savedToggledIds ?? this.savedToggledIds,
    total: total ?? this.total,
  );

  CustomizationBuilder withSavedSnapshot({
    required Map<String, String> savedPickedIds,
    required Map<String, List<String>> savedToggledIds,
  }) => CustomizationBuilder(
    product: product,
    picked: picked,
    toggled: toggled,
    savedPickedIds: savedPickedIds,
    savedToggledIds: savedToggledIds,
    total: total,
  );
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
