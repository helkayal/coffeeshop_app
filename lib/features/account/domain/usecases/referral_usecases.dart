import '../../../../core/helpers/result.dart';
import '../repositories/referral_repository.dart';

class GetReferralUseCase {
  final ReferralRepository _repository;
  const GetReferralUseCase(this._repository);
  Future<Result<({String code, List<Map<String, dynamic>> history})>> call() =>
      _repository.getReferral();
}

class ApplyReferralUseCase {
  final ReferralRepository _repository;
  const ApplyReferralUseCase(this._repository);
  Future<Result<void>> call(String code) => _repository.applyReferral(code);
}
