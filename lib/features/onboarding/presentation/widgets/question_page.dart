import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_insets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/onboarding_question.dart';
import 'option_tile.dart';

class QuestionPage extends StatelessWidget {
  final OnboardingQuestion question;
  final String? selectedOptionId;
  final Function(String) onOptionSelected;

  const QuestionPage({
    super.key,
    required this.question,
    this.selectedOptionId,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: AppInsets.a24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.imageUrl case final imageUrl?) ...[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    imageUrl,
                    width: MediaQuery.of(context).size.width * 0.6,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.image, size: 48),
                    height: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            AppSpacing.v32,
          ],
          Text(
            question.questionText.tr(),
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          AppSpacing.v32,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: question.options.length,
            separatorBuilder: (_, _) => AppSpacing.v16,
            itemBuilder: (context, index) {
              final option = question.options[index];
              return OptionTile(
                text: option.text,
                isSelected: option.id == selectedOptionId,
                onTap: () => onOptionSelected(option.id),
              );
            },
          ),
        ],
      ),
    );
  }
}
