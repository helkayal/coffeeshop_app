import '../../../../core/helpers/result.dart';

abstract class ReferralRepository {
  Future<Result<({String code, List<Map<String, dynamic>> history})>> getReferral();
  Future<Result<void>> applyReferral(String code);
}
