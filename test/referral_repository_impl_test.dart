import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/data/datasources/referral_data_source.dart';
import 'package:coffeeshop_app/features/account/data/models/referral_history_model.dart';
import 'package:coffeeshop_app/features/account/data/repositories/referral_repository_impl.dart';
import 'package:coffeeshop_app/features/account/domain/entities/referral_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

typedef ReferralData = ({String code, List<ReferralHistoryEntry> history});

void main() {
  group('ReferralRepositoryImpl.getReferral', () {
    test('returns the code and history from the data source', () async {
      final dataSource = _FakeReferralDataSource()..code = 'SHARE10';
      final repository = ReferralRepositoryImpl(dataSource);

      final result = await repository.getReferral();

      final data = (result as Success<ReferralData>).data;
      expect(data.code, 'SHARE10');
      expect(data.history, hasLength(1));
      expect(data.history.first.referredEmail, 'friend@a.com');
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ReferralRepositoryImpl(
        _FakeReferralDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.getReferral();

      expect(
        (result as Error<ReferralData>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps a server exception to the referral failure key', () async {
      final repository = ReferralRepositoryImpl(
        _FakeReferralDataSource()..error = const ServerException(),
      );

      final result = await repository.getReferral();

      expect(
        (result as Error<ReferralData>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.referral_failed',
        ),
      );
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = ReferralRepositoryImpl(
        _FakeReferralDataSource()..error = StateError('boom'),
      );

      final result = await repository.getReferral();

      expect(
        (result as Error<ReferralData>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('ReferralRepositoryImpl.applyReferral', () {
    test('forwards the code and succeeds', () async {
      final dataSource = _FakeReferralDataSource();
      final repository = ReferralRepositoryImpl(dataSource);

      final result = await repository.applyReferral('SHARE10');

      expect(result, isA<Success<void>>());
      expect(dataSource.lastCode, 'SHARE10');
    });

    test('prefers the server message when the exception carries one', () async {
      final repository = ReferralRepositoryImpl(
        _FakeReferralDataSource()
          ..error = const ServerException('invalid code'),
      );

      final result = await repository.applyReferral('SHARE10');

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having((f) => f.message, 'message', 'invalid code'),
      );
    });

    test('maps a message-less server exception to the apply failure key',
        () async {
      final repository = ReferralRepositoryImpl(
        _FakeReferralDataSource()..error = const ServerException(),
      );

      final result = await repository.applyReferral('SHARE10');

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.referral_apply_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ReferralRepositoryImpl(
        _FakeReferralDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.applyReferral('SHARE10');

      expect(
        (result as Error<void>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = ReferralRepositoryImpl(
        _FakeReferralDataSource()..error = StateError('boom'),
      );

      final result = await repository.applyReferral('SHARE10');

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });
}

ReferralHistoryModel _entry() => ReferralHistoryModel(
  referredEmail: 'friend@a.com',
  pointsEarned: 50,
  createdAt: DateTime(2026, 1, 1),
);

class _FakeReferralDataSource implements ReferralDataSource {
  String code = 'CODE1';
  Object? error;
  String? lastCode;

  void _maybeThrow() {
    final error = this.error;
    if (error != null) throw error;
  }

  @override
  Future<({String code, List<ReferralHistoryModel> history})>
  getReferral() async {
    _maybeThrow();
    return (code: code, history: [_entry()]);
  }

  @override
  Future<void> applyReferral(String code) async {
    _maybeThrow();
    lastCode = code;
  }
}
