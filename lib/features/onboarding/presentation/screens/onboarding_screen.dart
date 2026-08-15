import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_design_constants.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/progress_dots.dart';
import '../widgets/question_page.dart';
import '../widgets/skip_row.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingCubit>()..fetchQuestions(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingLoaded && state.isCompleted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                if (state is OnboardingLoading) return const LoadingView();
                if (state is OnboardingError) return ErrorView(state.message);
                if (state is OnboardingLoaded) {
                  return _buildContent(context, state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OnboardingLoaded state) {
    final question = state.questions[state.currentStep];
    final isFirstStep = state.currentStep == 0;
    final cubit = context.read<OnboardingCubit>();

    return Column(
      children: [
        const SizedBox(height: AppDesignConstants.paddingMedium),
        SkipRow(onSkip: cubit.skip),
        Expanded(
          child: QuestionPage(
            question: question,
            selectedOptionId: state.answers[question.id],
            onOptionSelected: (optionId) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (!context.mounted) return;
                cubit.selectAndNavigate(question.id, optionId);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignConstants.paddingLarge,
            vertical: AppDesignConstants.paddingMedium,
          ),
          child: Row(
            children: [
              if (!isFirstStep)
                TextButton.icon(
                  onPressed: cubit.goBack,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text('onboarding.back'.tr()),
                )
              else
                const SizedBox(width: 80),
              const Spacer(),
              ProgressDots(
                totalSteps: state.questions.length,
                currentStep: state.currentStep,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
