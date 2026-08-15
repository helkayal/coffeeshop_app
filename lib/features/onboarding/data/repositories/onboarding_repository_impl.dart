import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/onboarding_question.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;
  final LocalStorageService localDataSource;

  OnboardingRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<List<OnboardingQuestion>>> getQuestions() async {
    try {
      final questions = await remoteDataSource.getQuestions();
      return Success(questions);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }

  @override
  Future<Result<void>> completeOnboarding({
    Map<String, String>? answers,
  }) async {
    try {
      if (answers != null && answers.isNotEmpty) {
        await remoteDataSource.saveOnboarding(answers);
      }
      await localDataSource.setFirstRunCompleted();
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Server Error'));
    } on CacheException catch (e) {
      return Error(CacheFailure(e.message ?? 'Cache Error'));
    } catch (e) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }
}
