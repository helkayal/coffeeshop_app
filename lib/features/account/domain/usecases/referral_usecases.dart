import '../../../../core/helpers/result.dart';
import '../entities/referral_history_entry.dart';
import '../repositories/referral_repository.dart';

class GetReferralUseCase {
  final ReferralRepository _repository;
  const GetReferralUseCase(this._repository);
  Future<Result<({String code, List<ReferralHistoryEntry> history})>> call() =>
      _repository.getReferral();
}

class ApplyReferralUseCase {
  final ReferralRepository _repository;
  const ApplyReferralUseCase(this._repository);
  Future<Result<void>> call(String code) => _repository.applyReferral(code);
}
