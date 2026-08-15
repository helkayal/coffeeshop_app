import 'dart:convert';
import 'dart:typed_data';

import 'package:coffeeshop_app/core/security/credential_storage.dart';
import 'package:coffeeshop_app/core/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('concurrent unauthorized requests share one token refresh', () async {
    final credentials = _FakeCredentials(access: 'old', refresh: 'refresh');
    var requestCalls = 0;
    var refreshCalls = 0;
    final mainDio = _dioWithAdapter((options) async {
      requestCalls++;
      if (options.headers['Authorization'] == 'Bearer new') {
        return _jsonResponse(200, {
          'success': true,
          'data': {'ok': true},
        });
      }
      return _jsonResponse(401, {
        'success': false,
        'error_code': 'unauthorized',
      });
    });
    final refreshDio = _dioWithAdapter((_) async {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return _jsonResponse(200, {
        'success': true,
        'data': {'access': 'new', 'refresh': 'rotated'},
      });
    });
    final service = ApiService(
      credentials,
      dio: mainDio,
      refreshDio: refreshDio,
    );

    final responses = await Future.wait([
      service.get('/protected'),
      service.get('/protected'),
    ]);

    expect(responses, everyElement({'ok': true}));
    expect(refreshCalls, 1);
    expect(requestCalls, 4);
    expect(credentials.access, 'new');
    expect(credentials.refresh, 'rotated');
  });

  test('an unauthorized retry is attempted only once', () async {
    final credentials = _FakeCredentials(access: 'old', refresh: 'refresh');
    var requestCalls = 0;
    final mainDio = _dioWithAdapter((_) async {
      requestCalls++;
      return _jsonResponse(401, {
        'success': false,
        'error_code': 'unauthorized',
      });
    });
    final refreshDio = _dioWithAdapter(
      (_) async => _jsonResponse(200, {
        'success': true,
        'data': {'access': 'new'},
      }),
    );
    final service = ApiService(
      credentials,
      dio: mainDio,
      refreshDio: refreshDio,
    );

    await expectLater(service.get('/protected'), throwsA(anything));

    expect(requestCalls, 2);
  });
}

Dio _dioWithAdapter(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.httpClientAdapter = _FakeAdapter(handler);
  return dio;
}

ResponseBody _jsonResponse(int status, Map<String, dynamic> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

class _FakeAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _FakeAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);

  @override
  void close({bool force = false}) {}
}

class _FakeCredentials implements CredentialStorage {
  String? access;
  String? refresh;

  _FakeCredentials({this.access, this.refresh});

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> writeAccessToken(String token) async => access = token;

  @override
  Future<void> writeRefreshToken(String token) async => refresh = token;
}
