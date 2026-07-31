import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.avatarUrl,
    super.gender,
    super.state,
    super.city,
    super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      gender: json['gender'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      isVerified: (json['is_verified'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar_url': avatarUrl,
      'gender': gender,
      'state': state,
      'city': city,
      'is_verified': isVerified,
    };
  }
}
