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
      return Error(ServerFailure(e.message ?? 'errors.profile_load_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) async {
    try {
      return Success(await _dataSource.updateProfile(profile));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.profile_update_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<double>> getLoyaltyPoints() async {
    try {
      return Success(await _dataSource.getLoyaltyPoints());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.loyalty_points_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<List<LoyaltyHistoryEntry>>> getLoyaltyHistory() async {
    try {
      return Success(await _dataSource.getLoyaltyHistory());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.loyalty_history_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<String?>> uploadAvatar(String filePath) async {
    try {
      return Success(await _dataSource.uploadAvatar(filePath));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.avatar_upload_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<void>> changeEmail(String newEmail, String password) async {
    try {
      await _dataSource.changeEmail(newEmail, password);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.email_change_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }
}
