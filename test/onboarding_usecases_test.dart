import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/onboarding/domain/entities/onboarding_question.dart';
import 'package:coffeeshop_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:coffeeshop_app/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:coffeeshop_app/features/onboarding/domain/usecases/get_onboarding_questions.dart';
import 'package:flutter_test/flutter_test.dart';

const _questions = [
  OnboardingQuestion(
    id: '1',
    questionText: 'onboarding.q1.text',
    options: [OnboardingOption(id: '1a', text: 'onboarding.q1.o1')],
  ),
];

void main() {
  late _FakeOnboardingRepository repository;

  setUp(() {
    repository = _FakeOnboardingRepository();
  });

  group('GetOnboardingQuestionsUseCase', () {
    test('returns the questions from the repository', () async {
      repository.questionsResult = const Success(_questions);

      final result = await GetOnboardingQuestionsUseCase(repository)();

      expect(
        (result as Success<List<OnboardingQuestion>>).data,
        _questions,
      );
    });

    test('propagates a questions loading failure', () async {
      repository.questionsResult = const Error<List<OnboardingQuestion>>(
        ServerFailure('errors.unexpected_error'),
      );

      final result = await GetOnboardingQuestionsUseCase(repository)();

      expect(
        (result as Error<List<OnboardingQuestion>>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('CompleteOnboardingUseCase', () {
    test('forwards the answers when completing onboarding', () async {
      final result = await CompleteOnboardingUseCase(repository)(
        answers: {'1': '1a'},
      );

      expect(repository.lastAnswers, {'1': '1a'});
      expect(result, isA<Success<void>>());
    });

    test('propagates a completion failure', () async {
      repository.completeResult = const Error<void>(
        CacheFailure('errors.cache_error'),
      );

      final result = await CompleteOnboardingUseCase(repository)();

      expect((result as Error<void>).failure, isA<CacheFailure>());
    });
  });
}

class _FakeOnboardingRepository implements OnboardingRepository {
  Result<List<OnboardingQuestion>>? questionsResult;
  Result<void>? completeResult;
  Map<String, String>? lastAnswers;

  @override
  Future<Result<List<OnboardingQuestion>>> getQuestions() async =>
      questionsResult ?? const Success([]);

  @override
  Future<Result<void>> completeOnboarding({Map<String, String>? answers}) async {
    lastAnswers = answers;
    return completeResult ?? const Success(null);
  }
}
