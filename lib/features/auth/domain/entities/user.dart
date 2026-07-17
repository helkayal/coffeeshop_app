import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatarUrl;
  final String? gender;
  final String? state;
  final String? city;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatarUrl,
    this.gender,
    this.state,
    this.city,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        avatarUrl,
        gender,
        state,
        city,
      ];
}
