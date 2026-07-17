import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_onboarding_questions.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final GetOnboardingQuestionsUseCase _getOnboardingQuestions;
  final CompleteOnboardingUseCase _completeOnboarding;

  OnboardingCubit(this._getOnboardingQuestions, this._completeOnboarding)
    : super(OnboardingInitial());

  Future<void> fetchQuestions() async {
    emit(OnboardingLoading());
    final result = await _getOnboardingQuestions();

    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (questions) => emit(OnboardingLoaded(questions: questions)),
    );
  }

  // O-2: Future<void> instead of void async — makes the async contract explicit.
  Future<void> selectAndNavigate(String questionId, String optionId) async {
    if (state is! OnboardingLoaded) return;

    final currentState = state as OnboardingLoaded;
    final newAnswers = Map<String, String>.from(currentState.answers)
      ..[questionId] = optionId;

    final isLastStep =
        currentState.currentStep == currentState.questions.length - 1;

    if (isLastStep) {
      // O-1: propagate failure instead of silently marking isCompleted = true.
      final result = await _completeOnboarding(answers: newAnswers);
      result.fold(
        (failure) => emit(OnboardingError(failure.message)),
        (_) =>
            emit(currentState.copyWith(answers: newAnswers, isCompleted: true)),
      );
    } else {
      emit(
        currentState.copyWith(
          answers: newAnswers,
          currentStep: currentState.currentStep + 1,
        ),
      );
    }
  }

  void goBack() {
    if (state is! OnboardingLoaded) return;
    final currentState = state as OnboardingLoaded;
    if (currentState.currentStep > 0) {
      emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
    }
  }

  // O-2: Future<void> — compatible with VoidCallback in Dart (void accepts any value).
  Future<void> skip() async {
    if (state is! OnboardingLoaded) return;
    final currentState = state as OnboardingLoaded;

    // O-1: propagate failure instead of silently completing.
    final result = await _completeOnboarding(answers: currentState.answers);
    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (_) => emit(currentState.copyWith(isCompleted: true)),
    );
  }
}
