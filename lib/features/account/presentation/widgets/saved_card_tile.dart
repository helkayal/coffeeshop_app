import 'package:flutter/material.dart';

import '../../../../features/checkout/presentation/widgets/payment_option.dart';

class SavedCardTile extends StatelessWidget {
  final String mask;
  final String expiry;
  final bool isDefault;
  final VoidCallback onTap;

  const SavedCardTile({
    super.key,
    required this.mask,
    required this.expiry,
    required this.isDefault,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PaymentOption(
      icon: Icons.credit_card,
      label: '$mask ($expiry)',
      isSelected: isDefault,
      showDefaultBadge: isDefault,
      onTap: onTap,
    );
  }
}
