import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../data/datasources/referral_data_source.dart';
import '../../domain/repositories/referral_repository.dart';

class ReferralRepositoryImpl implements ReferralRepository {
  final ReferralDataSource _dataSource;

  ReferralRepositoryImpl(this._dataSource);

  @override
  Future<Result<({String code, List<Map<String, dynamic>> history})>>
      getReferral() async {
    try {
      return Success(await _dataSource.getReferral());
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to load referral data'));
    }
  }

  @override
  Future<Result<void>> applyReferral(String code) async {
    try {
      await _dataSource.applyReferral(code);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to apply referral code'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
