import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final GetLoyaltyPointsUseCase _getLoyaltyPoints;
  final ApiService _api;

  ProfileCubit({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
    required GetLoyaltyPointsUseCase getLoyaltyPoints,
    required ApiService apiService,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _getLoyaltyPoints = getLoyaltyPoints,
        _api = apiService,
        super(const ProfileInitial());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final profileResult = await _getProfile();
    final pointsResult = await _getLoyaltyPoints();

    profileResult.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => pointsResult.fold(
        (failure) => emit(ProfileError(failure.message)),
        (points) => emit(ProfileLoaded(profile: profile, loyaltyPoints: points)),
      ),
    );
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    final current = state;
    if (current is! ProfileLoaded && current is! ProfileUpdating) return;

    if (current is ProfileLoaded) {
      emit(ProfileUpdating(
        profile: current.profile,
        loyaltyPoints: current.loyaltyPoints,
      ));
    }

    final result = await _updateProfile(updatedProfile);
    result.fold(
      (_) => loadProfile(),
      (profile) => emit(ProfileLoaded(
        profile: profile,
        loyaltyPoints: current is ProfileLoaded
            ? current.loyaltyPoints
            : 0.0,
      )),
    );
  }

  Future<void> uploadAvatar(String filePath) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      await _api.post(
        ApiConstants.profileAvatar,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      await loadProfile();
    } catch (_) {
      // Non-fatal — user can retry.
    }
  }

  Future<void> changeEmail(String newEmail, String password) async {
    try {
      await _api.post(
        ApiConstants.profileChangeEmail,
        data: {'new_email': newEmail, 'password': password},
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> refreshLoyalty() async {
    final result = await _getLoyaltyPoints();
    result.fold(
      (_) => loadProfile(),
      (points) {
        if (state is ProfileLoaded) {
          final current = state as ProfileLoaded;
          emit(ProfileLoaded(profile: current.profile, loyaltyPoints: points));
        } else {
          loadProfile();
        }
      },
    );
  }
}
