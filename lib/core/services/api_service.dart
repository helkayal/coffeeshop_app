import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'local_storage_service.dart';

class ApiService {
  final LocalStorageService _storage;
  late final Dio _dio;
  bool _isRefreshing = false;

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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && !_isRefreshing) {
            // Don't try to refresh for the refresh endpoint itself.
            if (error.requestOptions.path == ApiConstants.tokenRefresh) {
              await _storage.clearAuthToken();
              await _storage.clearRefreshToken();
              await _storage.clearCachedUser();
              return handler.next(error);
            }

            final refreshToken = _storage.getRefreshToken();
            if (refreshToken != null) {
              _isRefreshing = true;
              try {
                // Call /auth/refresh — must NOT include old Authorization header.
                final refreshResponse = await _dio.post(
                  ApiConstants.tokenRefresh,
                  data: {'refresh': refreshToken},
                  options: Options(headers: {'Authorization': null}),
                );
                final body = refreshResponse.data as Map<String, dynamic>;
                final newAccess = body['access'] as String;
                await _storage.setAuthToken(newAccess);

                if (body.containsKey('refresh')) {
                  await _storage.setRefreshToken(body['refresh'] as String);
                }

                // Retry the original request with the new token.
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccess';
                _isRefreshing = false;
                final retry = await _dio.fetch(error.requestOptions);
                return handler.resolve(retry);
              } catch (_) {
                _isRefreshing = false;
                await _storage.clearAuthToken();
                await _storage.clearRefreshToken();
                await _storage.clearCachedUser();
              }
            } else {
              await _storage.clearAuthToken();
              await _storage.clearCachedUser();
            }
          }
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

  /// Executes a request and unwraps the backend's {success, data, error_code}
  /// envelope. Maps Dio network errors to [ConnectionException] and server
  /// errors to [ServerException].
  Future<dynamic> _request(Future<Response> Function() request) async {
    try {
      final response = await request();
      return _unwrap(response);
    } on ServerException {
      rethrow;
    } on ConnectionException {
      rethrow;
    } on DioException catch (e) {
      // Network-level errors — backend unreachable.
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.badResponse && e.response == null) {
        throw const ConnectionException(
          'Unable to connect to server. Please check your connection.',
        );
      }
      // Server responded with an error status.
      if (e.response != null) {
        final code = e.response!.statusCode;
        if (code != null && code >= 500) {
          throw const ServerException('Server error. Please try again later.');
        }
        return _unwrap(e.response!);
      }
      throw const ConnectionException('Network error. Please try again.');
    }
  }

  /// Extracts the data payload from the backend's {success, data, error_code}
  /// envelope. Throws [ServerException] when success=false, with the best
  /// available error message.
  dynamic _unwrap(Response response) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      final success = body['success'] as bool? ?? true;
      if (!success) {
        // Prefer a single 'message' or 'error_code' from the backend.
        final message = body['message'] as String?;
        final errorCode = body['error_code'] as String?;
        if (message != null && message.isNotEmpty) {
          throw ServerException(message);
        }
        if (errorCode != null && errorCode.isNotEmpty) {
          throw ServerException(errorCode);
        }
        // Fall back to the first field-level validation error
        // (e.g. {"email": ["Enter a valid email address."]}).
        for (final key in body.keys) {
          if (key == 'success' || key == 'error_code' || key == 'message') {
            continue;
          }
          final errors = body[key];
          if (errors is List && errors.isNotEmpty) {
            throw ServerException(errors.first.toString());
          }
        }
        throw const ServerException('An error occurred');
      }
      if (body.containsKey('data')) return body['data'];
    }
    // If the response is not structured JSON (e.g., HTML error page),
    // throw a generic server error.
    final code = response.statusCode;
    if (code != null && code >= 500) {
      throw const ServerException('Server error. Please try again later.');
    }
    return body;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _request(
        () => _dio.get(path, queryParameters: queryParameters, options: options),
      );

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _request(
        () => _dio.post(path, data: data, queryParameters: queryParameters, options: options),
      );

  Future<dynamic> put(String path, {dynamic data, Options? options}) =>
      _request(() => _dio.put(path, data: data, options: options));

  Future<dynamic> patch(String path, {dynamic data, Options? options}) =>
      _request(() => _dio.patch(path, data: data, options: options));

  Future<dynamic> delete(String path, {Options? options}) =>
      _request(() => _dio.delete(path, options: options));
}
