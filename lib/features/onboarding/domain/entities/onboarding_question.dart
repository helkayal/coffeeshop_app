import 'package:equatable/equatable.dart';

class OnboardingOption extends Equatable {
  final String id;
  final String text;

  const OnboardingOption({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}

class OnboardingQuestion extends Equatable {
  final String id;
  final String questionText;
  final String? imageUrl;
  final List<OnboardingOption> options;

  const OnboardingQuestion({
    required this.id,
    required this.questionText,
    this.imageUrl,
    required this.options,
  });

  @override
  List<Object?> get props => [id, questionText, imageUrl, options];
}
