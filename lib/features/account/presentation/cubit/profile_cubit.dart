import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final GetLoyaltyPointsUseCase _getLoyaltyPoints;

  ProfileCubit({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
    required GetLoyaltyPointsUseCase getLoyaltyPoints,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _getLoyaltyPoints = getLoyaltyPoints,
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
    if (current is! ProfileLoaded) return;

    emit(ProfileUpdating(
      profile: current.profile,
      loyaltyPoints: current.loyaltyPoints,
    ));

    final result = await _updateProfile(updatedProfile);
    result.fold(
      (failure) => emit(ProfileLoaded(
        profile: current.profile,
        loyaltyPoints: current.loyaltyPoints,
      )),
      (profile) => emit(ProfileLoaded(
        profile: profile,
        loyaltyPoints: current.loyaltyPoints,
      )),
    );
  }
}
