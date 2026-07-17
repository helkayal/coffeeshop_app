class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;
  final String? state;
  final String? city;
  final String? avatarUrl;
  final String? dateOfBirth;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender,
    this.state,
    this.city,
    this.avatarUrl,
    this.dateOfBirth,
  });

  String get fullName => '$firstName $lastName';
}
