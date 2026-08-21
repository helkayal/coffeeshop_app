import 'package:coffeeshop_app/features/checkout/domain/usecases/build_quick_add_item.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/option_group.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/option_value.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/product.dart';
import 'package:coffeeshop_app/features/orders/domain/entities/order_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BuildQuickAddItemUseCase.unitPriceFor', () {
    test('returns the base price when no extras are selected', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      expect(useCase.unitPriceFor(_product()), 50);
    });

    test('adds upcharges for the selected extras only', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      expect(
        useCase.unitPriceFor(_product(), selectedExtraIds: {'shot', 'caramel'}),
        55,
      );
    });

    test('ignores selections outside multi-select groups', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      expect(useCase.unitPriceFor(_product(), selectedExtraIds: {'oat'}), 50);
    });
  });

  group('BuildQuickAddItemUseCase.call', () {
    test('assembles variant and ids from the last order selections', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 7);

      final item = useCase(
        _product(),
        lastOrderItems: [
          OrderItem(
            name: 'Coffee',
            quantity: 1,
            price: 60,
            menuItemId: 'coffee',
            selections: const [
              {'modifier_name': 'Oat', 'modifier_id': 'oat'},
            ],
          ),
        ],
      );

      expect(item.id, 'coffee_7');
      expect(item.variant, 'Oat');
      expect(item.modifierIds, ['oat']);
      // Reorder price is not inherited: base + extras only.
      expect(item.unitPrice, 50);
    });

    test('skips selections without a name or id', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      final item = useCase(
        _product(),
        lastOrderItems: [
          OrderItem(
            name: 'Coffee',
            quantity: 1,
            price: 60,
            selections: const [
              {'modifier_name': '', 'modifier_id': 'hidden'},
              {'modifier_name': 'Iced'},
            ],
          ),
        ],
      );

      expect(item.variant, 'Iced');
      expect(item.modifierIds, ['hidden']);
      expect(item.unitPrice, 50);
    });

    test('prices reorder items as base plus newly selected extras', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      final item = useCase(
        _product(),
        lastOrderItems: [
          OrderItem(
            name: 'Coffee',
            quantity: 1,
            price: 60,
            selections: const [
              {'modifier_name': 'Oat', 'modifier_id': 'oat'},
            ],
          ),
        ],
        selectedExtraIds: {'shot'},
      );

      expect(item.variant, 'Oat • Shot');
      expect(item.modifierIds, ['oat', 'shot']);
      expect(item.unitPrice, 52);
    });

    test('defaults to the first option of each single-select group', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      final item = useCase(_product());

      expect(item.variant, 'Whole • Hot');
      expect(item.modifierIds, ['whole', 'hot']);
      // Default upcharge from the first single-select options is included.
      expect(item.unitPrice, 51);
      expect(item.quantity, 1);
    });

    test('includes selected extras in the variant and price', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      final item = useCase(_product(), selectedExtraIds: {'caramel'});

      expect(item.variant, 'Whole • Hot • Caramel');
      expect(item.modifierIds, ['whole', 'hot', 'caramel']);
      expect(item.unitPrice, 54);
    });

    test('falls back to the product name as variant without options', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 1);

      final item = useCase(_bareProduct);

      expect(item.variant, 'Black Coffee');
      expect(item.unitPrice, 50);
      expect(item.modifierIds, isEmpty);
    });
  });

  group('BuildQuickAddItemUseCase.fromOrderItem', () {
    test('preserves the ordered price and quantity', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 3);

      final item = useCase.fromOrderItem(
        _product(),
        OrderItem(
          name: 'Coffee',
          quantity: 2,
          price: 57,
          menuItemId: 'coffee',
          selections: const [
            {'modifier_name': 'Oat', 'modifier_id': 'oat'},
          ],
        ),
      );

      expect(item.unitPrice, 57);
      expect(item.quantity, 2);
      expect(item.variant, 'Oat');
      expect(item.modifierIds, ['oat']);
      expect(item.imagePath, '/img/coffee.png');
    });

    test('uses the provided product name and falls back to it as variant', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 3);

      final item = useCase.fromOrderItem(
        _product(),
        const OrderItem(name: 'Coffee', quantity: 1, price: 50),
        productName: 'Oat Latte',
      );

      expect(item.name, 'Oat Latte');
      expect(item.variant, 'Oat Latte');
      expect(item.unitPrice, 50);
    });
  });

  group('BuildQuickAddItemUseCase.fromOrderItemRaw', () {
    test('rebuilds the item without product context', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 5);

      final item = useCase.fromOrderItemRaw(
        OrderItem(
          name: 'Latte',
          quantity: 3,
          price: 40,
          menuItemId: 'latte',
          selections: const [
            {'modifier_name': 'Oat', 'modifier_id': 'oat'},
          ],
        ),
        orderId: 'order-9',
      );

      expect(item.id, 'order-9_latte_5');
      expect(item.productId, 'latte');
      expect(item.name, 'Latte');
      expect(item.imagePath, '');
      expect(item.variant, 'Oat');
      expect(item.unitPrice, 40);
      expect(item.quantity, 3);
      expect(item.modifierIds, ['oat']);
    });

    test('falls back to the item name when it has no selections', () {
      final useCase = BuildQuickAddItemUseCase(idSeed: () => 5);

      final item = useCase.fromOrderItemRaw(
        const OrderItem(name: 'Latte', quantity: 1, price: 40),
        orderId: 'order-9',
      );

      expect(item.id, 'order-9__5');
      expect(item.productId, '');
      expect(item.variant, 'Latte');
    });
  });
}

Product _product() => const Product(
  id: 'coffee',
  name: 'Coffee',
  description: '',
  imagePath: '/img/coffee.png',
  basePrice: 50,
  category: 'coffee',
  optionGroups: [
    OptionGroup(
      id: 'milk',
      name: 'Milk',
      values: [
        OptionValue(id: 'whole', name: 'Whole', priceModifier: 0),
        OptionValue(id: 'oat', name: 'Oat', priceModifier: 5),
      ],
    ),
    OptionGroup(
      id: 'temperature',
      name: 'Temperature',
      values: [
        OptionValue(id: 'hot', name: 'Hot', priceModifier: 1),
        OptionValue(id: 'iced', name: 'Iced', priceModifier: 0),
      ],
    ),
    OptionGroup(
      id: 'extras',
      name: 'Extras',
      values: [
        OptionValue(id: 'shot', name: 'Shot', priceModifier: 2),
        OptionValue(id: 'caramel', name: 'Caramel', priceModifier: 3),
      ],
    ),
  ],
);

const Product _bareProduct = Product(
  id: 'black',
  name: 'Black Coffee',
  description: '',
  basePrice: 50,
  category: 'coffee',
);
