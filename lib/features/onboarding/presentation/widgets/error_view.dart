import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'onboarding.error'.tr(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
