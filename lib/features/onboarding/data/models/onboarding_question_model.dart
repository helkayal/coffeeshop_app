import '../../domain/entities/onboarding_question.dart';

class OnboardingOptionModel extends OnboardingOption {
  const OnboardingOptionModel({
    required super.id,
    required super.text,
  });

  factory OnboardingOptionModel.fromJson(Map<String, dynamic> json) {
    return OnboardingOptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class OnboardingQuestionModel extends OnboardingQuestion {
  const OnboardingQuestionModel({
    required super.id,
    required super.questionText,
    super.imageUrl,
    required List<OnboardingOptionModel> super.options,
  });

  factory OnboardingQuestionModel.fromJson(Map<String, dynamic> json) {
    return OnboardingQuestionModel(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      imageUrl: json['imageUrl'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((e) => OnboardingOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'imageUrl': imageUrl,
      'options': (options as List<OnboardingOptionModel>)
          .map((e) => e.toJson())
          .toList(),
    };
  }
}
