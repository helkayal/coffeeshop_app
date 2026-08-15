import 'dart:io';
import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../entities/connection_status.dart';

abstract class NetworkInfoService {
  Future<bool> hasInternetConnection();
  Future<bool> isServerReachable();
  Future<ConnectionStatus> checkConnectivity();
}

class NetworkInfoServiceImpl implements NetworkInfoService {
  final Dio _dio;

  NetworkInfoServiceImpl({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          );

  @override
  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      try {
        final fallback = await InternetAddress.lookup(
          'google.com',
        ).timeout(const Duration(seconds: 4));
        return fallback.isNotEmpty && fallback[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
  }

  @override
  Future<bool> isServerReachable() async {
    try {
      final baseUrl = ApiConstants.apiBaseUrl.replaceAll('/api/v1', '');
      final healthUrl = '$baseUrl/healthz';
      final response = await _dio.get(healthUrl);
      return response.statusCode == 200;
    } catch (_) {
      try {
        final settingsUrl =
            '${ApiConstants.apiBaseUrl}${ApiConstants.settings}';
        final response = await _dio.get(settingsUrl);
        return response.statusCode != null && response.statusCode! < 500;
      } catch (_) {
        return false;
      }
    }
  }

  @override
  Future<ConnectionStatus> checkConnectivity() async {
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      return ConnectionStatus.noInternet;
    }
    final serverOk = await isServerReachable();
    if (!serverOk) {
      return ConnectionStatus.serverUnreachable;
    }
    return ConnectionStatus.connected;
  }
}
