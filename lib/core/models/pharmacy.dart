import 'geo_point.dart';

class Pharmacy {
  final String id;
  final String? name;
  final String address;
  final String workingHours;
  final String phone;
  final String email;
  final double? latitude;
  final double? longitude;
  
  // OSM/Overpass fields
  final String? operator;
  final String? brand;
  final String? website;
  final bool isWheelchairAccessible;

  const Pharmacy({
    required this.id,
    this.name,
    required this.address,
    required this.workingHours,
    required this.phone,
    required this.email,
    this.latitude,
    this.longitude,
    this.operator,
    this.brand,
    this.website,
    this.isWheelchairAccessible = false,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  bool get isOpen24Hours =>
      workingHours.toLowerCase().contains('круглосуточно');

  String get formattedPhone => phone.replaceAll(RegExp(r'[^\d+]'), '');

  /// Display name - prefers name, falls back to brand or operator
  String get displayName => name ?? brand ?? operator ?? 'Аптека';

  /// Get GeoPoint if coordinates available
  GeoPoint? get location => hasCoordinates 
      ? GeoPoint(latitude: latitude!, longitude: longitude!) 
      : null;

  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return address.toLowerCase().contains(lowerQuery) ||
        phone.contains(query) ||
        email.toLowerCase().contains(lowerQuery) ||
        (name?.toLowerCase().contains(lowerQuery) ?? false) ||
        (brand?.toLowerCase().contains(lowerQuery) ?? false) ||
        (operator?.toLowerCase().contains(lowerQuery) ?? false);
  }

  Pharmacy copyWith({
    String? id,
    String? name,
    String? address,
    String? workingHours,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
    String? operator,
    String? brand,
    String? website,
    bool? isWheelchairAccessible,
  }) {
    return Pharmacy(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      operator: operator ?? this.operator,
      brand: brand ?? this.brand,
      website: website ?? this.website,
      isWheelchairAccessible: isWheelchairAccessible ?? this.isWheelchairAccessible,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pharmacy && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Pharmacy(id: $id, name: $displayName, address: $address)';
}
