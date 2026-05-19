import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 32),
          const Spacer(),
          Text(
            'Coffee Shop',
            style: tt.headlineMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: cs.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Icon(Icons.shopping_cart_outlined, color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
