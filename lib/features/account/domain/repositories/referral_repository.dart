import '../../../../core/helpers/result.dart';
import '../entities/referral_history_entry.dart';

abstract class ReferralRepository {
  Future<Result<({String code, List<ReferralHistoryEntry> history})>>
  getReferral();
  Future<Result<void>> applyReferral(String code);
}
