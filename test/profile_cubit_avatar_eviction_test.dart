import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffeeshop_app/core/constants/api_constants.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/domain/entities/loyalty_history_entry.dart';
import 'package:coffeeshop_app/features/account/domain/entities/user_profile.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/profile_repository.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/profile_usecases.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/profile_state.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeCacheManager cacheManager;

  setUp(() {
    cacheManager = _FakeCacheManager();
    CachedNetworkImageProvider.defaultCacheManager = cacheManager;
  });

  String baseUrl() => ApiConstants.apiBaseUrl.replaceAll('/api/v1', '');

  test('evicts the old and new avatar from the image cache after upload',
      () async {
    final cubit = _cubit(avatarUrl: '/avatars/new.png');
    await cubit.loadProfile();
    await cubit.uploadAvatar('/tmp/pic.png');
    await pumpEventQueue();

    expect(cacheManager.removedKeys, [
      '${baseUrl()}/avatars/old.png',
      '${baseUrl()}/avatars/new.png',
    ]);
    final state = cubit.state as ProfileLoaded;
    // Reloaded with a fresh cache buster so the avatar re-downloads.
    expect(state.avatarCacheBuster, greaterThan(0));
    expect(state.loyaltyPoints, 5.0);
    await cubit.close();
  });

  test('evicts only the old avatar when the upload returns no url', () async {
    final cubit = _cubit(avatarUrl: null);
    await cubit.loadProfile();
    await cubit.uploadAvatar('/tmp/pic.png');
    await pumpEventQueue();

    expect(cacheManager.removedKeys, ['${baseUrl()}/avatars/old.png']);
    await cubit.close();
  });

  test('does not evict the old avatar when the current profile has none',
      () async {
    final cubit = _cubit(
      profile: _profileWithoutAvatar,
      avatarUrl: '/avatars/new.png',
    );
    await cubit.loadProfile();
    await cubit.uploadAvatar('/tmp/pic.png');
    await pumpEventQueue();

    expect(cacheManager.removedKeys, ['${baseUrl()}/avatars/new.png']);
    await cubit.close();
  });

  test('leaves the cache and state untouched when the upload fails', () async {
    final cubit = _cubit(
      uploadFailure: const ServerFailure('errors.avatar_upload_failed'),
    );
    await cubit.loadProfile();
    await cubit.uploadAvatar('/tmp/pic.png');
    await pumpEventQueue();

    expect(cacheManager.removedKeys, isEmpty);
    final state = cubit.state as ProfileLoaded;
    expect(state.avatarCacheBuster, 0);
    expect(state.profile.avatarUrl, '/avatars/old.png');
    await cubit.close();
  });

  test('does nothing when the profile is not loaded', () async {
    final cubit = _cubit();
    await cubit.uploadAvatar('/tmp/pic.png');
    await pumpEventQueue();

    expect(cacheManager.removedKeys, isEmpty);
    expect(cubit.state, isA<ProfileInitial>());
    await cubit.close();
  });
}

const UserProfile _profile = UserProfile(
  id: 'u1',
  firstName: 'Ana',
  lastName: 'Smith',
  email: 'a@b.com',
  avatarUrl: '/avatars/old.png',
);

const UserProfile _profileWithoutAvatar = UserProfile(
  id: 'u1',
  firstName: 'Ana',
  lastName: 'Smith',
  email: 'a@b.com',
);

ProfileCubit _cubit({
  UserProfile profile = _profile,
  String? avatarUrl = '/avatars/new.png',
  Failure? uploadFailure,
}) => ProfileCubit(
  getProfile: GetProfileUseCase(_FakeProfileRepository(profile: profile)),
  updateProfile: UpdateProfileUseCase(_FakeProfileRepository()),
  getLoyaltyPoints: GetLoyaltyPointsUseCase(_FakeProfileRepository()),
  uploadAvatar: UploadAvatarUseCase(
    _FakeProfileRepository(avatarUrl: avatarUrl, uploadFailure: uploadFailure),
  ),
  changeEmail: ChangeEmailUseCase(_FakeProfileRepository()),
);

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({
    this.profile = _profile,
    this.avatarUrl = '/avatars/new.png',
    this.uploadFailure,
  });

  final UserProfile profile;
  final String? avatarUrl;
  final Failure? uploadFailure;

  @override
  Future<Result<UserProfile>> getProfile() async => Success(profile);

  @override
  Future<Result<double>> getLoyaltyPoints() async => const Success(5.0);

  @override
  Future<Result<String?>> uploadAvatar(String filePath) async {
    final failure = uploadFailure;
    return failure == null ? Success(avatarUrl) : Error(failure);
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) =>
      throw UnimplementedError();

  @override
  Future<Result<List<LoyaltyHistoryEntry>>> getLoyaltyHistory() =>
      throw UnimplementedError();

  @override
  Future<Result<void>> changeEmail(String newEmail, String password) =>
      throw UnimplementedError();
}

class _FakeCacheManager implements CacheManager {
  final removedKeys = <String>[];

  @override
  Future<void> removeFile(String key) async => removedKeys.add(key);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
