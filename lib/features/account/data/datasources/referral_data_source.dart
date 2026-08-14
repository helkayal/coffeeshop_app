abstract class ReferralDataSource {
  Future<({String code, List<Map<String, dynamic>> history})> getReferral();
  Future<void> applyReferral(String code);
}
