import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../data/datasources/referral_data_source.dart';
import '../../domain/entities/referral_history_entry.dart';
import '../../domain/repositories/referral_repository.dart';

class ReferralRepositoryImpl implements ReferralRepository {
  final ReferralDataSource _dataSource;

  ReferralRepositoryImpl(this._dataSource);

  @override
  Future<Result<({String code, List<ReferralHistoryEntry> history})>>
  getReferral() async {
    try {
      return Success(await _dataSource.getReferral());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.referral_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<void>> applyReferral(String code) async {
    try {
      await _dataSource.applyReferral(code);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.referral_apply_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }
}
