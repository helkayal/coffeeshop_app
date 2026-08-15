import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.gender,
    super.state,
    super.city,
    super.avatarUrl,
    super.dateOfBirth,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      email: json['email'] as String,
      gender: json['gender'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    if (gender != null) 'gender': gender,
    if (state != null) 'state': state,
    if (city != null) 'city': city,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
    if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
  };
}
