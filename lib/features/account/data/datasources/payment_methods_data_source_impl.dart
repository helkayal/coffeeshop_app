import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import 'payment_methods_data_source.dart';

class PaymentMethodsDataSourceImpl implements PaymentMethodsDataSource {
  final ApiService _api;
  final LocalStorageService _storage;

  PaymentMethodsDataSourceImpl(this._api, this._storage);

  @override
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final data = await _api.get(ApiConstants.paymentMethods);
    return List<Map<String, dynamic>>.from(data as List);
  }

  @override
  Future<void> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  }) async {
    final parts = expiry.split('/');
    final expiryMonth = parts.isNotEmpty ? parts[0].trim() : '';
    final expiryYear = parts.length > 1 ? parts[1].trim() : '';
    final last4 = number.replaceAll(' ', '').length >= 4
        ? number.replaceAll(' ', '').substring(number.replaceAll(' ', '').length - 4)
        : number;
    await _api.post(
      ApiConstants.paymentMethods,
      data: {
        'card_last4': last4,
        'expiry_month': expiryMonth,
        'expiry_year': expiryYear,
        'card_brand': 'visa',
        'cardholder_name': name,
      },
    );
    // Cache to local storage after successful add.
    final fresh = await _api.get(ApiConstants.paymentMethods);
    final cards = List<Map<String, dynamic>>.from(fresh as List);
    await _storage.setSavedCards(cards);
  }

  @override
  Future<void> deleteCard(String cardId) async {
    await _api.delete('${ApiConstants.paymentMethods}/$cardId');
    // Update local cache.
    final fresh = await _api.get(ApiConstants.paymentMethods);
    final cards = List<Map<String, dynamic>>.from(fresh as List);
    await _storage.setSavedCards(cards);
  }
}
