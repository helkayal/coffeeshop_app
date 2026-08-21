import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/domain/entities/loyalty_history_entry.dart';
import 'package:coffeeshop_app/features/account/domain/entities/user_profile.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/profile_repository.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/profile_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetProfileUseCase', () {
    test('returns the profile fetched from the repository', () async {
      final result = await GetProfileUseCase(_FakeProfileRepository())();

      expect((result as Success<UserProfile>).data.email, 'a@b.com');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeProfileRepository()
        ..failure = const ServerFailure('errors.profile_load_failed');

      final result = await GetProfileUseCase(repository)();

      expect(result, isA<Error<UserProfile>>());
      expect((result as Error<UserProfile>).failure.message,
          'errors.profile_load_failed');
    });
  });

  group('UpdateProfileUseCase', () {
    test('forwards the profile to the repository', () async {
      final repository = _FakeProfileRepository();
      final useCase = UpdateProfileUseCase(repository);
      final profile = _updatedProfile();

      final result = await useCase(profile);

      expect((result as Success<UserProfile>).data.firstName, 'New');
      expect(repository.updatedProfile, same(profile));
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeProfileRepository()
        ..failure = const ServerFailure('errors.profile_update_failed');

      final result = await UpdateProfileUseCase(repository)(_updatedProfile());

      expect(result, isA<Error<UserProfile>>());
      expect((result as Error<UserProfile>).failure.message,
          'errors.profile_update_failed');
    });
  });

  group('GetLoyaltyPointsUseCase', () {
    test('returns the loyalty points from the repository', () async {
      final repository = _FakeProfileRepository()..points = 42.5;

      final result = await GetLoyaltyPointsUseCase(repository)();

      expect((result as Success<double>).data, 42.5);
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeProfileRepository()
        ..failure = const ServerFailure('errors.loyalty_points_failed');

      final result = await GetLoyaltyPointsUseCase(repository)();

      expect(result, isA<Error<double>>());
      expect((result as Error<double>).failure.message,
          'errors.loyalty_points_failed');
    });
  });

  group('GetLoyaltyHistoryUseCase', () {
    test('returns the loyalty history from the repository', () async {
      final result = await GetLoyaltyHistoryUseCase(_FakeProfileRepository())();

      final history = (result as Success<List<LoyaltyHistoryEntry>>).data;
      expect(history, hasLength(1));
      expect(history.first.reason, 'welcome');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeProfileRepository()
        ..failure = const ServerFailure('errors.loyalty_history_failed');

      final result = await GetLoyaltyHistoryUseCase(repository)();

      expect(result, isA<Error<List<LoyaltyHistoryEntry>>>());
      expect((result as Error<List<LoyaltyHistoryEntry>>).failure.message,
          'errors.loyalty_history_failed');
    });
  });

  group('UploadAvatarUseCase', () {
    test('forwards the file path and returns the uploaded avatar url',
        () async {
      final repository = _FakeProfileRepository()..avatarUrl = '/new.png';

      final result = await UploadAvatarUseCase(repository)('/tmp/pic.png');

      expect((result as Success<String?>).data, '/new.png');
      expect(repository.lastAvatarPath, '/tmp/pic.png');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeProfileRepository()
        ..failure = const ServerFailure('errors.avatar_upload_failed');

      final result = await UploadAvatarUseCase(repository)('/tmp/pic.png');

      expect(result, isA<Error<String?>>());
      expect((result as Error<String?>).failure.message,
          'errors.avatar_upload_failed');
    });
  });

  group('ChangeEmailUseCase', () {
    test('forwards the new email and password to the repository', () async {
      final repository = _FakeProfileRepository();
      final useCase = ChangeEmailUseCase(repository);

      final result = await useCase('new@a.com', 'secret');

      expect(result, isA<Success<void>>());
      expect(repository.lastEmail, 'new@a.com');
      expect(repository.lastPassword, 'secret');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeProfileRepository()
        ..failure = const ServerFailure('errors.email_change_failed');

      final result = await ChangeEmailUseCase(repository)('new@a.com', 'x');

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure.message,
          'errors.email_change_failed');
    });
  });
}

const UserProfile _profile = UserProfile(
  id: 'u1',
  firstName: 'Ana',
  lastName: 'Smith',
  email: 'a@b.com',
);

UserProfile _updatedProfile() => const UserProfile(
  id: 'u1',
  firstName: 'New',
  lastName: 'Name',
  email: 'a@b.com',
);

LoyaltyHistoryEntry _entry() => LoyaltyHistoryEntry(
  points: 10,
  reason: 'welcome',
  createdAt: DateTime(2026, 1, 1),
);

class _FakeProfileRepository implements ProfileRepository {
  UserProfile profile = _profile;
  double points = 10;
  List<LoyaltyHistoryEntry> history = [_entry()];
  String? avatarUrl = '/avatar.png';
  Failure? failure;
  UserProfile? updatedProfile;
  String? lastEmail;
  String? lastPassword;
  String? lastAvatarPath;

  @override
  Future<Result<UserProfile>> getProfile() async {
    final failure = this.failure;
    return failure == null ? Success(profile) : Error(failure);
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) async {
    updatedProfile = profile;
    final failure = this.failure;
    return failure == null ? Success(profile) : Error(failure);
  }

  @override
  Future<Result<double>> getLoyaltyPoints() async {
    final failure = this.failure;
    return failure == null ? Success(points) : Error(failure);
  }

  @override
  Future<Result<List<LoyaltyHistoryEntry>>> getLoyaltyHistory() async {
    final failure = this.failure;
    return failure == null ? Success(history) : Error(failure);
  }

  @override
  Future<Result<String?>> uploadAvatar(String filePath) async {
    lastAvatarPath = filePath;
    final failure = this.failure;
    return failure == null ? Success(avatarUrl) : Error(failure);
  }

  @override
  Future<Result<void>> changeEmail(String newEmail, String password) async {
    lastEmail = newEmail;
    lastPassword = password;
    final failure = this.failure;
    return failure == null ? const Success(null) : Error(failure);
  }
}
