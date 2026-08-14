import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../data/models/wallet_package_model.dart';
import 'wallet_data_source.dart';

class WalletDataSourceImpl implements WalletDataSource {
  final ApiService _api;
  final LocalStorageService _storage;

  WalletDataSourceImpl(this._api, this._storage);

  @override
  Future<double> getBalance() async {
    final data = await _api.get(ApiConstants.wallet);
    final bal = (data as Map<String, dynamic>)['coffee_cash'] ?? data['balance'];
    return bal is double ? bal : double.tryParse(bal?.toString() ?? '0') ?? 0;
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final data = await _api.get(ApiConstants.walletTransactions);
    return List<Map<String, dynamic>>.from(data as List);
  }

  @override
  Future<void> updateWalletPhone(String phone) async {
    _storage.setWalletPhone(phone);
    await _api.patch(ApiConstants.wallet, data: {'mobile_wallet_phone': phone});
  }

  @override
  Future<List<WalletPackage>> getPackages() async {
    final data = await _api.get(ApiConstants.walletPackages);
    if (data is List) {
      return data
          .map((e) => WalletPackage.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => WalletPackage.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<double?> buyPackage(String packageId) async {
    final res = await _api.post(
      ApiConstants.walletPackagesBuy,
      data: {'package_id': packageId},
    );
    if (res is Map<String, dynamic>) {
      final dataMap = (res['data'] as Map<String, dynamic>?) ?? res;
      final rawBal = dataMap['coffee_cash'] ?? dataMap['balance'];
      if (rawBal != null) {
        return rawBal is num ? rawBal.toDouble() : double.tryParse(rawBal.toString());
      }
    }
    return null;
  }
}
