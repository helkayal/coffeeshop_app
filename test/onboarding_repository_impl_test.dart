import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/core/security/credential_storage.dart';
import 'package:coffeeshop_app/core/services/api_service.dart';
import 'package:coffeeshop_app/core/services/local_storage_service.dart';
import 'package:coffeeshop_app/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:coffeeshop_app/features/onboarding/data/models/onboarding_question_model.dart';
import 'package:coffeeshop_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:coffeeshop_app/features/onboarding/domain/entities/onboarding_question.dart';
import 'package:flutter_test/flutter_test.dart';

const _questions = [
  OnboardingQuestionModel(
    id: '1',
    questionText: 'onboarding.q1.text',
    options: [OnboardingOptionModel(id: '1a', text: 'onboarding.q1.o1')],
  ),
];

void main() {
  late _FakeOnboardingRemoteDataSource remote;
  late _FakeLocalStorage local;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    remote = _FakeOnboardingRemoteDataSource();
    local = _FakeLocalStorage();
    repository = OnboardingRepositoryImpl(remote, local);
  });

  group('getQuestions', () {
    test('returns the questions from the remote data source', () async {
      remote.questions = _questions;

      final result = await repository.getQuestions();

      expect(
        (result as Success<List<OnboardingQuestion>>).data,
        _questions,
      );
    });

    test('maps a server exception to a ServerFailure with its message',
        () async {
      remote.getQuestionsError = const ServerException('errors.server_unavailable');

      final result = await repository.getQuestions();

      expect(
        (result as Error<List<OnboardingQuestion>>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.server_unavailable',
        ),
      );
    });

    test('falls back to server_unavailable when the server sends no message',
        () async {
      remote.getQuestionsError = const ServerException();

      final result = await repository.getQuestions();

      expect(
        (result as Error<List<OnboardingQuestion>>).failure.message,
        'errors.server_unavailable',
      );
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.getQuestionsError = StateError('boom');

      final result = await repository.getQuestions();

      expect(
        (result as Error<List<OnboardingQuestion>>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('completeOnboarding', () {
    test('saves answers and marks first run as completed', () async {
      final result = await repository.completeOnboarding(answers: {'1': '1a'});

      expect(remote.saveCalls, 1);
      expect(remote.lastAnswers, {'1': '1a'});
      expect(local.firstRunCompleted, isTrue);
      expect(result, isA<Success<void>>());
    });

    test('skips the remote save when no answers are provided', () async {
      final result = await repository.completeOnboarding();

      expect(remote.saveCalls, 0);
      expect(local.firstRunCompleted, isTrue);
      expect(result, isA<Success<void>>());
    });

    test('maps a server exception during save to a ServerFailure', () async {
      remote.saveError = const ServerException();

      final result = await repository.completeOnboarding(answers: {'1': '1a'});

      expect(
        (result as Error<void>).failure.message,
        'errors.server_unavailable',
      );
    });

    test('maps a cache exception to a CacheFailure', () async {
      local.firstRunCompletedError = const CacheException();

      final result = await repository.completeOnboarding(answers: {'1': '1a'});

      expect(
        (result as Error<void>).failure,
        isA<CacheFailure>().having(
          (f) => f.message,
          'message',
          'errors.cache_error',
        ),
      );
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.saveError = StateError('boom');

      final result = await repository.completeOnboarding(answers: {'1': '1a'});

      expect(
        (result as Error<void>).failure.message,
        'errors.unexpected_error',
      );
    });
  });
}

class _FakeOnboardingRemoteDataSource extends OnboardingRemoteDataSource {
  _FakeOnboardingRemoteDataSource() : super(ApiService(_FakeCredentials()));

  List<OnboardingQuestionModel> questions = const [];
  Object? getQuestionsError;
  Object? saveError;
  int saveCalls = 0;
  Map<String, String>? lastAnswers;

  @override
  Future<List<OnboardingQuestionModel>> getQuestions() async {
    if (getQuestionsError != null) throw getQuestionsError!;
    return questions;
  }

  @override
  Future<void> saveOnboarding(Map<String, String> answers) async {
    if (saveError != null) throw saveError!;
    saveCalls++;
    lastAnswers = answers;
  }
}

class _FakeLocalStorage extends LocalStorageService {
  bool firstRunCompleted = false;
  Object? firstRunCompletedError;

  @override
  Future<void> setFirstRunCompleted() async {
    if (firstRunCompletedError != null) throw firstRunCompletedError!;
    firstRunCompleted = true;
  }
}

class _FakeCredentials implements CredentialStorage {
  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> writeAccessToken(String token) async {}

  @override
  Future<void> writeRefreshToken(String token) async {}

  @override
  Future<void> clear() async {}
}
