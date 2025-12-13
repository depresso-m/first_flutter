class Pharmacy {
  final String id;
  final String address;
  final String workingHours;
  final String phone;
  final String email;
  final double? latitude;
  final double? longitude;

  const Pharmacy({
    required this.id,
    required this.address,
    required this.workingHours,
    required this.phone,
    required this.email,
    this.latitude,
    this.longitude,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  bool get isOpen24Hours =>
      workingHours.toLowerCase().contains('круглосуточно');

  String get formattedPhone => phone.replaceAll(RegExp(r'[^\d+]'), '');

  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return address.toLowerCase().contains(lowerQuery) ||
        phone.contains(query) ||
        email.toLowerCase().contains(lowerQuery);
  }

  Pharmacy copyWith({
    String? id,
    String? address,
    String? workingHours,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
  }) {
    return Pharmacy(
      id: id ?? this.id,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pharmacy && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Pharmacy(id: $id, address: $address)';
}
