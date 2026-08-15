import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/loyalty_history_entry.dart';
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
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) async {
    try {
      return Success(await _dataSource.updateProfile(profile));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to update profile'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<double>> getLoyaltyPoints() async {
    try {
      return Success(await _dataSource.getLoyaltyPoints());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load loyalty points'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<List<LoyaltyHistoryEntry>>> getLoyaltyHistory() async {
    try {
      return Success(await _dataSource.getLoyaltyHistory());
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to load loyalty history'));
    }
  }

  @override
  Future<Result<String?>> uploadAvatar(String filePath) async {
    try {
      return Success(await _dataSource.uploadAvatar(filePath));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to upload avatar'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<void>> changeEmail(String newEmail, String password) async {
    try {
      await _dataSource.changeEmail(newEmail, password);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to change email'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
