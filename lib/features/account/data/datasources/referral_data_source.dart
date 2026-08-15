import '../models/referral_history_model.dart';

abstract class ReferralDataSource {
  Future<({String code, List<ReferralHistoryModel> history})> getReferral();
  Future<void> applyReferral(String code);
}
