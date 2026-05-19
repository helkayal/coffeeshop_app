import '../../../../core/helpers/result.dart';
import '../entities/onboarding_question.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingQuestionsUseCase {
  final OnboardingRepository repository;

  GetOnboardingQuestionsUseCase(this.repository);

  Future<Result<List<OnboardingQuestion>>> call() {
    return repository.getQuestions();
  }
}
