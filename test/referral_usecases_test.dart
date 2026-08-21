import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/domain/entities/referral_history_entry.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/referral_repository.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/referral_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetReferralUseCase', () {
    test('returns the referral code and history from the repository', () async {
      final repository = _FakeReferralRepository()..code = 'SHARE10';

      final result = await GetReferralUseCase(repository)();

      final data =
          (result as Success<({String code, List<ReferralHistoryEntry> history})>)
              .data;
      expect(data.code, 'SHARE10');
      expect(data.history, hasLength(1));
      expect(data.history.first.referredEmail, 'friend@a.com');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeReferralRepository()
        ..failure = const ServerFailure('errors.referral_failed');

      final result = await GetReferralUseCase(repository)();

      expect(result, isA<Error<({String code, List<ReferralHistoryEntry> history})>>());
      expect(
        (result as Error<({String code, List<ReferralHistoryEntry> history})>)
            .failure
            .message,
        'errors.referral_failed',
      );
    });
  });

  group('ApplyReferralUseCase', () {
    test('forwards the code to the repository', () async {
      final repository = _FakeReferralRepository();
      final useCase = ApplyReferralUseCase(repository);

      final result = await useCase('SHARE10');

      expect(result, isA<Success<void>>());
      expect(repository.lastCode, 'SHARE10');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeReferralRepository()
        ..failure = const ServerFailure('errors.referral_apply_failed');

      final result = await ApplyReferralUseCase(repository)('SHARE10');

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure.message,
          'errors.referral_apply_failed');
    });
  });
}

ReferralHistoryEntry _entry() => ReferralHistoryEntry(
  referredEmail: 'friend@a.com',
  pointsEarned: 50,
  createdAt: DateTime(2026, 1, 1),
);

class _FakeReferralRepository implements ReferralRepository {
  String code = 'CODE1';
  List<ReferralHistoryEntry> history = [_entry()];
  Failure? failure;
  String? lastCode;

  @override
  Future<Result<({String code, List<ReferralHistoryEntry> history})>>
  getReferral() async {
    final failure = this.failure;
    return failure == null
        ? Success((code: code, history: history))
        : Error(failure);
  }

  @override
  Future<Result<void>> applyReferral(String code) async {
    lastCode = code;
    final failure = this.failure;
    return failure == null ? const Success(null) : Error(failure);
  }
}
