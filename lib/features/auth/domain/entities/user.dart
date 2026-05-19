import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePictureUrl;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, profilePictureUrl];
}
