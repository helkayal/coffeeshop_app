import '../../../../core/helpers/result.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  Future<Result<void>> call() {
    return repository.completeOnboarding();
  }
}
