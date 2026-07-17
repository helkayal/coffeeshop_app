import 'dart:math';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';

abstract class CheckoutRemoteDataSource {
  Future<String> placeOrder({
    required List<Map<String, dynamic>> items,
    String? specialInstructions,
  });
  Future<void> checkoutOrder(String orderId, {String? paymentMethod, String? cardNumber});
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ApiService _api;

  CheckoutRemoteDataSourceImpl(this._api);

  @override
  Future<String> placeOrder({
    required List<Map<String, dynamic>> items,
    String? specialInstructions,
  }) async {
    final data = await _api.post(
      ApiConstants.orders,
      data: {
        'items': items,
        if (specialInstructions != null && specialInstructions.isNotEmpty)
          'special_instructions': specialInstructions,
      },
      options: Options(
        headers: {
          'X-Idempotency-Key': _uuidV4(),
        },
      ),
    );
    return (data as Map<String, dynamic>)['id'] as String;
  }

  @override
  Future<void> checkoutOrder(String orderId, {String? paymentMethod, String? cardNumber}) async {
    final body = <String, dynamic>{
      'payment_method': paymentMethod ?? 'wallet',
    };
    if (cardNumber != null) body['card_number'] = cardNumber;

    await _api.post(
      '${ApiConstants.orders}/$orderId/checkout',
      data: body,
      options: Options(
        headers: {'X-Idempotency-Key': _uuidV4()},
      ),
    );
  }
}

String _uuidV4() {
  final rnd = Random();
  final hex = List.generate(32, (_) => rnd.nextInt(16).toRadixString(16));
  hex[12] = '4'; // version 4
  hex[16] = (8 + rnd.nextInt(4)).toRadixString(16); // variant
  return '${hex[0]}${hex[1]}${hex[2]}${hex[3]}${hex[4]}${hex[5]}${hex[6]}${hex[7]}-'
      '${hex[8]}${hex[9]}${hex[10]}${hex[11]}-'
      '${hex[12]}${hex[13]}${hex[14]}${hex[15]}-'
      '${hex[16]}${hex[17]}${hex[18]}${hex[19]}-'
      '${hex[20]}${hex[21]}${hex[22]}${hex[23]}${hex[24]}${hex[25]}${hex[26]}${hex[27]}${hex[28]}${hex[29]}${hex[30]}${hex[31]}';
}
