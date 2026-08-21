import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/data/datasources/profile_data_source.dart';
import 'package:coffeeshop_app/features/account/data/models/loyalty_history_model.dart';
import 'package:coffeeshop_app/features/account/data/models/user_profile_model.dart';
import 'package:coffeeshop_app/features/account/data/repositories/profile_repository_impl.dart';
import 'package:coffeeshop_app/features/account/domain/entities/loyalty_history_entry.dart';
import 'package:coffeeshop_app/features/account/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileRepositoryImpl.getProfile', () {
    test('returns the profile from the data source', () async {
      final repository = ProfileRepositoryImpl(_FakeProfileDataSource());

      final result = await repository.getProfile();

      expect((result as Success<UserProfile>).data.email, 'a@b.com');
    });

    test('maps a server exception to the default load failure key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ServerException(),
      );

      final result = await repository.getProfile();

      expect(
        (result as Error<UserProfile>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.profile_load_failed',
        ),
      );
    });

    test('prefers the server message when the exception carries one', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ServerException('server said no'),
      );

      final result = await repository.getProfile();

      expect(
        (result as Error<UserProfile>).failure,
        isA<ServerFailure>().having((f) => f.message, 'message', 'server said no'),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.getProfile();

      expect(
        (result as Error<UserProfile>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = StateError('boom'),
      );

      final result = await repository.getProfile();

      expect(
        (result as Error<UserProfile>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('ProfileRepositoryImpl.updateProfile', () {
    test('forwards the profile and returns the updated profile', () async {
      final dataSource = _FakeProfileDataSource();
      final repository = ProfileRepositoryImpl(dataSource);
      const profile = _updated;

      final result = await repository.updateProfile(profile);

      expect((result as Success<UserProfile>).data.firstName, 'New');
      expect(dataSource.updated, same(profile));
    });

    test('maps a server exception to the update failure key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ServerException(),
      );

      final result = await repository.updateProfile(_updated);

      expect(
        (result as Error<UserProfile>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.profile_update_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.updateProfile(_updated);

      expect(
        (result as Error<UserProfile>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = StateError('boom'),
      );

      final result = await repository.updateProfile(_updated);

      expect(
        (result as Error<UserProfile>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('ProfileRepositoryImpl.getLoyaltyPoints', () {
    test('returns the loyalty balance', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..points = 77,
      );

      final result = await repository.getLoyaltyPoints();

      expect((result as Success<double>).data, 77);
    });

    test('maps a server exception to the loyalty failure key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ServerException(),
      );

      final result = await repository.getLoyaltyPoints();

      expect(
        (result as Error<double>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.loyalty_points_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.getLoyaltyPoints();

      expect(
        (result as Error<double>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = StateError('boom'),
      );

      final result = await repository.getLoyaltyPoints();

      expect(
        (result as Error<double>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('ProfileRepositoryImpl.getLoyaltyHistory', () {
    test('returns the loyalty history from the data source', () async {
      final repository = ProfileRepositoryImpl(_FakeProfileDataSource());

      final result = await repository.getLoyaltyHistory();

      final history = (result as Success<List<LoyaltyHistoryEntry>>).data;
      expect(history, hasLength(1));
      expect(history.first.reason, 'welcome');
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.getLoyaltyHistory();

      expect(
        (result as Error<List<LoyaltyHistoryEntry>>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps a server exception to the history failure key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ServerException(),
      );

      final result = await repository.getLoyaltyHistory();

      expect(
        (result as Error<List<LoyaltyHistoryEntry>>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.loyalty_history_failed',
        ),
      );
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = StateError('boom'),
      );

      final result = await repository.getLoyaltyHistory();

      expect(
        (result as Error<List<LoyaltyHistoryEntry>>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('ProfileRepositoryImpl.uploadAvatar', () {
    test('forwards the path and returns the uploaded avatar url', () async {
      final dataSource = _FakeProfileDataSource()..avatarUrl = '/new.png';
      final repository = ProfileRepositoryImpl(dataSource);

      final result = await repository.uploadAvatar('/tmp/pic.png');

      expect((result as Success<String?>).data, '/new.png');
      expect(dataSource.lastUploadedPath, '/tmp/pic.png');
    });

    test('returns null when the data source has no avatar url', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..avatarUrl = null,
      );

      final result = await repository.uploadAvatar('/tmp/pic.png');

      expect((result as Success<String?>).data, isNull);
    });

    test('maps a server exception to the avatar failure key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ServerException(),
      );

      final result = await repository.uploadAvatar('/tmp/pic.png');

      expect(
        (result as Error<String?>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.avatar_upload_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.uploadAvatar('/tmp/pic.png');

      expect(
        (result as Error<String?>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = StateError('boom'),
      );

      final result = await repository.uploadAvatar('/tmp/pic.png');

      expect(
        (result as Error<String?>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('ProfileRepositoryImpl.changeEmail', () {
    test('forwards the email and password and succeeds', () async {
      final dataSource = _FakeProfileDataSource();
      final repository = ProfileRepositoryImpl(dataSource);

      final result = await repository.changeEmail('new@a.com', 'secret');

      expect(result, isA<Success<void>>());
      expect(dataSource.lastEmail, 'new@a.com');
      expect(dataSource.lastPassword, 'secret');
    });

    test('maps a server exception to the email change failure key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ServerException(),
      );

      final result = await repository.changeEmail('new@a.com', 'secret');

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.email_change_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.changeEmail('new@a.com', 'secret');

      expect(
        (result as Error<void>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = ProfileRepositoryImpl(
        _FakeProfileDataSource()..error = StateError('boom'),
      );

      final result = await repository.changeEmail('new@a.com', 'secret');

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

const UserProfileModel _profile = UserProfileModel(
  id: 'u1',
  firstName: 'Ana',
  lastName: 'Smith',
  email: 'a@b.com',
);

const UserProfile _updated = UserProfile(
  id: 'u1',
  firstName: 'New',
  lastName: 'Name',
  email: 'a@b.com',
);

LoyaltyHistoryModel _entry() => LoyaltyHistoryModel(
  points: 10,
  reason: 'welcome',
  createdAt: DateTime(2026, 1, 1),
);

class _FakeProfileDataSource implements ProfileDataSource {
  UserProfileModel profile = _profile;
  double points = 10;
  List<LoyaltyHistoryModel> history = [_entry()];
  String? avatarUrl = '/avatar.png';
  Object? error;
  UserProfile? updated;
  String? lastEmail;
  String? lastPassword;
  String? lastUploadedPath;

  void _maybeThrow() {
    final error = this.error;
    if (error != null) throw error;
  }

  @override
  Future<UserProfileModel> getProfile() async {
    _maybeThrow();
    return profile;
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfile profile) async {
    _maybeThrow();
    updated = profile;
    return UserProfileModel(
      id: profile.id,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
    );
  }

  @override
  Future<double> getLoyaltyPoints() async {
    _maybeThrow();
    return points;
  }

  @override
  Future<List<LoyaltyHistoryModel>> getLoyaltyHistory() async {
    _maybeThrow();
    return history;
  }

  @override
  Future<String?> uploadAvatar(String filePath) async {
    _maybeThrow();
    lastUploadedPath = filePath;
    return avatarUrl;
  }

  @override
  Future<void> changeEmail(String newEmail, String password) async {
    _maybeThrow();
    lastEmail = newEmail;
    lastPassword = password;
  }
}
