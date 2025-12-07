class Pharmacy {
  final String id;
  final String address;
  final String workingHours;
  final String phone;
  final String email;

  const Pharmacy({
    required this.id,
    required this.address,
    required this.workingHours,
    required this.phone,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pharmacy && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

