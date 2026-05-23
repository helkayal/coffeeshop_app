import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Result<UserProfile>> getProfile() async {
    try {
      return Success(await _dataSource.getProfile());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load profile'));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) async {
    try {
      return Success(await _dataSource.updateProfile(profile));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to update profile'));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<double>> getLoyaltyPoints() async {
    try {
      return Success(await _dataSource.getLoyaltyPoints());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load loyalty points'));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error'));
    }
  }
}
