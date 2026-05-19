import '../domain/entities/category.dart';
import '../domain/entities/option_group.dart';
import '../domain/entities/option_value.dart';
import '../domain/entities/product.dart';

class MockData {
  static const categories = [
    Category(
      id: '1',
      name: 'Reserve Roasts',
      imagePath: 'assets/menu_images/reserve_roasts.png',
    ),
    Category(
      id: '2',
      name: 'Cold Brew',
      imagePath: 'assets/menu_images/cold_brew.png',
    ),
    Category(
      id: '3',
      name: 'Signature Lattes',
      imagePath: 'assets/menu_images/signature_lattes.png',
    ),
    Category(
      id: '4',
      name: 'Pastries',
      imagePath: 'assets/menu_images/pastries.png',
    ),
  ];

  static const products = [
    Product(
      id: '1',
      name: 'Ethiopian Yirgacheffe',
      description:
          'Floral notes with a bright, citrusy finish. Hand-picked and sun-dried.',
      imagePath: 'assets/images/coffee_preparation.png',
      basePrice: 6.50,
      category: '1',
      optionGroups: [
        OptionGroup(
          id: 'size',
          name: 'Size',
          required: true,
          values: [
            OptionValue(id: 's', name: 'Small'),
            OptionValue(id: 'm', name: 'Medium'),
            OptionValue(id: 'l', name: 'Large', priceModifier: 1.0),
          ],
        ),
      ],
    ),
    Product(
      id: '2',
      name: 'Honey Cardamom Latte',
      description: 'Warm spices balanced with local wildflower honey.',
      imagePath: 'assets/images/latte_art_being_poured.png',
      basePrice: 7.25,
      category: '3',
    ),
    Product(
      id: '3',
      name: 'Desert Midnight',
      description:
          'Steeped for 24 hours. Smooth, bold, and entirely without bitterness.',
      imagePath: 'assets/images/artisanal_coffee_brewing.png',
      basePrice: 5.75,
      category: '2',
    ),
    Product(
      id: '4',
      name: 'Almond Croissant',
      description: 'Flaky layers filled with rich almond frangipane.',
      imagePath: 'assets/images/coffee_preparation.png',
      basePrice: 4.50,
      category: '4',
    ),
    Product(
      id: '5',
      name: 'Cardamom Rose Latte',
      description:
          'Robust espresso, steamed oat milk, and house-made cardamom-rose syrup.',
      imagePath: 'assets/images/latte_art_being_poured.png',
      basePrice: 7.25,
      category: '3',
    ),
    Product(
      id: '6',
      name: 'Butter Croissant',
      description: 'Classic French croissant with a golden, flaky crust.',
      imagePath: 'assets/images/coffee_preparation.png',
      basePrice: 3.75,
      category: '4',
    ),
  ];
}
