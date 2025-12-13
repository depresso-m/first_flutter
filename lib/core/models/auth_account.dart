class AuthAccount {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? city;
  final DateTime? createdAt;

  const AuthAccount({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.city,
    this.createdAt,
  });

  String get fullName {
    final parts = <String>[];
    if (firstName != null && firstName!.isNotEmpty) {
      parts.add(firstName!);
    }
    if (lastName != null && lastName!.isNotEmpty) {
      parts.add(lastName!);
    }
    if (parts.isEmpty) return email;
    return parts.join(' ');
  }

  String get initials {
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    if (first.isEmpty && last.isEmpty) {
      return email.isNotEmpty ? email[0].toUpperCase() : '?';
    }
    return '$first$last'.toUpperCase();
  }

  bool get hasCompleteProfile =>
      firstName != null &&
      firstName!.isNotEmpty &&
      lastName != null &&
      lastName!.isNotEmpty &&
      phone != null &&
      phone!.isNotEmpty;

  bool get hasPhone => phone != null && phone!.isNotEmpty;

  bool get hasCity => city != null && city!.isNotEmpty;

  AuthAccount copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
    DateTime? createdAt,
  }) {
    return AuthAccount(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAccount && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AuthAccount(id: $id, email: $email, name: $fullName)';
}
