import '../../../../core/helpers/result.dart';
import '../entities/onboarding_question.dart';

abstract class OnboardingRepository {
  Future<Result<List<OnboardingQuestion>>> getQuestions();
  Future<Result<void>> completeOnboarding();
}
