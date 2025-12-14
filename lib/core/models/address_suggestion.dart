/// Represents an address suggestion from DaData API
class AddressSuggestion {
  final String value;
  final String unrestrictedValue;
  final AddressData data;

  const AddressSuggestion({
    required this.value,
    required this.unrestrictedValue,
    required this.data,
  });

  /// Display text for UI
  String get displayText => value;

  /// Check if this suggestion has coordinates
  bool get hasCoordinates => data.geoLat != null && data.geoLon != null;

  @override
  String toString() => 'AddressSuggestion($value)';
}

/// Detailed address data from DaData
class AddressData {
  final String? city;
  final String? cityFiasId;
  final String? cityWithType;
  final String? street;
  final String? streetWithType;
  final String? house;
  final String? block;
  final String? flat;
  final String? postalCode;
  final double? geoLat;
  final double? geoLon;
  final String? region;
  final String? regionWithType;

  const AddressData({
    this.city,
    this.cityFiasId,
    this.cityWithType,
    this.street,
    this.streetWithType,
    this.house,
    this.block,
    this.flat,
    this.postalCode,
    this.geoLat,
    this.geoLon,
    this.region,
    this.regionWithType,
  });

  /// Get formatted city name with region
  String get cityDisplay {
    if (cityWithType != null) {
      if (regionWithType != null && regionWithType != cityWithType) {
        return '$cityWithType, $regionWithType';
      }
      return cityWithType!;
    }
    return city ?? '';
  }

  /// Get formatted street address
  String get streetDisplay {
    final parts = <String>[];
    if (streetWithType != null) parts.add(streetWithType!);
    if (house != null) parts.add('д. $house');
    if (block != null) parts.add('корп. $block');
    if (flat != null) parts.add('кв. $flat');
    return parts.join(', ');
  }
}
