import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final GetLoyaltyPointsUseCase _getLoyaltyPoints;
  final UploadAvatarUseCase _uploadAvatar;
  final ChangeEmailUseCase _changeEmail;
  final void Function(ConnectionFailure)? onConnectionFailure;

  ProfileCubit({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
    required GetLoyaltyPointsUseCase getLoyaltyPoints,
    required UploadAvatarUseCase uploadAvatar,
    required ChangeEmailUseCase changeEmail,
    this.onConnectionFailure,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       _getLoyaltyPoints = getLoyaltyPoints,
       _uploadAvatar = uploadAvatar,
       _changeEmail = changeEmail,
       super(const ProfileInitial());

  Future<void> loadProfile({int? cacheBuster}) async {
    final currentBuster = state is ProfileLoaded
        ? (state as ProfileLoaded).avatarCacheBuster
        : 0;
    final buster = cacheBuster ?? currentBuster;

    emit(const ProfileLoading());

    final profileResult = await _getProfile();
    final pointsResult = await _getLoyaltyPoints();

    profileResult.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(ProfileError(failure.message));
      },
      (profile) => pointsResult.fold(
        (failure) {
          if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
          emit(ProfileError(failure.message));
        },
        (points) => emit(
          ProfileLoaded(
            profile: profile,
            loyaltyPoints: points,
            avatarCacheBuster: buster,
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    final current = state;
    if (current is! ProfileLoaded && current is! ProfileUpdating) return;

    final currentBuster = current is ProfileLoaded
        ? current.avatarCacheBuster
        : (current is ProfileUpdating ? current.avatarCacheBuster : 0);

    if (current is ProfileLoaded) {
      emit(
        ProfileUpdating(
          profile: current.profile,
          loyaltyPoints: current.loyaltyPoints,
          avatarCacheBuster: currentBuster,
        ),
      );
    }

    final result = await _updateProfile(updatedProfile);
    result.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        loadProfile(cacheBuster: currentBuster);
      },
      (profile) => emit(
        ProfileLoaded(
          profile: profile,
          loyaltyPoints: current is ProfileLoaded ? current.loyaltyPoints : 0.0,
          avatarCacheBuster: currentBuster,
        ),
      ),
    );
  }

  Future<void> uploadAvatar(String filePath) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    final result = await _uploadAvatar(filePath);
    result.fold(
      (_) {
        /* Non-fatal — user can retry */
      },
      (newAvatarUrl) async {
        final cacheBuster = DateTime.now().millisecondsSinceEpoch;
        final baseUrl = ApiConstants.apiBaseUrl.replaceAll('/api/v1', '');

        if (current.profile.avatarUrl != null) {
          final fullOld = '$baseUrl${current.profile.avatarUrl}';
          CachedNetworkImage.evictFromCache(fullOld);
        }
        if (newAvatarUrl != null) {
          final fullNew = '$baseUrl$newAvatarUrl';
          CachedNetworkImage.evictFromCache(fullNew);
        }
        await loadProfile(cacheBuster: cacheBuster);
      },
    );
  }

  Future<void> changeEmail(String newEmail, String password) async {
    final result = await _changeEmail(newEmail, password);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => loadProfile(),
    );
  }

  Future<void> refreshLoyalty() async {
    final currentBuster = state is ProfileLoaded
        ? (state as ProfileLoaded).avatarCacheBuster
        : 0;

    final result = await _getLoyaltyPoints();
    result.fold((_) => loadProfile(cacheBuster: currentBuster), (points) {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(
          ProfileLoaded(
            profile: current.profile,
            loyaltyPoints: points,
            avatarCacheBuster: currentBuster,
          ),
        );
      } else {
        loadProfile(cacheBuster: currentBuster);
      }
    });
  }
}
