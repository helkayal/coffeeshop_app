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

  const ProfileLoaded({required this.profile, required this.loyaltyPoints});
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {
  final UserProfile profile;
  final double loyaltyPoints;

  const ProfileUpdating({required this.profile, required this.loyaltyPoints});
}
