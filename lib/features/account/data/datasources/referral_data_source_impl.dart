import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import 'referral_data_source.dart';

class ReferralDataSourceImpl implements ReferralDataSource {
  final ApiService _api;

  ReferralDataSourceImpl(this._api);

  @override
  Future<({String code, List<Map<String, dynamic>> history})> getReferral() async {
    final data = await _api.get(ApiConstants.referral);
    final history = await _api.get(ApiConstants.referralHistory);
    return (
      code: (data as Map<String, dynamic>)['code'] as String? ?? '',
      history: List<Map<String, dynamic>>.from(history as List),
    );
  }

  @override
  Future<void> applyReferral(String code) async {
    await _api.post(ApiConstants.referralApply, data: {'code': code});
  }
}
