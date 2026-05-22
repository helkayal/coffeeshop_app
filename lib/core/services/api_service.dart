import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'local_storage_service.dart';

class ApiService {
  final LocalStorageService _storage;
  late final Dio _dio;

  ApiService(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Attach Bearer token from local storage on every request.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // TODO: on 401, clear session and redirect to login.
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get(path, queryParameters: queryParameters, options: options);

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response> put(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.put(path, data: data, options: options);

  Future<Response> delete(
    String path, {
    Options? options,
  }) =>
      _dio.delete(path, options: options);
}
