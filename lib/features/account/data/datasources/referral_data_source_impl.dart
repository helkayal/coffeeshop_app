import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/referral_history_model.dart';
import 'referral_data_source.dart';

class ReferralDataSourceImpl implements ReferralDataSource {
  final ApiService _api;

  ReferralDataSourceImpl(this._api);

  @override
  Future<({String code, List<ReferralHistoryModel> history})>
  getReferral() async {
    final data = await _api.get(ApiConstants.referral);
    final history = await _api.get(ApiConstants.referralHistory);
    return (
      code: (data as Map<String, dynamic>)['code'] as String? ?? '',
      history: (history as List<dynamic>)
          .map(
            (item) => ReferralHistoryModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> applyReferral(String code) async {
    await _api.post(ApiConstants.referralApply, data: {'code': code});
  }
}
