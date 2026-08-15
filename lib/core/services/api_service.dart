import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../security/credential_storage.dart';

class ApiService {
  static const _retryKey = 'authentication_retry';

  final CredentialStorage _credentials;
  late final Dio _dio;
  late final Dio _refreshDio;
  Completer<String?>? _refreshCompleter;

  ApiService(this._credentials, {Dio? dio, Dio? refreshDio}) {
    final options = BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    _dio = dio ?? Dio(options);
    _refreshDio = refreshDio ?? Dio(options);
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _authorize, onError: _recoverUnauthorized),
    );
  }

  Future<void> _authorize(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _credentials.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _recoverUnauthorized(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    final shouldRefresh =
        error.response?.statusCode == 401 &&
        request.path != ApiConstants.tokenRefresh &&
        request.extra[_retryKey] != true;
    if (!shouldRefresh) return handler.next(error);

    final accessToken = await _refreshAccessToken();
    if (accessToken == null) return handler.next(error);

    request.extra[_retryKey] = true;
    request.headers['Authorization'] = 'Bearer $accessToken';
    try {
      handler.resolve(await _dio.fetch(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refreshAccessToken() async {
    final activeRefresh = _refreshCompleter;
    if (activeRefresh != null) return activeRefresh.future;

    final completer = Completer<String?>();
    _refreshCompleter = completer;
    try {
      final refreshToken = await _credentials.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _credentials.clear();
        completer.complete(null);
        return null;
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        ApiConstants.tokenRefresh,
        data: {'refresh': refreshToken},
      );
      final body = response.data;
      final data = body?['data'] is Map<String, dynamic>
          ? body!['data'] as Map<String, dynamic>
          : body;
      final accessToken = data?['access'];
      if (accessToken is! String || accessToken.isEmpty) {
        throw const FormatException('Missing refreshed access token');
      }
      await _credentials.writeAccessToken(accessToken);
      if (data?['refresh'] case final String rotatedRefresh) {
        await _credentials.writeRefreshToken(rotatedRefresh);
      }
      completer.complete(accessToken);
      return accessToken;
    } catch (_) {
      await _credentials.clear();
      completer.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<dynamic> _request(Future<Response<dynamic>> Function() request) async {
    try {
      return _unwrap(await request());
    } on ServerException {
      rethrow;
    } on ConnectionException {
      rethrow;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.badResponse &&
              error.response == null) {
        throw const ConnectionException('connection_unavailable');
      }
      if (error.response case final response?) {
        if ((response.statusCode ?? 0) >= 500) {
          throw const ServerException('server_unavailable');
        }
        return _unwrap(response);
      }
      throw const ConnectionException('network_error');
    }
  }

  dynamic _unwrap(Response<dynamic> response) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      if (body['success'] == false) {
        final code = body['error_code'];
        throw ServerException(
          code is String && code.isNotEmpty ? code : 'request_failed',
        );
      }
      if (body.containsKey('data')) return body['data'];
    }
    if ((response.statusCode ?? 0) >= 500) {
      throw const ServerException('server_unavailable');
    }
    return body;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.get(path, queryParameters: queryParameters, options: options),
  );

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<dynamic> put(String path, {dynamic data, Options? options}) =>
      _request(() => _dio.put(path, data: data, options: options));

  Future<dynamic> patch(String path, {dynamic data, Options? options}) =>
      _request(() => _dio.patch(path, data: data, options: options));

  Future<dynamic> delete(String path, {Options? options}) =>
      _request(() => _dio.delete(path, options: options));
}
