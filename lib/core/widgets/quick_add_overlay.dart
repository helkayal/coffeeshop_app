import 'package:flutter/material.dart';

import '../../features/customization/presentation/screens/customization_screen.dart';
import 'quick_add_options.dart';
import 'quick_add_saved_order.dart';

class QuickAddOverlay extends StatelessWidget {
  final String productName;
  final String productDescription;
  final String productImage;
  final String price;

  const QuickAddOverlay({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.price,
  });

  static void show(
    BuildContext context, {
    required String productName,
    required String productDescription,
    required String productImage,
    required String price,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(153),
      isScrollControlled: true,
      builder: (_) => QuickAddOverlay(
        productName: productName,
        productDescription: productDescription,
        productImage: productImage,
        price: price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: cs.outlineVariant.withAlpha(77))),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(
          child: Container(
            margin: const EdgeInsets.all(16), width: 48, height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant.withAlpha(128),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Saved Orders', style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
              const SizedBox(height: 16),
              QuickAddSavedOrder(name: productName, description: productDescription, imagePath: productImage),
              const SizedBox(height: 32),
              Text('Quick Add', style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
              const SizedBox(height: 16),
              const QuickAddOptions(options: ['Default', 'Double Shot', 'Oat Milk', 'Honey']),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomizationScreen()));
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary, foregroundColor: cs.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text('Customize',
                      style: tt.labelLarge?.copyWith(color: cs.onPrimary, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }
}
