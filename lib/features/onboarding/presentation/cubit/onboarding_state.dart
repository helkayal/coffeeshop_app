import 'package:equatable/equatable.dart';
import '../../domain/entities/onboarding_question.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final List<OnboardingQuestion> questions;
  final int currentStep;
  final Map<String, String> answers;
  final bool isCompleted;

  const OnboardingLoaded({
    required this.questions,
    this.currentStep = 0,
    this.answers = const {},
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [questions, currentStep, answers, isCompleted];

  OnboardingLoaded copyWith({
    List<OnboardingQuestion>? questions,
    int? currentStep,
    Map<String, String>? answers,
    bool? isCompleted,
  }) {
    return OnboardingLoaded(
      questions: questions ?? this.questions,
      currentStep: currentStep ?? this.currentStep,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
