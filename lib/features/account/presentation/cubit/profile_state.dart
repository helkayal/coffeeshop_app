import '../../domain/entities/user_profile.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  final double loyaltyPoints;
  final int avatarCacheBuster;

  const ProfileLoaded({
    required this.profile,
    required this.loyaltyPoints,
    this.avatarCacheBuster = 0,
  });
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {
  final UserProfile profile;
  final double loyaltyPoints;
  final int avatarCacheBuster;

  const ProfileUpdating({
    required this.profile,
    required this.loyaltyPoints,
    this.avatarCacheBuster = 0,
  });
}
