class AuthAccount {
  const AuthAccount({
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.city,
  });

  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? city;

  AuthAccount copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
  }) {
    return AuthAccount(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
    );
  }
}
